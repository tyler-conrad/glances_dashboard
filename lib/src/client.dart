import 'dart:convert' as convert;
import 'dart:async' as a;

import 'package:built_collection/built_collection.dart' as bc;

import 'package:http/http.dart' as http;
import 'package:http_retry/http_retry.dart' as retry;

import 'model.dart' as model;
import 'serializers.dart' as serializers;

List<dynamic> decodeJsonListFromString({required String string}) {
  return convert.jsonDecode(
    convert.utf8.decode(
      string.runes.toList(),
    ),
  );
}

Map<String, dynamic> decodeJsonMapFromString({required String string}) {
  return convert.jsonDecode(
    convert.utf8.decode(string.runes.toList()),
  );
}

DateTime get _now => DateTime.now().toUtc();

class Wrapper<T> {
  T value;
  Wrapper(this.value);
}

class StreamState<M extends model.StreamModel> {
  final Future<model.TimeStamp<M>> Function() _modelFunc;
  final List<model.StreamIndex<M>> history;
  final a.StreamController<Future<model.TimeStamp<M>>> _controller;
  final a.StreamSubscription<model.TimeStamp<M>> _subscription;
  final Duration _pollInterval;
  final Duration _historyRetentionPeriod;
  final Wrapper<int> _streamIndex;

  static a.StreamController<Future<model.TimeStamp<M>>>
      _periodic<M extends model.StreamModel>({
    required Duration period,
    required Future<model.TimeStamp<M>> Function(int) computation,
  }) {
    var controller = a.StreamController<Future<model.TimeStamp<M>>>(sync: true);
    // Counts the time that the Stream was running (and not paused).
    Stopwatch watch = Stopwatch();
    controller.onListen = () {
      int computationCount = 0;
      void sendEvent(_) {
        watch.reset();
        Future<model.TimeStamp<M>> event;
        try {
          event = computation(
            computationCount++,
          );
        } catch (e, s) {
          controller.addError(
            e,
            s,
          );
          return;
        }
        controller.add(
          event,
        );
      }

      a.Timer timer = a.Timer.periodic(
        period,
        sendEvent,
      );
      controller
        ..onCancel = () {
          timer.cancel();
          return Future.value(
            null,
          );
        }
        ..onPause = () {
          watch.stop();
          timer.cancel();
        }
        ..onResume = () {
          Duration elapsed = watch.elapsed;
          watch.start();
          timer = a.Timer(
            period - elapsed,
            () {
              timer = a.Timer.periodic(
                period,
                sendEvent,
              );
              sendEvent(null);
            },
          );
        };
    };
    return controller;
  }

  factory StreamState.build({
    required Future<model.TimeStamp<M>> Function() modelFunc,
    required Duration pollInterval,
    required Duration historyRetentionPeriod,
  }) {
    final _streamIndex = Wrapper(-1);

    final _controller = _periodic<M>(
      period: pollInterval,
      computation: (_computationCount) {
        _streamIndex.value += 1;
        return modelFunc();
      },
    );

    final List<model.StreamIndex<M>> _history = [];

    return StreamState(
      modelFunc: modelFunc,
      streamIndex: _streamIndex,
      history: _history,
      pollInterval: pollInterval,
      historyRetentionPeriod: historyRetentionPeriod,
      controller: _controller,
      subscription: _controller.stream
          .asyncMap(
        (
          event,
        ) async =>
            await event,
      )
          .listen(
        (
          timeStamp,
        ) {
          final newHistory = [
            model.StreamIndex<M>(
              (
                b,
              ) =>
                  b
                    ..index = _streamIndex.value
                    ..timeStamp = timeStamp.toBuilder(),
            ),
            ..._history,
          ].takeWhile(
            (
              streamIndex,
            ) =>
                _now.difference(
                  streamIndex.timeStamp.timeStamp,
                ) <=
                historyRetentionPeriod,
          );
          _history.clear();
          _history.addAll(
            newHistory,
          );
        },
      ),
    );
  }

