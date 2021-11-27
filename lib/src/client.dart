import 'dart:convert' as convert;

import 'package:http/http.dart' as http;
import 'package:http_retry/http_retry.dart' as retry;

import 'model.dart' as md;
import 'serializers.dart' as s;

List<dynamic> decodeJsonListFromResp({required http.Response resp}) {
  return convert.jsonDecode(
    convert.utf8.decode(
      resp.bodyBytes,
    ),
  );
}

Map<String, dynamic> decodeJsonMapFromResp({required http.Response resp}) {
  return convert.jsonDecode(
    convert.utf8.decode(
      resp.bodyBytes,
    ),
  );
}

class Client {
  static const String scheme = 'http';
  static const String host = 'localhost';
  static const int port = 61208;
  static const String basePath = '/api/3';

  final retry.RetryClient client = retry.RetryClient(http.Client());

  Future<http.Response> get({required String path}) async {
    return await client.get(
        Uri(scheme: scheme, host: host, port: port, path: basePath + path));
  }

  Stream<T> poll<T>(
      {required Duration pollInterval,
      required Future<T> Function() endPointFunc}) async* {
    yield* Stream.periodic(
      pollInterval,
      (_computationCount) {
        return endPointFunc();
      },
    ).asyncMap((event) async => await event);
  }

  Future<md.Now> now() async {
    var resp = await get(path: '/now');
    return md.Now(now: resp.body);
  }

  Stream<md.Now> nowStream() {
    return poll<md.Now>(
      pollInterval: const Duration(seconds: 1),
      endPointFunc: now,
    );
  }

  Future<md.UpTime> upTime() async {
    var resp = await get(path: '/uptime');
    return md.UpTime(now: resp.body);
  }

  Stream<md.UpTime> upTimeStream() {
    return poll<md.UpTime>(
      pollInterval: const Duration(seconds: 1),
      endPointFunc: upTime,
    );
  }

  Future<md.PluginsList> pluginsList() async {
    return md.PluginsList.fromJson(
      list: decodeJsonListFromResp(
        resp: await get(
          path: '/pluginslist',
        ),
      ),
    );
  }

  Future<md.Core> core() async {
    return s.standardSerializers.deserializeWith(
      md.Core.serializer,
      decodeJsonMapFromResp(
        resp: await get(
          path: '/core',
        ),
      ),
    )!;
  }

  Future<md.Cpu> cpu() async {
    return s.standardSerializers.deserializeWith(
      md.Cpu.serializer,
      decodeJsonMapFromResp(
        resp: await get(
          path: '/cpu',
        ),
      ),
    )!;
  }

  Stream<md.Cpu> cpuStream() {
    return poll<md.Cpu>(
      pollInterval: const Duration(seconds: 1),
      endPointFunc: cpu,
    );
  }

  Future<md.CpuHistory> cpuHistory() async {
    return md.CpuHistory.fromCpuHistoryValue(
      value: s.standardSerializers.deserializeWith(
        md.CpuHistoryValue.serializer,
        decodeJsonMapFromResp(
          resp: await get(
            path: '/cpu/history',
          ),
        ),
      )!,
    );
  }

  Future<md.PerCpuList> perCpu() async {
    return md.PerCpuList.fromJson(
      list: decodeJsonListFromResp(
        resp: await get(
          path: '/percpu',
        ),
      ),
    );
  }

  Stream<md.PerCpuList> perCpuStream() {
    return poll<md.PerCpuList>(
      pollInterval: const Duration(seconds: 1),
      endPointFunc: perCpu,
    );
  }

  Future<md.PerCpuHistory> perCpuHistory() async {
    return md.PerCpuHistory.fromPerCpuHistoryValue(
      value: s.standardSerializers.deserializeWith(
        md.PerCpuHistoryValue.serializer,
        decodeJsonMapFromResp(
          resp: await get(
            path: '/percpu/history',
          ),
        ),
      )!,
    );
  }