  static Future<StreamState<M>> update<M extends model.StreamModel>({
    required StreamState<M> from,
    required Duration pollInterval,
    required Duration historyRetentionPeriod,
  }) async {
    if (from._pollInterval == pollInterval &&
        from._historyRetentionPeriod == historyRetentionPeriod) {
      return from;
    }

    await from._subscription.cancel();
    await from._controller.close();

    final controller = _periodic<M>(
      period: pollInterval,
      computation: (_computationCount) {
        from._streamIndex.value++;
        return from._modelFunc();
      },
    );

    return StreamState(
      modelFunc: from._modelFunc,
      streamIndex: from._streamIndex,
      history: from.history,
      controller: controller,
      subscription: controller.stream
          .asyncMap(
        (
          event,
        ) async =>
            await event,
      )
          .listen(
        (
          timeStamp,
        ) {
          final newHistory = [
            model.StreamIndex<M>(
              (
                b,
              ) =>
                  b
                    ..index = from._streamIndex.value
                    ..timeStamp = timeStamp.toBuilder(),
            ),
            ...from.history,
          ].takeWhile(
            (
              streamIndex,
            ) =>
                _now.difference(
                  streamIndex.timeStamp.timeStamp,
                ) <=
                historyRetentionPeriod,
          );
          from.history.clear();
          from.history.addAll(
            newHistory,
          );
        },
      ),
      pollInterval: pollInterval,
      historyRetentionPeriod: historyRetentionPeriod,
    );
  }

  StreamState({
    required Future<model.TimeStamp<M>> Function() modelFunc,
    required Wrapper<int> streamIndex,
    required this.history,
    required a.StreamController<Future<model.TimeStamp<M>>> controller,
    required a.StreamSubscription<model.TimeStamp<M>> subscription,
    required Duration pollInterval,
    required Duration historyRetentionPeriod,
  })  : _modelFunc = modelFunc,
        _streamIndex = streamIndex,
        _controller = controller,
        _subscription = subscription,
        _pollInterval = pollInterval,
        _historyRetentionPeriod = historyRetentionPeriod;
}

class Client {
  static const Duration defaultPollInterval = Duration(seconds: 1);
  static const Duration defaultHistoryRetentionPeriod = Duration(hours: 1);

  final retry.RetryClient _client = retry.RetryClient(http.Client());

  Future<http.Response> _get({required String path}) async {
    return await _client.get(Uri(
        scheme: 'http', host: 'localhost', port: 61208, path: '/api/3' + path));
  }

  Stream<T> poll<T>(
      {required Duration pollInterval,
      required Future<T> Function() endPointFunc}) {
    return Stream.periodic(
      pollInterval,
      (_computationCount) => endPointFunc(),
    ).asyncMap((event) async => await event);
  }

  Future<bc.BuiltList<model.StreamIndex<M>>> Function({
    required Duration pollInterval,
    required Duration historyRetentionPeriod,
  }) listFuncBuilder<M extends model.StreamModel>(
      {required Future<model.TimeStamp<M>> Function() modelFunc}) {
    StreamState<M>? _streamState;
    return ({
      required Duration pollInterval,
      required Duration historyRetentionPeriod,
    }) async {
      _streamState ??= StreamState.build(
        modelFunc: modelFunc,
        pollInterval: pollInterval,
        historyRetentionPeriod: historyRetentionPeriod,
      );

      _streamState = await StreamState.update(
        from: _streamState!,
        pollInterval: pollInterval,
        historyRetentionPeriod: historyRetentionPeriod,
      );

      return bc.BuiltList(_streamState!.history);
    };
  }

  Future<String> nowString() async => (await _get(path: '/now')).body;

  Future<model.Now> now() async => model.Now.fromQuoted(
        quoted: await nowString(),
      );

  Stream<model.Now> nowStream() => poll<model.Now>(
        pollInterval: defaultPollInterval,
        endPointFunc: now,
      );

  Future<String> upTimeString() async => (await _get(path: '/uptime')).body;

  Future<model.UpTime> upTime() async => model.UpTime.fromQuoted(
        quoted: await upTimeString(),
      );

  Stream<model.UpTime> upTimeStream() => poll<model.UpTime>(
        pollInterval: defaultPollInterval,
        endPointFunc: upTime,
      );

  Future<String> pluginsListString() async => (await _get(
        path: '/pluginslist',
      ))
          .body;

  Future<model.PluginList> pluginsList() async => model.PluginList.fromJson(
        list: decodeJsonListFromString(
          string: await pluginsListString(),
        ),
      );

  Future<String> coresString() async => (await _get(
        path: '/core',
      ))
          .body;

  Future<model.Cores> cores() async =>
      serializers.standardSerializers.deserializeWith(
        model.Cores.serializer,
        decodeJsonMapFromString(
          string: await coresString(),
        ),
      )!;

  Future<String> cpuString() async => (await _get(
        path: '/cpu',
      ))
          .body;

  Future<model.TimeStamp<model.Cpu>> cpu() async {
    final string = await cpuString();
    return model.TimeStamp(
      (
        b,
      ) =>
          b
            ..timeStamp = _now
            ..model = serializers.standardSerializers.deserializeWith(
              model.Cpu.serializer,
              decodeJsonMapFromString(
                string: string,
              ),
            )!,
    );
  }

  Future<String> cpuHistoryString() async => (await _get(
        path: '/cpu/history',
      ))
          .body;

  Future<model.CpuHistory> cpuHistory() async =>
      model.CpuHistory.fromCpuHistoryValue(
        value: serializers.standardSerializers.deserializeWith(
          model.CpuHistoryValue.serializer,
          decodeJsonMapFromString(
            string: await cpuHistoryString(),
          ),
        )!,
      );

  Future<String> allCpusString() async => (await _get(
        path: '/percpu',
      ))
          .body;

  Future<model.TimeStamp<model.AllCpusList>> allCpus() async {
    final string = await allCpusString();
    return model.TimeStamp(
      (
        b,
      ) =>
          b
            ..timeStamp = _now
            ..model = model.AllCpusList.fromJson(
              list: decodeJsonListFromString(
                string: string,
              ),
            ),
    );
  }

  Future<String> allCpusHistoryString() async => (await _get(
        path: '/percpu/history',
      ))
          .body;

  Future<model.AllCpusHistory> allCpusHistory() async {
    final history = await allCpusHistoryString();
    // print(history);
    return model.AllCpusHistory.fromAllCpusHistoryValue(
      value: model.AllCpusHistoryValue.fromJson(
        map: decodeJsonMapFromString(
          string: history,
        ),
      ),
    );
  }

  Future<String> cpuLoadString() async => (await _get(
        path: '/load',
      ))
          .body;

  Future<model.TimeStamp<model.CpuLoad>> cpuLoad() async {
    final string = await cpuLoadString();
    return model.TimeStamp(
      (
        b,
      ) =>
          b
            ..timeStamp = _now
            ..model = serializers.standardSerializers.deserializeWith(
              model.CpuLoad.serializer,
              decodeJsonMapFromString(
                string: string,
              ),
            )!,
    );
  }

  Future<String> cpuLoadHistoryString() async => (await _get(
        path: '/load/history',
      ))
          .body;

  Future<model.CpuLoadHistory> cpuLoadHistory() async =>
      model.CpuLoadHistory.fromCpuLoadHistoryValue(
        value: serializers.standardSerializers.deserializeWith(
          model.CpuLoadHistoryValue.serializer,
          decodeJsonMapFromString(
            string: await cpuLoadHistoryString(),
          ),
        )!,
      );

  Future<String> diskIoString() async => (await _get(
        path: '/diskio',
      ))
          .body;