  Future<md.CpuLoad> cpuLoad() async {
    return s.standardSerializers.deserializeWith(
      md.CpuLoad.serializer,
      decodeJsonMapFromResp(
        resp: await get(
          path: '/load',
        ),
      ),
    )!;
  }

  Stream<md.CpuLoad> cpuLoadStream() {
    return poll<md.CpuLoad>(
      pollInterval: const Duration(seconds: 1),
      endPointFunc: cpuLoad,
    );
  }

  Future<md.CpuLoadHistory> cpuLoadHistory() async {
    return md.CpuLoadHistory.fromCpuLoadHistoryValue(
      value: s.standardSerializers.deserializeWith(
        md.CpuLoadHistoryValue.serializer,
        decodeJsonMapFromResp(
          resp: await get(
            path: '/load/history',
          ),
        ),
      )!,
    );
  }

  Future<md.DiskIoList> diskIo() async {
    return md.DiskIoList.fromJson(
      list: decodeJsonListFromResp(
        resp: await get(
          path: '/diskio',
        ),
      ),
    );
  }

  Stream<md.DiskIoList> diskIoStream() {
    return poll<md.DiskIoList>(
      pollInterval: const Duration(seconds: 1),
      endPointFunc: diskIo,
    );
  }

  Future<md.DiskIoHistory> diskIoHistory() async {
    return md.DiskIoHistory.fromDiskIoHistoryValue(
      value: s.standardSerializers.deserializeWith(
        md.DiskIoHistoryValue.serializer,
        decodeJsonMapFromResp(
          resp: await get(
            path: '/diskio/history',
          ),
        ),
      )!,
    );
  }

  Future<md.FileSystemList> fileSystem() async {
    return md.FileSystemList.fromJson(
      list: decodeJsonListFromResp(
        resp: await get(
          path: '/fs',
        ),
      ),
    );
  }

  Stream<md.FileSystemList> fileSystemStream() {
    return poll<md.FileSystemList>(
      pollInterval: const Duration(seconds: 1),
      endPointFunc: fileSystem,
    );
  }

  Future<md.FileSystemHistory> fileSystemHistory() async {
    return md.FileSystemHistory.fromFileSystemHistoryValue(
      value: s.standardSerializers.deserializeWith(
        md.FileSystemHistoryValue.serializer,
        decodeJsonMapFromResp(
          resp: await get(
            path: '/fs/history',
          ),
        ),
      )!,
    );
  }

  Future<md.InternetProtocol> internetProtocol() async {
    return s.standardSerializers.deserializeWith(
      md.InternetProtocol.serializer,
      decodeJsonMapFromResp(
        resp: await get(
          path: '/ip',
        ),
      ),
    )!;
  }

  Future<md.Memory> memory() async {
    return s.standardSerializers.deserializeWith(
      md.Memory.serializer,
      decodeJsonMapFromResp(
        resp: await get(
          path: '/mem',
        ),
      ),
    )!;
  }

  Stream<md.Memory> memoryStream() {
    return poll<md.Memory>(
      pollInterval: const Duration(seconds: 1),
      endPointFunc: memory,
    );
  }

  Future<md.MemoryHistory> memoryHistory() async {
    return md.MemoryHistory.fromMemoryHistoryValue(
      value: s.standardSerializers.deserializeWith(
        md.MemoryHistoryValue.serializer,
        decodeJsonMapFromResp(
          resp: await get(
            path: '/mem/history',
          ),
        ),
      )!,
    );
  }

  Future<md.MemorySwap> memorySwap() async {
    return s.standardSerializers.deserializeWith(
      md.MemorySwap.serializer,
      decodeJsonMapFromResp(
        resp: await get(
          path: '/memswap',
        ),
      ),
    )!;
  }

  Stream<md.MemorySwap> memorySwapStream() {
    return poll<md.MemorySwap>(
      pollInterval: const Duration(seconds: 1),
      endPointFunc: memorySwap,
    );
  }