  Future<model.TimeStamp<model.DiskIoList>> diskIo() async {
    final string = await diskIoString();
    return model.TimeStamp(
      (
        b,
      ) =>
          b
            ..timeStamp = _now
            ..model = model.DiskIoList.fromJson(
              list: decodeJsonListFromString(
                string: string,
              ),
            ),
    );
  }

  Future<String> diskIoHistoryString() async => (await _get(
        path: '/diskio/history',
      ))
          .body;

  Future<model.DiskIoHistory> diskIoHistory() async =>
      model.DiskIoHistory.fromDiskIoHistoryValue(
        value: model.DiskIoHistoryValue.fromJson(
          map: decodeJsonMapFromString(
            string: await diskIoHistoryString(),
          ),
        ),
      );

  Future<String> fileSystemString() async => (await _get(
        path: '/fs',
      ))
          .body;

  Future<model.TimeStamp<model.FileSystemList>> fileSystem() async {
    final string = await fileSystemString();
    return model.TimeStamp(
      (
        b,
      ) =>
          b
            ..timeStamp = _now
            ..model = model.FileSystemList.fromJson(
              list: decodeJsonListFromString(
                string: string,
              ),
            ),
    );
  }

  Future<String> fileSystemHistoryString() async => (await _get(
        path: '/fs/history',
      ))
          .body;

  Future<model.FileSystemHistory> fileSystemHistory() async =>
      model.FileSystemHistory.fromFileSystemHistoryValue(
        value: model.FileSystemHistoryValue.fromJson(
          map: decodeJsonMapFromString(
            string: await fileSystemHistoryString(),
          ),
        ),
      );

  Future<String> internetProtocolString() async => (await _get(
        path: '/ip',
      ))
          .body;

  Future<model.InternetProtocol> internetProtocol() async =>
      serializers.standardSerializers.deserializeWith(
        model.InternetProtocol.serializer,
        decodeJsonMapFromString(
          string: await internetProtocolString(),
        ),
      )!;

  Future<String> memoryString() async => (await _get(
        path: '/mem',
      ))
          .body;

  Future<model.TimeStamp<model.Memory>> memory() async {
    final string = await memoryString();
    return model.TimeStamp(
      (
        b,
      ) =>
          b
            ..timeStamp = _now
            ..model = serializers.standardSerializers.deserializeWith(
              model.Memory.serializer,
              decodeJsonMapFromString(
                string: string,
              ),
            )!,
    );
  }

  Future<String> memoryHistoryString() async => (await _get(
        path: '/mem/history',
      ))
          .body;

  Future<model.MemoryHistory> memoryHistory() async =>
      model.MemoryHistory.fromMemoryHistoryValue(
        value: serializers.standardSerializers.deserializeWith(
          model.MemoryHistoryValue.serializer,
          decodeJsonMapFromString(
            string: await memoryHistoryString(),
          ),
        )!,
      );

  Future<String> memorySwapString() async => (await _get(
        path: '/memswap',
      ))
          .body;

  Future<model.TimeStamp<model.MemorySwap>> memorySwap() async {
    final string = await memorySwapString();
    return model.TimeStamp(
      (
        b,
      ) =>
          b
            ..timeStamp = _now
            ..model = serializers.standardSerializers.deserializeWith(
              model.MemorySwap.serializer,
              decodeJsonMapFromString(
                string: string,
              ),
            )!,
    );
  }

  Future<String> memorySwapHistoryString() async => (await _get(
        path: '/memswap/history',
      ))
          .body;

  Future<model.MemorySwapHistory> memorySwapHistory() async =>
      model.MemorySwapHistory.fromMemorySwapHistoryValue(
        value: serializers.standardSerializers.deserializeWith(
          model.MemorySwapHistoryValue.serializer,
          decodeJsonMapFromString(
            string: await memorySwapHistoryString(),
          ),
        )!,
      );

  Future<String> networkInterfaceString() async => (await _get(
        path: '/network',
      ))
          .body;

  Future<model.TimeStamp<model.NetworkInterfaceList>> networkInterface() async {
    final string = await networkInterfaceString();
    return model.TimeStamp(
      (
        b,
      ) =>
          b
            ..timeStamp = _now
            ..model = model.NetworkInterfaceList.fromJson(
              list: decodeJsonListFromString(
                string: string,
              ),
            ),
    );
  }

  Future<String> networkHistoryString() async => (await _get(
        path: '/network/history',
      ))
          .body;

  Future<model.NetworkHistory> networkHistory() async =>
      model.NetworkHistory.fromNetworkHistoryValue(
        value: model.NetworkHistoryValue.fromJson(
          map: decodeJsonMapFromString(
            string: await networkHistoryString(),
          ),
        ),
      );

  Future<String> processCountString() async => (await _get(
        path: '/processcount',
      ))
          .body;

  Future<model.TimeStamp<model.ProcessCount>> processCount() async {
    final string = await processCountString();
    return model.TimeStamp(
      (
        b,
      ) =>
          b
            ..timeStamp = _now
            ..model = serializers.standardSerializers.deserializeWith(
              model.ProcessCount.serializer,
              decodeJsonMapFromString(
                string: string,
              ),
            )!,
    );
  }

  Future<String> processCountHistoryString() async => (await _get(
        path: '/processcount/history',
      ))
          .body;

  Future<model.ProcessCountHistory> processCountHistory() async =>
      model.ProcessCountHistory.fromProcessCountHistoryValue(
        value: serializers.standardSerializers.deserializeWith(
          model.ProcessCountHistoryValue.serializer,
          decodeJsonMapFromString(
            string: await processCountHistoryString(),
          ),
        )!,
      );

  Future<String> processListString() async => (await _get(
        path: '/processlist',
      ))
          .body;

  Future<model.TimeStamp<model.ProcessList>> processList() async {
    final string = await processListString();
    return model.TimeStamp(
      (
        b,
      ) =>
          b
            ..timeStamp = _now
            ..model = model.ProcessList.fromJson(
              list: decodeJsonListFromString(
                string: string,
              ),
            ),
    );
  }

  Future<String> quickLookString() async => (await _get(
        path: '/quicklook',
      ))
          .body;

  Future<model.TimeStamp<model.QuickLook>> quickLook() async {
    final string = await quickLookString();
    return model.TimeStamp(
      (
        b,
      ) =>
          b
            ..timeStamp = _now
            ..model = serializers.standardSerializers.deserializeWith(
              model.QuickLook.serializer,
              decodeJsonMapFromString(
                string: string,
              ),
            )!,
    );
  }

  Future<String> quickLookHistoryString() async => (await _get(
        path: '/quicklook/history',
      ))
          .body;

  Future<model.QuickLookHistory> quickLookHistory() async =>
      model.QuickLookHistory.fromQuickLookHistoryValue(
        value: serializers.standardSerializers.deserializeWith(
          model.QuickLookHistoryValue.serializer,
          decodeJsonMapFromString(
            string: await quickLookHistoryString(),
          ),
        )!,
      );

  Future<String> sensorsString() async => (await _get(
        path: '/sensors',
      ))
          .body;

  Future<model.TimeStamp<model.SensorList>> sensors() async {
    final string = await sensorsString();
    return model.TimeStamp(
      (
        b,
      ) =>
          b
            ..timeStamp = _now
            ..model = model.SensorList.fromJson(
              list: decodeJsonListFromString(
                string: string,
              ),
            ),
    );
  }

  Future<String> systemString() async => (await _get(
        path: '/system',
      ))
          .body;

  Future<model.System> system() async =>
      serializers.standardSerializers.deserializeWith(
        model.System.serializer,
        decodeJsonMapFromString(
          string: await systemString(),
        ),
      )!;
}

final Client client = Client();