  Future<md.MemorySwapHistory> memorySwapHistory() async {
    return md.MemorySwapHistory.fromMemorySwapHistoryValue(
      value: s.standardSerializers.deserializeWith(
        md.MemorySwapHistoryValue.serializer,
        decodeJsonMapFromResp(
          resp: await get(
            path: '/memswap/history',
          ),
        ),
      )!,
    );
  }

  Future<md.NetworkInterfaceList> networkInterface() async {
    return md.NetworkInterfaceList.fromJson(
      list: decodeJsonListFromResp(
        resp: await get(
          path: '/network',
        ),
      ),
    );
  }

  Stream<md.NetworkInterfaceList> networkInterfaceStream() {
    return poll<md.NetworkInterfaceList>(
      pollInterval: const Duration(seconds: 1),
      endPointFunc: networkInterface,
    );
  }

  Future<md.NetworkHistory> networkHistory() async {
    return md.NetworkHistory.fromNetworkHistoryValue(
      value: s.standardSerializers.deserializeWith(
        md.NetworkHistoryValue.serializer,
        decodeJsonMapFromResp(
          resp: await get(
            path: '/network/history',
          ),
        ),
      )!,
    );
  }

  Future<md.ProcessCount> processCount() async {
    return s.standardSerializers.deserializeWith(
      md.ProcessCount.serializer,
      decodeJsonMapFromResp(
        resp: await get(
          path: '/processcount',
        ),
      ),
    )!;
  }

  Stream<md.ProcessCount> processCountStream() {
    return poll<md.ProcessCount>(
      pollInterval: const Duration(seconds: 1),
      endPointFunc: processCount,
    );
  }

  Future<md.ProcessCountHistory> processCountHistory() async {
    return md.ProcessCountHistory.fromProcessCountHistoryValue(
      value: s.standardSerializers.deserializeWith(
        md.ProcessCountHistoryValue.serializer,
        decodeJsonMapFromResp(
          resp: await get(
            path: '/processcount/history',
          ),
        ),
      )!,
    );
  }

  Future<md.ProcessList> processList() async {
    return md.ProcessList.fromJson(
      list: decodeJsonListFromResp(
        resp: await get(
          path: '/processlist',
        ),
      ),
    );
  }

  Stream<md.ProcessList> processListStream() {
    return poll<md.ProcessList>(
      pollInterval: const Duration(seconds: 1),
      endPointFunc: processList,
    );
  }

  Future<md.QuickLook> quickLook() async {
    return s.standardSerializers.deserializeWith(
      md.QuickLook.serializer,
      decodeJsonMapFromResp(
        resp: await get(
          path: '/quicklook',
        ),
      ),
    )!;
  }

  Stream<md.QuickLook> quickLookStream() {
    return poll<md.QuickLook>(
      pollInterval: const Duration(seconds: 1),
      endPointFunc: quickLook,
    );
  }

  Future<md.QuickLookHistory> quickLookHistory() async {
    return md.QuickLookHistory.fromQuickLookHistoryValue(
      value: s.standardSerializers.deserializeWith(
        md.QuickLookHistoryValue.serializer,
        decodeJsonMapFromResp(
          resp: await get(
            path: '/quicklook/history',
          ),
        ),
      )!,
    );
  }

  Future<md.SensorList> sensors() async {
    return md.SensorList.fromJson(
      list: decodeJsonListFromResp(
        resp: await get(
          path: '/sensors',
        ),
      ),
    );
  }

  Stream<md.SensorList> sensorsStream() {
    return poll<md.SensorList>(
      pollInterval: const Duration(seconds: 1),
      endPointFunc: sensors,
    );
  }

  Future<md.System> system() async {
    return s.standardSerializers.deserializeWith(
      md.System.serializer,
      decodeJsonMapFromResp(
        resp: await get(
          path: '/system',
        ),
      ),
    )!;
  }
}
