import 'dart:math' as math;

import 'package:built_collection/built_collection.dart' as bc;
import 'package:collection/collection.dart';
import 'package:flutter/material.dart' as m;

import 'model.dart' as model;
import 'chart.dart' as chart;
import 'client.dart' as glances_client;
import 'value_list_map.dart' as vlm;

typedef ClientListFunc<M extends model.StreamModel>
    = Future<bc.BuiltList<model.StreamIndex<M>>> Function({
  required Duration pollInterval,
  required Duration historyRetentionPeriod,
});

typedef StreamIndexListFunc = Future<bc.BuiltList<int>> Function(
    {Duration pollInterval, Duration historyRetentionPeriod});

typedef ListFunc<R extends vlm.MapBase> = Future<R> Function({
  required chart.Window window,
  Duration pollInterval,
  Duration historyRetentionPeriod,
});

typedef StreamWindow<M extends model.StreamModel>
    = Iterable<model.StreamIndex<M>>;

class TimeStampAndIndexAndModel<M extends model.ModelBase> {
  final DateTime timeStamp;
  final int index;
  final M model;

  TimeStampAndIndexAndModel({
    required this.timeStamp,
    required this.index,
    required this.model,
  });
}

class ValueListMapBuilder {
  static const _percentUpperBound = 100.0;

  final glances_client.Client _client;

  late final ClientListFunc<model.Cpu> _cpuList;
  late final ClientListFunc<model.AllCpusList> _allCpusList;
  late final ClientListFunc<model.CpuLoad> _cpuLoadList;
  late final ClientListFunc<model.DiskIoList> _diskIoList;
  late final ClientListFunc<model.FileSystemList> _fileSystemList;
  late final ClientListFunc<model.Memory> _memoryList;
  late final ClientListFunc<model.MemorySwap> _memorySwapList;
  late final ClientListFunc<model.NetworkInterfaceList> _networkInterfaceList;
  late final ClientListFunc<model.ProcessCount> _processCountList;
  late final ClientListFunc<model.ProcessList> _processList;
  late final ClientListFunc<model.QuickLook> _quickLookList;
  late final ClientListFunc<model.SensorList> _sensorList;

  late final StreamIndexListFunc cpuStreamIndexList;
  late final StreamIndexListFunc allCpusStreamIndexList;
  late final StreamIndexListFunc cpuLoadStreamIndexList;
  late final StreamIndexListFunc diskIoStreamIndexList;
  late final StreamIndexListFunc fileSystemStreamIndexList;
  late final StreamIndexListFunc memoryStreamIndexList;
  late final StreamIndexListFunc memorySwapStreamIndexList;
  late final StreamIndexListFunc networkInterfaceStreamIndexList;
  late final StreamIndexListFunc processCountStreamIndexList;
  late final StreamIndexListFunc processStreamIndexList;
  late final StreamIndexListFunc quickLookStreamIndexList;
  late final StreamIndexListFunc sensorStreamIndexList;

  late final ListFunc<vlm.MapOfMaps> cpuMap;
  late final ListFunc<vlm.MapOfMaps> allCpusMap;
  late final ListFunc<vlm.MapOfLists> cpuLoadMap;
  late final ListFunc<vlm.MapOfMaps> diskIoMap;
  late final ListFunc<vlm.MapOfMaps> fileSystemMap;
  late final ListFunc<vlm.MapOfLists> memoryMap;
  late final ListFunc<vlm.MapOfMaps> memorySwapMap;
  late final ListFunc<vlm.MapOfMaps> networkInterfaceMap;
  late final ListFunc<vlm.MapOfLists> processCountMap;
  late final ListFunc<vlm.MapOfMaps> processMap;
  late final ListFunc<vlm.MapOfMaps> quickLookMap;
  late final ListFunc<vlm.MapOfLists> sensorMap;

  String _hoverText(
    String label,
    num value,
  ) =>
      value is double
          ? '$label: ${value.toStringAsFixed(2)}'
          : '$label: $value';

  String _percentHoverText(
    String label,
    num value,
  ) =>
      '${_hoverText(label, value)}%';

  String _bytesToMegabytesHoverText(
    String label,
    num bytes,
  ) =>
      '$label: ${(bytes.toDouble() / 1000000.0).toStringAsFixed(2)} MB';

  String _bytesToGigabytesHoverText(
    String label,
    num bytes,
  ) =>
      '$label: ${(bytes.toDouble() / 1000000000.0).toStringAsFixed(2)} GB';

  String _cpuKey(int cpuNumber) => 'Core $cpuNumber';

  String _cpuPercentHoverText(
    int cpuNumber,
    String qualifier,
    double value,
  ) =>
      _percentHoverText(
        '${_cpuKey(cpuNumber)} $qualifier',
        value,
      );

  m.Color _colorFromKey(String key) => m.HSVColor.fromAHSV(
        1.0,
        key.hashCode % 360.0,
        1.0,
        1.0,
      ).toColor();

  String _allCpusSelectionText(
    int cpuNumber,
    String key,
  ) =>
      'Core $cpuNumber $key';

  String _cpuHertzHoverText(
    String label,
    num hertz,
  ) =>
      '$label ${(hertz.toDouble() / 1000000000.0).toStringAsFixed(2)} GHZ';

  StreamIndexListFunc _streamIndexListFuncBuilder<M extends model.StreamModel>(
      {required ClientListFunc<M> listFunc}) {
    return ({
      Duration pollInterval = glances_client.Client.defaultPollInterval,
      Duration historyRetentionPeriod =
          glances_client.Client.defaultHistoryRetentionPeriod,
    }) async {
      final history = await listFunc(
        pollInterval: pollInterval,
        historyRetentionPeriod: historyRetentionPeriod,
      );

      return bc.BuiltList(
        history.map(
          (index) => index.index,
        ),
      );
    };
  }

  ListFunc<R>
      _listFuncBuilder<R extends vlm.MapBase, M extends model.StreamModel>({
    required ClientListFunc<M> listFunc,
    required R Function({required StreamWindow<M> window}) mapBuilder,
  }) =>
          ({
            required chart.Window window,
            Duration pollInterval = glances_client.Client.defaultPollInterval,
            Duration historyRetentionPeriod =
                glances_client.Client.defaultHistoryRetentionPeriod,
          }) async =>
              mapBuilder(
                  window: (await listFunc(
                pollInterval: pollInterval,
                historyRetentionPeriod: historyRetentionPeriod,
              ))
                      .skipWhile(
                        (
                          index,
                        ) =>
                            index.index < window.index,
                      )
                      .takeWhile(
                        (
                          index,
                        ) =>
                            index.index < window.index + window.width,
                      ));

  MapEntry<String, vlm.ListOfValues> _mapEntry<M extends model.StreamModel>(
    String key,
    StreamWindow<M> window,
    num Function(M) getter,
    double upperBound,
    String Function(String, num) hoverTextFunc, [
    bool? defaultVisible,
  ]) =>
      MapEntry(
        key,
        vlm.ListOfValues(
          (
            b,
          ) =>
              b
                ..color = _colorFromKey(
                  key,
                )
                ..selectionText = key
                ..defaultVisible = defaultVisible
                ..list = bc.ListBuilder(
                  window.map(
                    (
                      index,
                    ) =>
                        vlm.Value(
                      (
                        b,
                      ) =>
                          b
                            ..timeStamp = index.timeStamp.timeStamp
                            ..value = getter(
                              index.timeStamp.model,
                            )
                            ..normalized = getter(
                                  index.timeStamp.model,
                                ) /
                                upperBound
                            ..hoverText = hoverTextFunc(
                              key,
                              getter(
                                index.timeStamp.model,
                              ),
                            )
                            ..streamIndex = index.index,
                    ),
                  ),
                ),
        ),
      );

  MapEntry<String, vlm.ListOfValues> _historyMapEntry(
    String key,
    chart.Window window,
    Iterable<model.HistoryTimeStamp<num>> history,
    double upperBound,
    String Function(String, num) hoverTextFunc, [
    bool? defaultVisible,
  ]) =>
      MapEntry(
        key,
        vlm.ListOfValues(
          (
            b,
          ) =>
              b
                ..color = _colorFromKey(
                  key,
                )
                ..selectionText = key
                ..defaultVisible = true
                ..list = bc.ListBuilder(
                  history
                      .mapIndexed(
                        (
                          index,
                          timeStamp,
                        ) =>
                            vlm.Value(
                          (
                            b,
                          ) =>
                              b
                                ..timeStamp = timeStamp.timeStamp
                                ..value = timeStamp.value
                                ..normalized = timeStamp.value / upperBound
                                ..hoverText = hoverTextFunc(
                                  key,
                                  timeStamp.value,
                                )
                                ..streamIndex = index,
                        ),
                      )
                      .skip(
                        window.index,
                      )
                      .take(
                        window.width,
                      ),
                ),
        ),
      );

  vlm.MapOfMaps _cpuListMapBuilder({required StreamWindow<model.Cpu> window}) =>
      vlm.MapOfMaps(
        (
          b,
        ) =>
            b.map = bc.MapBuilder(
          Map.fromEntries(
            [
              MapEntry(
                'Percentages',
                vlm.MapOfLists((
                  b,
                ) {
                  b.map = bc.MapBuilder(
                    Map.fromEntries(
                      [
                        _mapEntry<model.Cpu>(
                          'Total',
                          window,
                          (
                            m,
                          ) =>
                              m.total,
                          _percentUpperBound,
                          _percentHoverText,
                          true,
                        ),
                        _mapEntry<model.Cpu>(
                          'User',
                          window,
                          (
                            m,
                          ) =>
                              m.user,
                          _percentUpperBound,
                          _percentHoverText,
                        ),
                        _mapEntry<model.Cpu>(
                          'Nice',
                          window,
                          (
                            m,
                          ) =>
                              m.nice,
                          _percentUpperBound,
                          _percentHoverText,
                        ),
                        _mapEntry<model.Cpu>(
                          'System',
                          window,
                          (
                            m,
                          ) =>
                              m.system,
                          _percentUpperBound,
                          _percentHoverText,
                        ),
                        _mapEntry<model.Cpu>(
                          'Idle',
                          window,
                          (
                            m,
                          ) =>
                              m.idle,
                          _percentUpperBound,
                          _percentHoverText,
                        ),
                        _mapEntry<model.Cpu>(
                          'IO Wait',
                          window,
                          (
                            m,
                          ) =>
                              m.ioWait,
                          _percentUpperBound,
                          _percentHoverText,
                        ),
                        _mapEntry<model.Cpu>(
                          'IRQ',
                          window,
                          (
                            m,
                          ) =>
                              m.irq,
                          _percentUpperBound,
                          _percentHoverText,
                        ),
                        _mapEntry<model.Cpu>(
                          'Soft IRQ',
                          window,
                          (
                            m,
                          ) =>
                              m.softIrq,
                          _percentUpperBound,
                          _percentHoverText,
                        ),
                        _mapEntry<model.Cpu>(
                          'Steal',
                          window,
                          (
                            m,
                          ) =>
                              m.steal,
                          _percentUpperBound,
                          _percentHoverText,
                        ),
                        _mapEntry<model.Cpu>(
                          'Guest',
                          window,
                          (
                            m,
                          ) =>
                              m.guest,
                          _percentUpperBound,
                          _percentHoverText,
                        ),
                        _mapEntry<model.Cpu>(
                          'Guest Nice',
                          window,
                          (
                            m,
                          ) =>
                              m.guestNice,
                          _percentUpperBound,
                          _percentHoverText,
                        ),
                      ],
                    ),
                  );
                }),
              ),
              MapEntry(
                'Counts',
                vlm.MapOfLists(
                  (
                    b,
                  ) {
                    final upperBound = [
                      1,
                      ...window.map(
                        (
                          index,
                        ) =>
                            index.timeStamp.model.contextSwitches,
                      ),
                      ...window.map(
                        (
                          index,
                        ) =>
                            index.timeStamp.model.interrupts,
                      ),
                      ...window.map(
                        (
                          index,
                        ) =>
                            index.timeStamp.model.softInterrupts,
                      ),
                      ...window.map(
                        (
                          index,
                        ) =>
                            index.timeStamp.model.sysCalls,
                      ),
                    ]
                        .reduce(
                          math.max,
                        )
                        .toDouble();

                    b.map = bc.MapBuilder(
                      Map.fromEntries(
                        [
                          _mapEntry<model.Cpu>(
                            'Context Switches',
                            window,
                            (
                              m,
                            ) =>
                                m.contextSwitches,
                            upperBound,
                            _hoverText,
                          ),
                          _mapEntry<model.Cpu>(
                            'Interrupts',
                            window,
                            (
                              m,
                            ) =>
                                m.interrupts,
                            upperBound,
                            _hoverText,
                          ),
                          _mapEntry<model.Cpu>(
                            'Soft Interrupts',
                            window,
                            (
                              m,
                            ) =>
                                m.softInterrupts,
                            upperBound,
                            _hoverText,
                          ),
                          _mapEntry<model.Cpu>(
                            'System Calls',
                            window,
                            (
                              m,
                            ) =>
                                m.sysCalls,
                            upperBound,
                            _hoverText,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );

  model.CpuHistory? _cpuHistoryModel;
  Future<vlm.FixedLengthMapOfLists> cpuHistory({
    required chart.Window window,
    bool reset = false,
  }) async {
    _cpuHistoryModel = _cpuHistoryModel == null || reset
        ? await _client.cpuHistory()
        : _cpuHistoryModel;

    final fixedLength = [
      0,
      _cpuHistoryModel!.user.length,
      _cpuHistoryModel!.system.length,
    ].reduce(
      math.max,
    );

    return vlm.FixedLengthMapOfLists(
      (
        b,
      ) {
        b
          ..fixedLength = fixedLength
          ..map = bc.MapBuilder(
            Map.fromEntries(
              [
                _historyMapEntry(
                  'User',
                  window,
                  _cpuHistoryModel!.user,
                  _percentUpperBound,
                  _percentHoverText,
                  true,
                ),
                _historyMapEntry(
                  'System',
                  window,
                  _cpuHistoryModel!.system,
                  _percentUpperBound,
                  _percentHoverText,
                  true,
                ),
              ],
            ),
          );
      },
    );
  }

  vlm.MapOfMaps _allCpusListMapBuilder({
    required StreamWindow<model.AllCpusList> window,
  }) {
    final Iterable<int> cpuNumbers = window.isEmpty
        ? []
        : window
            .map(
              (
                index,
              ) =>
                  index.timeStamp.model.list.map(
                (
                  cpu,
                ) =>
                    cpu.number,
              ),
            )
            .first;

    return vlm.MapOfMaps(
      (
        b,
      ) =>
          b.map = bc.MapBuilder(
        Map.fromEntries(
          cpuNumbers.map(
            (cpuNumber) => MapEntry(
              _cpuKey(cpuNumber),
              vlm.MapOfLists(
                (
                  b,
                ) {
                  model.AllCpus _cpuFromNumber(
                    model.StreamIndex<model.AllCpusList> index,
                    int number,
                  ) =>
                      index.timeStamp.model.list.firstWhere(
                        (
                          cpu,
                        ) =>
                            number == cpu.number,
                      );

                  MapEntry<String, vlm.ListOfValues> mapEntry(
                    String key,
                    double Function(model.AllCpus) getter, [
                    bool? defaultVisible,
                  ]) =>
                      MapEntry(
                        key,
                        vlm.ListOfValues(
                          (
                            b,
                          ) {
                            String selectionText = _allCpusSelectionText(
                              cpuNumber,
                              key,
                            );
                            b
                              ..color = _colorFromKey(
                                selectionText,
                              )
                              ..selectionText = selectionText
                              ..defaultVisible = defaultVisible
                              ..list = bc.ListBuilder(
                                window.map(
                                  (
                                    index,
                                  ) {
                                    final cpu =
                                        _cpuFromNumber(index, cpuNumber);
                                    return vlm.Value(
                                      (
                                        b,
                                      ) =>
                                          b
                                            ..timeStamp =
                                                index.timeStamp.timeStamp
                                            ..value = getter(
                                              cpu,
                                            )
                                            ..normalized = getter(
                                                  cpu,
                                                ) /
                                                _percentUpperBound
                                            ..hoverText = _cpuPercentHoverText(
                                              cpuNumber,
                                              key,
                                              getter(
                                                cpu,
                                              ),
                                            )
                                            ..streamIndex = index.index,
                                    );
                                  },
                                ),
                              );
                          },
                        ),
                      );

                  b.map = bc.MapBuilder(
                    Map.fromEntries(
                      [
                        mapEntry(
                          'Total',
                          (
                            cpu,
                          ) =>
                              cpu.total,
                          true,
                        ),
                        mapEntry(
                          'User',
                          (
                            cpu,
                          ) =>
                              cpu.user,
                        ),
                        mapEntry(
                          'System',
                          (
                            cpu,
                          ) =>
                              cpu.system,
                        ),
                        mapEntry(
                          'Idle',
                          (
                            cpu,
                          ) =>
                              cpu.idle,
                        ),
                        mapEntry(
                          'Nice',
                          (
                            cpu,
                          ) =>
                              cpu.nice,
                        ),
                        mapEntry(
                          'IO Wait',
                          (
                            cpu,
                          ) =>
                              cpu.ioWait,
                        ),
                        mapEntry(
                          'IRQ',
                          (
                            cpu,
                          ) =>
                              cpu.irq,
                        ),
                        mapEntry(
                          'Soft IRQ',
                          (
                            cpu,
                          ) =>
                              cpu.softIrq,
                        ),
                        mapEntry(
                          'Steal',
                          (
                            cpu,
                          ) =>
                              cpu.steal,
                        ),
                        mapEntry(
                          'Guest',
                          (
                            cpu,
                          ) =>
                              cpu.guest,
                        ),
                        mapEntry(
                          'Guest Nice',
                          (
                            cpu,
                          ) =>
                              cpu.guestNice,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  model.AllCpusHistory? _allCpusHistoryModel;
  Future<vlm.FixedLengthMapOfMapOfLists> allCpusHistory({
    required chart.Window window,
    bool reset = false,
  }) async {
    _allCpusHistoryModel = _allCpusHistoryModel == null || reset
        ? await _client.allCpusHistory()
        : _allCpusHistoryModel;

    return vlm.FixedLengthMapOfMapOfLists(
      (
        b,
      ) {
        final fixedLength = [
          0,
          ..._allCpusHistoryModel!.history.values.map(
            (
              list,
            ) =>
                list.length,
          ),
        ].reduce(
          math.max,
        );

        final keyRegExp = RegExp(r'(\d\d?)_(system|user)');

        String parseSystemOrUser(String key) =>
            keyRegExp.firstMatch(key)!.group(2)!;

        int parseCpuNumber(String key) => int.parse(
              keyRegExp
                  .firstMatch(
                    key,
                  )!
                  .group(
                    1,
                  )!,
            );

        bc.BuiltMap<String, Map<int, String>> groupKeys(Iterable<String> keys) {
          final groupMap = {};

          for (final key in keys) {
            groupMap.update(
              parseSystemOrUser(
                key,
              ),
              (
                map,
              ) =>
                  map
                    ..addAll(
                      {
                        parseCpuNumber(
                          key,
                        ): key,
                      },
                    ),
              ifAbsent: () => {
                parseCpuNumber(
                  key,
                ): key,
              },
            );
          }

          return bc.BuiltMap(
            groupMap,
          );
        }

        MapEntry<String, vlm.FixedLengthMapOfLists> mapEntry(
          String key,
          String groupKey,
        ) =>
            MapEntry(
              key,
              vlm.FixedLengthMapOfLists(
                (
                  b,
                ) =>
                    b
                      ..fixedLength = fixedLength
                      ..map = bc.MapBuilder(
                        groupKeys(
                          _allCpusHistoryModel!.history.keys,
                        )[groupKey]!
                            .map(
                          (
                            cpuNumber,
                            key,
                          ) =>
                              MapEntry(
                            _cpuKey(
                              cpuNumber,
                            ),
                            vlm.ListOfValues(
                              (
                                b,
                              ) {
                                final label = '$key ${_cpuKey(
                                  cpuNumber,
                                )}';
                                b
                                  ..color = _colorFromKey(
                                    label,
                                  )
                                  ..selectionText = label
                                  ..defaultVisible = true
                                  ..list = bc.ListBuilder(
                                    _allCpusHistoryModel!.history[key]!
                                        .mapIndexed(
                                          (
                                            index,
                                            timeStamp,
                                          ) =>
                                              vlm.Value(
                                            (
                                              b,
                                            ) =>
                                                b
                                                  ..timeStamp =
                                                      timeStamp.timeStamp
                                                  ..value = timeStamp.value
                                                  ..normalized =
                                                      timeStamp.value /
                                                          _percentUpperBound
                                                  ..hoverText =
                                                      _percentHoverText(
                                                    label,
                                                    timeStamp.value,
                                                  )
                                                  ..streamIndex = index,
                                          ),
                                        )
                                        .skip(
                                          window.index,
                                        )
                                        .take(
                                          window.width,
                                        ),
                                  );
                              },
                            ),
                          ),
                        ),
                      ),
              ),
            );

        b
          ..fixedLength = fixedLength
          ..map = bc.MapBuilder(
            Map.fromEntries(
              [
                mapEntry(
                  'System',
                  'system',
                ),
                mapEntry(
                  'User',
                  'user',
                ),
              ],
            ),
          );
      },
    );
  }

  String _loadKey(int minutes) => '$minutes Minute Avg Load';

  vlm.MapOfLists _cpuLoadListMapBuilder(
          {required StreamWindow<model.CpuLoad> window}) =>
      vlm.MapOfLists(
        (
          b,
        ) {
          final upperBound = [
            0.01,
            ...window.map((
              index,
            ) =>
                index.timeStamp.model.min1),
            ...window.map((
              index,
            ) =>
                index.timeStamp.model.min5),
            ...window.map((
              index,
            ) =>
                index.timeStamp.model.min15),
          ].reduce(
            math.max,
          );

          b.map = bc.MapBuilder(
            Map.fromEntries(
              [
                _mapEntry<model.CpuLoad>(
                  _loadKey(1),
                  window,
                  (
                    cpuLoad,
                  ) =>
                      cpuLoad.min1,
                  upperBound,
                  _hoverText,
                  true,
                ),
                _mapEntry<model.CpuLoad>(
                  _loadKey(5),
                  window,
                  (
                    cpuLoad,
                  ) =>
                      cpuLoad.min5,
                  upperBound,
                  _hoverText,
                  true,
                ),
                _mapEntry<model.CpuLoad>(
                  _loadKey(15),
                  window,
                  (
                    cpuLoad,
                  ) =>
                      cpuLoad.min15,
                  upperBound,
                  _hoverText,
                  true,
                ),
              ],
            ),
          );
        },
      );

  model.CpuLoadHistory? _cpuLoadHistoryModel;
  Future<vlm.FixedLengthMapOfLists> cpuLoadHistory({
    required chart.Window window,
    bool reset = false,
  }) async {
    _cpuLoadHistoryModel = _cpuLoadHistoryModel == null || reset
        ? await _client.cpuLoadHistory()
        : _cpuLoadHistoryModel;

    final fixedLength = [
      0,
      _cpuLoadHistoryModel!.min1.length,
      _cpuLoadHistoryModel!.min5.length,
      _cpuLoadHistoryModel!.min15.length
    ].reduce(
      math.max,
    );

    final upperBound = [
      0.01,
      ..._cpuLoadHistoryModel!.min1
          .skip(
            window.index,
          )
          .take(
            window.width,
          )
          .map(
            (
              timeStamp,
            ) =>
                timeStamp.value,
          ),
      ..._cpuLoadHistoryModel!.min5
          .skip(
            window.index,
          )
          .take(
            window.width,
          )
          .map(
            (
              timeStamp,
            ) =>
                timeStamp.value,
          ),
      ..._cpuLoadHistoryModel!.min15
          .skip(
            window.index,
          )
          .take(
            window.width,
          )
          .map(
            (
              timeStamp,
            ) =>
                timeStamp.value,
          ),
    ].reduce(
      math.max,
    );

    return vlm.FixedLengthMapOfLists(
      (
        b,
      ) {
        b
          ..fixedLength = fixedLength
          ..map = bc.MapBuilder(
            Map.fromEntries(
              [
                _historyMapEntry(
                  _loadKey(1),
                  window,
                  _cpuLoadHistoryModel!.min1,
                  upperBound,
                  _hoverText,
                  true,
                ),
                _historyMapEntry(
                  _loadKey(5),
                  window,
                  _cpuLoadHistoryModel!.min5,
                  upperBound,
                  _hoverText,
                  true,
                ),
                _historyMapEntry(
                  _loadKey(15),
                  window,
                  _cpuLoadHistoryModel!.min15,
                  upperBound,
                  _hoverText,
                  true,
                ),
              ],
            ),
          );
      },
    );
  }

  vlm.MapOfMaps _diskIoListMapBuilder(
      {required StreamWindow<model.DiskIoList> window}) {
    final Iterable<String> diskNames = window.isEmpty
        ? []
        : window.first.timeStamp.model.list.map(
            (
              disk,
            ) =>
                disk.diskName,
          );

    final countsUpperBound = [
      1,
      ...window.map(
        (
          index,
        ) =>
            [
          1,
          ...index.timeStamp.model.list.map(
            (
              disk,
            ) =>
                disk.readCount,
          ),
        ].reduce(
          math.max,
        ),
      ),
      ...window.map(
        (
          index,
        ) =>
            [
          1,
          ...index.timeStamp.model.list.map(
            (
              disk,
            ) =>
                disk.writeCount,
          ),
        ].reduce(
          math.max,
        ),
      ),
    ]
        .reduce(
          math.max,
        )
        .toDouble();

    final memoryUpperBound = ([
      1,
      ...window.map(
        (
          index,
        ) =>
            [
          1,
          ...index.timeStamp.model.list.map(
            (
              disk,
            ) =>
                disk.readBytes,
          ),
        ].reduce(
          math.max,
        ),
      ),
      ...window.map(
        (
          index,
        ) =>
            [
          1,
          ...index.timeStamp.model.list.map(
            (
              disk,
            ) =>
                disk.writeBytes,
          ),
        ].reduce(
          math.max,
        ),
      ),
    ])
        .reduce(
          math.max,
        )
        .toDouble();

    return vlm.MapOfMaps(
      (
        b,
      ) =>
          b.map = bc.MapBuilder(
        Map.fromEntries(
          diskNames.map(
            (
              name,
            ) =>
                MapEntry(
              name,
              vlm.MapOfMaps(
                (
                  b,
                ) {
                  String diskIoText(String key) => '$name $key';

                  MapEntry<String, vlm.ListOfValues> mapEntry(
                    String key,
                    int Function(model.DiskIo) getter,
                    double upperBound,
                    String Function(String, num) hoverTextFunc,
                  ) =>
                      MapEntry(
                        key,
                        vlm.ListOfValues(
                          (
                            b,
                          ) =>
                              b
                                ..color = _colorFromKey(
                                  diskIoText(
                                    key,
                                  ),
                                )
                                ..selectionText = diskIoText(
                                  key,
                                )
                                ..defaultVisible = true
                                ..list = bc.ListBuilder(
                                  window.map(
                                    (
                                      index,
                                    ) =>
                                        vlm.Value(
                                      (
                                        b,
                                      ) {
                                        final disk = index.timeStamp.model.list
                                            .firstWhere(
                                          (
                                            disk,
                                          ) =>
                                              disk.diskName == name,
                                        );

                                        b
                                          ..timeStamp =
                                              index.timeStamp.timeStamp
                                          ..value = getter(
                                            disk,
                                          )
                                          ..normalized = getter(
                                                disk,
                                              ).toDouble() /
                                              upperBound
                                          ..hoverText = hoverTextFunc(
                                            diskIoText(
                                              key,
                                            ),
                                            getter(
                                              disk,
                                            ),
                                          )
                                          ..streamIndex = index.index;
                                      },
                                    ),
                                  ),
                                ),
                        ),
                      );

                  b.map = bc.MapBuilder(
                    {
                      'Counts': vlm.MapOfLists(
                        (
                          b,
                        ) =>
                            b.map = bc.MapBuilder(
                          Map.fromEntries(
                            [
                              mapEntry(
                                'Read Count',
                                (
                                  disk,
                                ) =>
                                    disk.readCount,
                                countsUpperBound,
                                _hoverText,
                              ),
                              mapEntry(
                                'Write Count',
                                (
                                  disk,
                                ) =>
                                    disk.writeCount,
                                countsUpperBound,
                                _hoverText,
                              ),
                            ],
                          ),
                        ),
                      ),
                      'Memory': vlm.MapOfLists(
                        (
                          b,
                        ) =>
                            b.map = bc.MapBuilder(
                          Map.fromEntries(
                            [
                              mapEntry(
                                'Read Memory',
                                (
                                  disk,
                                ) =>
                                    disk.readBytes,
                                memoryUpperBound,
                                _bytesToMegabytesHoverText,
                              ),
                              mapEntry(
                                'Write Memory',
                                (
                                  disk,
                                ) =>
                                    disk.writeBytes,
                                memoryUpperBound,
                                _bytesToMegabytesHoverText,
                              ),
                            ],
                          ),
                        ),
                      ),
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  model.DiskIoHistory? _diskIoHistoryModel;
  Future<vlm.FixedLengthMapOfMapOfLists> diskIoHistory({
    required chart.Window window,
    bool reset = false,
  }) async {
    _diskIoHistoryModel = _diskIoHistoryModel == null || reset
        ? await _client.diskIoHistory()
        : _diskIoHistoryModel;

    return vlm.FixedLengthMapOfMapOfLists(
      (
        b,
      ) {
        final fixedLength = [
          0,
          ..._diskIoHistoryModel!.history.values.map(
            (
              list,
            ) =>
                list.length,
          ),
        ].reduce(
          math.max,
        );

        final upperBound = [
          1.0,
          _diskIoHistoryModel!.history.values
              .map(
                (
                  list,
                ) =>
                    [
                  1,
                  ...list
                      .skip(
                        window.index,
                      )
                      .take(
                        window.width,
                      )
                      .map(
                        (
                          timeStamp,
                        ) =>
                            timeStamp.value,
                      ),
                ].reduce(
                  math.max,
                ),
              )
              .reduce(
                math.max,
              )
              .toDouble(),
        ].reduce(
          math.max,
        );

        final diskIoRegExp = RegExp(r'(.*)_(read|write)');

        String parseReadWrite(String key) =>
            diskIoRegExp.firstMatch(key)!.group(2)!;

        String parseDiskName(String key) =>
            diskIoRegExp.firstMatch(key)!.group(1)!;

        bc.BuiltMap<String, Map<String, String>> groupKeys(
            Iterable<String> keys) {
          final groupMap = {};

          for (final key in keys) {
            groupMap.update(
              parseReadWrite(
                key,
              ),
              (
                map,
              ) =>
                  map
                    ..addAll(
                      {
                        parseDiskName(
                          key,
                        ): key,
                      },
                    ),
              ifAbsent: () => {
                parseDiskName(
                  key,
                ): key,
              },
            );
          }

          return bc.BuiltMap(
            groupMap,
          );
        }

        MapEntry<String, vlm.FixedLengthMapOfLists> mapEntry(
                String key, String groupKey) =>
            MapEntry(
              key,
              vlm.FixedLengthMapOfLists(
                (
                  b,
                ) =>
                    b
                      ..fixedLength = fixedLength
                      ..map = bc.MapBuilder(
                        groupKeys(_diskIoHistoryModel!.history.keys)[groupKey]!
                            .map(
                          (
                            diskName,
                            key,
                          ) =>
                              MapEntry(
                            diskName,
                            vlm.ListOfValues(
                              (
                                b,
                              ) {
                                final label = '$diskName $key';

                                b
                                  ..color = _colorFromKey(
                                    label,
                                  )
                                  ..selectionText = label
                                  ..defaultVisible = true
                                  ..list = bc.ListBuilder(
                                    _diskIoHistoryModel!.history[key]!
                                        .mapIndexed(
                                          (
                                            index,
                                            timeStamp,
                                          ) =>
                                              vlm.Value(
                                            (
                                              b,
                                            ) =>
                                                b
                                                  ..timeStamp =
                                                      timeStamp.timeStamp
                                                  ..value = timeStamp.value
                                                  ..normalized =
                                                      timeStamp.value /
                                                          upperBound
                                                  ..hoverText =
                                                      _bytesToMegabytesHoverText(
                                                    label,
                                                    timeStamp.value,
                                                  )
                                                  ..streamIndex = index,
                                          ),
                                        )
                                        .skip(
                                          window.index,
                                        )
                                        .take(
                                          window.width,
                                        ),
                                  );
                              },
                            ),
                          ),
                        ),
                      ),
              ),
            );

        b
          ..fixedLength = fixedLength
          ..map = bc.MapBuilder(
            Map.fromEntries(
              [
                mapEntry(
                  'Read Memory',
                  'read',
                ),
                mapEntry(
                  'Write Memory',
                  'write',
                ),
              ],
            ),
          );
      },
    );
  }

  vlm.MapOfMaps _fileSystemListMapBuilder(
          {required StreamWindow<model.FileSystemList> window}) =>
      vlm.MapOfMaps(
        (
          b,
        ) {
          final Iterable<String> deviceNames = window.isEmpty
              ? []
              : window.first.timeStamp.model.list.map(
                  (
                    device,
                  ) =>
                      device.deviceName,
                );

          b.map = bc.MapBuilder(
            Map.fromEntries(
              deviceNames.map(
                (
                  name,
                ) =>
                    MapEntry(
                  name,
                  vlm.MapOfLists(
                    (
                      b,
                    ) {
                      final device =
                          window.first.timeStamp.model.list.firstWhere(
                        (
                          device,
                        ) =>
                            device.deviceName == name,
                      );

                      MapEntry<String, vlm.ListOfValues> mapEntry(
                        String key,
                        int Function(model.FileSystem) getter,
                      ) =>
                          MapEntry(
                            key,
                            vlm.ListOfValues(
                              (
                                b,
                              ) {
                                final label = '$name $key';

                                b
                                  ..color = _colorFromKey(
                                    label,
                                  )
                                  ..selectionText = label
                                  ..defaultVisible = true
                                  ..list = bc.ListBuilder(
                                    window.map(
                                      (
                                        index,
                                      ) =>
                                          vlm.Value(
                                        (
                                          b,
                                        ) =>
                                            b
                                              ..timeStamp =
                                                  index.timeStamp.timeStamp
                                              ..value = getter(
                                                device,
                                              )
                                              ..normalized = getter(
                                                    device,
                                                  ).toDouble() /
                                                  device.size.toDouble()
                                              ..hoverText =
                                                  _bytesToGigabytesHoverText(
                                                label,
                                                getter(
                                                  device,
                                                ),
                                              )
                                              ..streamIndex = index.index,
                                      ),
                                    ),
                                  );
                              },
                            ),
                          );

                      b
                        ..hoverText = vlm.FileSystemHoverText(
                          (
                            b,
                          ) =>
                              b
                                ..type = device.type
                                ..mountPoint = device.mountPoint,
                        )
                        ..map = bc.MapBuilder(
                          Map.fromEntries(
                            [
                              mapEntry(
                                'Used',
                                (
                                  fileSystem,
                                ) =>
                                    fileSystem.used,
                              ),
                              mapEntry(
                                'Free',
                                (
                                  fileSystem,
                                ) =>
                                    fileSystem.free,
                              ),
                            ],
                          ),
                        );
                    },
                  ),
                ),
              ),
            ),
          );
        },
      );

  model.FileSystemHistory? _fileSystemHistoryModel;
  Future<vlm.FixedLengthMapOfLists> fileSystemHistory({
    required chart.Window window,
    bool reset = false,
  }) async {
    _fileSystemHistoryModel = _fileSystemHistoryModel == null || reset
        ? await _client.fileSystemHistory()
        : _fileSystemHistoryModel;

    return vlm.FixedLengthMapOfLists(
      (
        b,
      ) {
        final fixedLength = ([
          0,
          ..._fileSystemHistoryModel!.history.values.map(
            (
              list,
            ) =>
                list.length,
          ),
        ]).reduce(
          math.max,
        );

        b
          ..fixedLength = fixedLength
          ..map = bc.MapBuilder(
            _fileSystemHistoryModel!.history.map(
              (name, list) => _historyMapEntry(
                name,
                window,
                list,
                _percentUpperBound,
                _percentHoverText,
                true,
              ),
            ),
          );
      },
    );
  }

  vlm.MapOfLists _memoryListMapBuilder(
          {required StreamWindow<model.Memory> window}) =>
      vlm.MapOfLists(
        (
          b,
        ) {
          final upperBound = window.isEmpty
              ? 1.0
              : window.first.timeStamp.model.total.toDouble();

          b.map = bc.MapBuilder(
            Map.fromEntries(
              [
                _mapEntry<model.Memory>(
                  'Available',
                  window,
                  (
                    memory,
                  ) =>
                      memory.available,
                  upperBound,
                  _bytesToGigabytesHoverText,
                ),
                _mapEntry<model.Memory>(
                  'Used',
                  window,
                  (
                    memory,
                  ) =>
                      memory.used,
                  upperBound,
                  _bytesToGigabytesHoverText,
                  true,
                ),
                _mapEntry<model.Memory>(
                  'Free',
                  window,
                  (
                    memory,
                  ) =>
                      memory.free,
                  upperBound,
                  _bytesToGigabytesHoverText,
                ),
                _mapEntry<model.Memory>(
                  'Active',
                  window,
                  (
                    memory,
                  ) =>
                      memory.active,
                  upperBound,
                  _bytesToGigabytesHoverText,
                ),
                _mapEntry<model.Memory>(
                  'Inactive',
                  window,
                  (
                    memory,
                  ) =>
                      memory.inactive,
                  upperBound,
                  _bytesToGigabytesHoverText,
                ),
                _mapEntry<model.Memory>(
                  'Buffers',
                  window,
                  (
                    memory,
                  ) =>
                      memory.buffers,
                  upperBound,
                  _bytesToGigabytesHoverText,
                ),
                _mapEntry<model.Memory>(
                  'Cached',
                  window,
                  (
                    memory,
                  ) =>
                      memory.cached,
                  upperBound,
                  _bytesToGigabytesHoverText,
                ),
                _mapEntry<model.Memory>(
                  'Shared',
                  window,
                  (
                    memory,
                  ) =>
                      memory.shared,
                  upperBound,
                  _bytesToGigabytesHoverText,
                ),
              ],
            ),
          );
        },
      );

  model.MemoryHistory? _memoryHistoryModel;
  Future<vlm.FixedLengthMapOfLists> memoryHistory({
    required chart.Window window,
    bool reset = false,
  }) async {
    _memoryHistoryModel = _memoryHistoryModel == null || reset
        ? await _client.memoryHistory()
        : _memoryHistoryModel;

    return vlm.FixedLengthMapOfLists(
      (
        b,
      ) =>
          b
            ..fixedLength = _memoryHistoryModel!.percent.length
            ..map = bc.MapBuilder(
              Map.fromEntries(
                [
                  _historyMapEntry(
                    'Used',
                    window,
                    _memoryHistoryModel!.percent,
                    _percentUpperBound,
                    _percentHoverText,
                  ),
                ],
              ),
            ),
    );
  }

  vlm.MapOfMaps _memorySwapListMapBuilder({
    required StreamWindow<model.MemorySwap> window,
  }) =>
      vlm.MapOfMaps(
        (
          b,
        ) {
          final countsUpperBound = [
            1,
            ...window.map((
              index,
            ) =>
                index.timeStamp.model.sin),
            ...window.map((
              index,
            ) =>
                index.timeStamp.model.sout),
          ]
              .reduce(
                math.max,
              )
              .toDouble();

          final memoryUpperBound = window.isEmpty
              ? 1.0
              : window.first.timeStamp.model.total.toDouble();

          b.map = bc.MapBuilder(
            {
              'Counts': vlm.MapOfLists(
                (
                  b,
                ) =>
                    b.map = bc.MapBuilder(
                  Map.fromEntries(
                    [
                      _mapEntry<model.MemorySwap>(
                        'sin',
                        window,
                        (
                          swap,
                        ) =>
                            swap.sin,
                        countsUpperBound,
                        _hoverText,
                      ),
                      _mapEntry<model.MemorySwap>(
                        'sout',
                        window,
                        (
                          swap,
                        ) =>
                            swap.sout,
                        countsUpperBound,
                        _hoverText,
                      ),
                    ],
                  ),
                ),
              ),
              'Memory': vlm.MapOfLists(
                (
                  b,
                ) =>
                    b.map = bc.MapBuilder(
                  Map.fromEntries(
                    [
                      _mapEntry<model.MemorySwap>(
                        'Used',
                        window,
                        (
                          swap,
                        ) =>
                            swap.used,
                        memoryUpperBound,
                        _bytesToGigabytesHoverText,
                        true,
                      ),
                      _mapEntry<model.MemorySwap>(
                        'Free',
                        window,
                        (
                          swap,
                        ) =>
                            swap.free,
                        memoryUpperBound,
                        _bytesToGigabytesHoverText,
                      ),
                    ],
                  ),
                ),
              ),
            },
          );
        },
      );

  model.MemorySwapHistory? _memorySwapHistoryModel;
  Future<vlm.FixedLengthMapOfLists> memorySwapHistory({
    required chart.Window window,
    bool reset = false,
  }) async {
    _memorySwapHistoryModel = _memorySwapHistoryModel == null || reset
        ? await _client.memorySwapHistory()
        : _memorySwapHistoryModel;

    return vlm.FixedLengthMapOfLists(
      (
        b,
      ) =>
          b
            ..fixedLength = _memorySwapHistoryModel!.percent.length
            ..map = bc.MapBuilder(
              Map.fromEntries(
                [
                  _historyMapEntry(
                    'Used',
                    window,
                    _memorySwapHistoryModel!.percent,
                    _percentUpperBound,
                    _percentHoverText,
                  ),
                ],
              ),
            ),
    );
  }

  vlm.MapOfMaps _networkInterfaceListMapBuilder(
          {required StreamWindow<model.NetworkInterfaceList> window}) =>
      vlm.MapOfMaps(
        (
          b,
        ) {
          final currentUpperBound = [
            1,
            ...window.map(
              (
                index,
              ) =>
                  [
                1,
                ...index.timeStamp.model.list.map(
                  (
                    interface,
                  ) =>
                      interface.rx,
                ),
              ].reduce(
                math.max,
              ),
            ),
            ...window.map(
              (
                index,
              ) =>
                  [
                1,
                ...index.timeStamp.model.list.map(
                  (
                    interface,
                  ) =>
                      interface.tx,
                ),
              ].reduce(
                math.max,
              ),
            ),
            ...window.map(
              (
                index,
              ) =>
                  [
                1,
                ...index.timeStamp.model.list.map(
                  (
                    interface,
                  ) =>
                      interface.cx,
                ),
              ].reduce(
                math.max,
              ),
            ),
          ]
              .reduce(
                math.max,
              )
              .toDouble();

          final cumulativeUpperBound = [
            1,
            ...window.map(
              (
                index,
              ) =>
                  [
                1,
                ...index.timeStamp.model.list.map(
                  (
                    interface,
                  ) =>
                      interface.cumulativeRx,
                ),
              ].reduce(
                math.max,
              ),
            ),
            ...window.map(
              (
                index,
              ) =>
                  [
                1,
                ...index.timeStamp.model.list.map(
                  (
                    interface,
                  ) =>
                      interface.cumulativeTx,
                ),
              ].reduce(
                math.max,
              ),
            ),
            ...window.map(
              (
                index,
              ) =>
                  [
                1,
                ...index.timeStamp.model.list.map(
                  (
                    interface,
                  ) =>
                      interface.cumulativeCx,
                ),
              ].reduce(
                math.max,
              ),
            ),
          ]
              .reduce(
                math.max,
              )
              .toDouble();

          final Iterable<String> interfaceNames = window.isEmpty
              ? []
              : window.first.timeStamp.model.list.map(
                  (
                    interface,
                  ) =>
                      interface.name,
                );

          MapEntry<String, vlm.ListOfValues> mapEntry(
            String name,
            String key,
            int Function(model.NetworkInterface) getter,
            double upperBound,
          ) =>
              MapEntry(
                key,
                vlm.ListOfValues(
                  (
                    b,
                  ) =>
                      b
                        ..color = _colorFromKey(
                          '$name $key',
                        )
                        ..selectionText = '$name $key'
                        ..defaultVisible = true
                        ..list = bc.ListBuilder(
                          window.map(
                            (
                              index,
                            ) =>
                                vlm.Value(
                              (
                                b,
                              ) {
                                final interface = index.timeStamp.model.list
                                    .where(
                                      (
                                        interface,
                                      ) =>
                                          interface.name == name,
                                    )
                                    .first;
                                b
                                  ..timeStamp = index.timeStamp.timeStamp
                                  ..value = getter(interface)
                                  ..normalized =
                                      getter(interface).toDouble() / upperBound
                                  ..hoverText = _bytesToMegabytesHoverText(
                                    '$name $key',
                                    getter(interface),
                                  )
                                  ..streamIndex = index.index;
                              },
                            ),
                          ),
                        ),
                ),
              );

          b.map = bc.MapBuilder(
            {
              'Current': vlm.MapOfMaps(
                (
                  b,
                ) =>
                    b.map = bc.MapBuilder(
                  Map.fromEntries(
                    interfaceNames.map(
                      (
                        name,
                      ) =>
                          MapEntry(
                        name,
                        vlm.MapOfLists(
                          (
                            b,
                          ) =>
                              b.map = bc.MapBuilder(
                            Map.fromEntries(
                              [
                                mapEntry(
                                  name,
                                  'rx',
                                  (
                                    interface,
                                  ) =>
                                      interface.rx,
                                  currentUpperBound,
                                ),
                                mapEntry(
                                  name,
                                  'tx',
                                  (
                                    interface,
                                  ) =>
                                      interface.tx,
                                  currentUpperBound,
                                ),
                                mapEntry(
                                  name,
                                  'cx',
                                  (
                                    interface,
                                  ) =>
                                      interface.cx,
                                  currentUpperBound,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              'Cumulative': vlm.MapOfMaps(
                (
                  b,
                ) =>
                    b.map = bc.MapBuilder(
                  Map.fromEntries(
                    interfaceNames.map(
                      (
                        name,
                      ) =>
                          MapEntry(
                        name,
                        vlm.MapOfLists(
                          (
                            b,
                          ) =>
                              b.map = bc.MapBuilder(
                            Map.fromEntries(
                              [
                                mapEntry(
                                  name,
                                  'Cumulative rx',
                                  (
                                    interface,
                                  ) =>
                                      interface.cumulativeRx,
                                  cumulativeUpperBound,
                                ),
                                mapEntry(
                                  name,
                                  'Cumulative tx',
                                  (
                                    interface,
                                  ) =>
                                      interface.cumulativeTx,
                                  cumulativeUpperBound,
                                ),
                                mapEntry(
                                  name,
                                  'Cumulative cx',
                                  (
                                    interface,
                                  ) =>
                                      interface.cumulativeCx,
                                  cumulativeUpperBound,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            },
          );
        },
      );

  model.NetworkHistory? _networkHistoryModel;
  Future<vlm.FixedLengthMapOfMapOfLists> networkHistory({
    required chart.Window window,
    bool reset = false,
  }) async {
    _networkHistoryModel = _networkHistoryModel == null || reset
        ? await _client.networkHistory()
        : _networkHistoryModel;

    return vlm.FixedLengthMapOfMapOfLists(
      (
        b,
      ) {
        final fixedLength = ([
          0,
          ..._networkHistoryModel!.history.values.map((
            list,
          ) =>
              list.length),
        ]).reduce(
          math.max,
        );

        final upperBound = [
          1,
          ..._networkHistoryModel!.history.values.map(
            (
              list,
            ) =>
                [
              1,
              ...list
                  .skip(
                    window.index,
                  )
                  .take(
                    window.width,
                  )
                  .map(
                    (
                      timeStamp,
                    ) =>
                        timeStamp.value,
                  ),
            ].reduce(
              math.max,
            ),
          ),
        ]
            .reduce(
              math.max,
            )
            .toDouble();

        final interfaceRegExp = RegExp(r'(.*)_(rx|tx)');
        String parseName(String key) =>
            interfaceRegExp.firstMatch(key)!.group(1)!;
        String parseRxTx(String key) =>
            interfaceRegExp.firstMatch(key)!.group(2)!;

        bc.BuiltMap<String, Map<String, String>> groupKeys(
            Iterable<String> keys) {
          final groupMap = {};

          for (final key in keys) {
            groupMap.update(
              parseName(
                key,
              ),
              (
                map,
              ) =>
                  map
                    ..addAll(
                      {
                        parseRxTx(
                          key,
                        ): key,
                      },
                    ),
              ifAbsent: () => {
                parseRxTx(
                  key,
                ): key,
              },
            );
          }

          return bc.BuiltMap(
            groupMap,
          );
        }

        final groupedKeys = groupKeys(_networkHistoryModel!.history.keys);

        b
          ..fixedLength = fixedLength
          ..map = bc.MapBuilder(
            Map.fromEntries(
              groupedKeys.keys.map(
                (
                  name,
                ) =>
                    MapEntry(
                  name,
                  vlm.FixedLengthMapOfLists(
                    (
                      b,
                    ) =>
                        b
                          ..fixedLength = fixedLength
                          ..map = bc.MapBuilder(
                            Map.fromEntries(
                              groupedKeys[name]!.keys.map(
                                    (
                                      rxOrTx,
                                    ) =>
                                        MapEntry(
                                      rxOrTx,
                                      vlm.ListOfValues(
                                        (
                                          b,
                                        ) =>
                                            b
                                              ..color = _colorFromKey(
                                                '$name $rxOrTx',
                                              )
                                              ..selectionText = '$name $rxOrTx'
                                              ..defaultVisible = true
                                              ..list = bc.ListBuilder(
                                                _networkHistoryModel!.history[
                                                        groupedKeys[name]![
                                                            rxOrTx]!]!
                                                    .mapIndexed(
                                                      (
                                                        index,
                                                        timeStamp,
                                                      ) =>
                                                          vlm.Value(
                                                        (
                                                          b,
                                                        ) =>
                                                            b
                                                              ..timeStamp =
                                                                  timeStamp
                                                                      .timeStamp
                                                              ..value =
                                                                  timeStamp
                                                                      .value
                                                              ..normalized =
                                                                  timeStamp
                                                                          .value /
                                                                      upperBound
                                                              ..hoverText =
                                                                  _bytesToMegabytesHoverText(
                                                                '$name $rxOrTx',
                                                                timeStamp.value,
                                                              )
                                                              ..streamIndex =
                                                                  index,
                                                      ),
                                                    )
                                                    .skip(
                                                      window.index,
                                                    )
                                                    .take(
                                                      window.width,
                                                    ),
                                              ),
                                      ),
                                    ),
                                  ),
                            ),
                          ),
                  ),
                ),
              ),
            ),
          );
      },
    );
  }

  vlm.MapOfLists _processCountListMapBuilder(
          {required StreamWindow<model.ProcessCount> window}) =>
      vlm.MapOfLists(
        (
          b,
        ) {
          final upperBound = [
            1,
            ...window.map(
              (
                index,
              ) =>
                  index.timeStamp.model.total,
            ),
            ...window.map(
              (
                index,
              ) =>
                  index.timeStamp.model.running,
            ),
            ...window.map(
              (
                index,
              ) =>
                  index.timeStamp.model.sleeping,
            ),
            ...window.map(
              (
                index,
              ) =>
                  index.timeStamp.model.thread,
            ),
          ]
              .reduce(
                math.max,
              )
              .toDouble();

          b.map = bc.MapBuilder(
            Map.fromEntries(
              [
                _mapEntry<model.ProcessCount>(
                  'Total',
                  window,
                  (
                    processCount,
                  ) =>
                      processCount.total,
                  upperBound,
                  _hoverText,
                ),
                _mapEntry<model.ProcessCount>(
                  'Running',
                  window,
                  (
                    processCount,
                  ) =>
                      processCount.running,
                  upperBound,
                  _hoverText,
                  true,
                ),
                _mapEntry<model.ProcessCount>(
                  'Sleeping',
                  window,
                  (
                    processCount,
                  ) =>
                      processCount.sleeping,
                  upperBound,
                  _hoverText,
                ),
                _mapEntry<model.ProcessCount>(
                  'Thread',
                  window,
                  (
                    processCount,
                  ) =>
                      processCount.thread,
                  upperBound,
                  _hoverText,
                ),
              ],
            ),
          );
        },
      );

  model.ProcessCountHistory? _processCountHistoryModel;
  Future<vlm.FixedLengthMapOfLists> processCountHistory({
    required chart.Window window,
    bool reset = false,
  }) async {
    _processCountHistoryModel = _processCountHistoryModel == null || reset
        ? await _client.processCountHistory()
        : _processCountHistoryModel;

    return vlm.FixedLengthMapOfLists(
      (
        b,
      ) {
        final fixedLength = [
          0,
          _processCountHistoryModel!.total.length,
          _processCountHistoryModel!.running.length,
          _processCountHistoryModel!.sleeping.length,
          _processCountHistoryModel!.thread.length
        ].reduce(
          math.max,
        );

        final upperBound = [
          0,
          ..._processCountHistoryModel!.total
              .skip(
                window.index,
              )
              .take(
                window.width,
              )
              .map(
                (
                  timeStamp,
                ) =>
                    timeStamp.value,
              ),
          ..._processCountHistoryModel!.running
              .skip(
                window.index,
              )
              .take(
                window.width,
              )
              .map(
                (
                  timeStamp,
                ) =>
                    timeStamp.value,
              ),
          ..._processCountHistoryModel!.sleeping
              .skip(
                window.index,
              )
              .take(
                window.width,
              )
              .map(
                (
                  timeStamp,
                ) =>
                    timeStamp.value,
              ),
          ..._processCountHistoryModel!.thread
              .skip(
                window.index,
              )
              .take(
                window.width,
              )
              .map(
                (
                  timeStamp,
                ) =>
                    timeStamp.value,
              ),
        ]
            .reduce(
              math.max,
            )
            .toDouble();

        b
          ..fixedLength = fixedLength
          ..map = bc.MapBuilder(
            Map.fromEntries(
              [
                _historyMapEntry(
                  'Total',
                  window,
                  _processCountHistoryModel!.total,
                  upperBound,
                  _hoverText,
                  true,
                ),
                _historyMapEntry(
                  'Running',
                  window,
                  _processCountHistoryModel!.running,
                  upperBound,
                  _hoverText,
                  true,
                ),
                _historyMapEntry(
                  'Sleeping',
                  window,
                  _processCountHistoryModel!.sleeping,
                  upperBound,
                  _hoverText,
                  true,
                ),
                _historyMapEntry(
                  'Thread',
                  window,
                  _processCountHistoryModel!.thread,
                  upperBound,
                  _hoverText,
                  true,
                ),
              ],
            ),
          );
      },
    );
  }

  vlm.MapOfMaps _processListMapBuilder({
    required StreamWindow<model.ProcessList> window,
  }) =>
      vlm.MapOfMaps(
        (
          b,
        ) {
          final numThreadsUpperBound = [
            0,
            [
              0,
              ...window.map(
                (
                  index,
                ) =>
                    [
                  0,
                  ...index.timeStamp.model.list.map((
                    process,
                  ) =>
                      process.numThreads),
                ].reduce(
                  math.max,
                ),
              ),
            ].reduce(
              math.max,
            )
          ]
              .reduce(
                math.max,
              )
              .toDouble();

          final pids = window.isEmpty
              ? []
              : window
                  .map(
                    (
                      index,
                    ) =>
                        Set.from(
                      index.timeStamp.model.list.map(
                        (
                          process,
                        ) =>
                            process.pid,
                      ),
                    ),
                  )
                  .reduce(
                    (
                      accumulator,
                      set,
                    ) =>
                        accumulator.intersection(
                      set,
                    ),
                  )
                  .toList()
                  .sorted(
                    (
                      left,
                      right,
                    ) =>
                        left.compareTo(
                      right,
                    ),
                  );

          MapEntry<String, vlm.MapOfLists> processMapEntry(int pid,
                  [bool? defaultVisible]) =>
              MapEntry(
                '$pid',
                vlm.MapOfLists(
                  (
                    b,
                  ) {
                    MapEntry<String, vlm.ListOfValues> mapEntry(
                      int pid,
                      String key,
                      num Function(model.Process) getter,
                      double upperBound,
                      String Function(String, num) hoverTextFunc,
                    ) =>
                        MapEntry(
                          key,
                          vlm.ListOfValues(
                            (
                              b,
                            ) =>
                                b
                                  ..color = _colorFromKey(
                                    '$pid $key',
                                  )
                                  ..selectionText = key
                                  ..defaultVisible = defaultVisible
                                  ..list = bc.ListBuilder(
                                    window.map(
                                      (
                                        index,
                                      ) =>
                                          vlm.Value(
                                        (
                                          b,
                                        ) {
                                          final process = index
                                              .timeStamp.model.list
                                              .firstWhere(
                                            (
                                              process,
                                            ) =>
                                                process.pid == pid,
                                          );

                                          b
                                            ..timeStamp =
                                                index.timeStamp.timeStamp
                                            ..value = getter(
                                              process,
                                            )
                                            ..normalized = getter(
                                                  process,
                                                ).toDouble() /
                                                upperBound
                                            ..hoverText = hoverTextFunc(
                                              key,
                                              getter(
                                                process,
                                              ),
                                            )
                                            ..streamIndex = index.index;
                                        },
                                      ),
                                    ),
                                  ),
                          ),
                        );

                    final process =
                        window.first.timeStamp.model.list.firstWhere(
                      (
                        process,
                      ) =>
                          process.pid == pid,
                    );

                    b
                      ..hoverText = vlm.ProcessHoverText(
                        (
                          b,
                        ) =>
                            b
                              ..name = process.name
                              ..pid = process.pid,
                      )
                      ..map = bc.MapBuilder(
                        Map.fromEntries(
                          [
                            mapEntry(
                              pid,
                              'Threads',
                              (
                                process,
                              ) =>
                                  process.numThreads,
                              numThreadsUpperBound,
                              _hoverText,
                            ),
                            mapEntry(
                              pid,
                              'Memory',
                              (
                                process,
                              ) =>
                                  process.memoryPercent,
                              _percentUpperBound,
                              _percentHoverText,
                            ),
                            mapEntry(
                              pid,
                              'CPU',
                              (
                                process,
                              ) =>
                                  process.cpuPercent,
                              _percentUpperBound,
                              _percentHoverText,
                            ),
                          ],
                        ),
                      );
                  },
                ),
              );

          b.map = bc.MapBuilder(
            Map.fromEntries(
              [
                ...pids
                    .take(
                      1,
                    )
                    .map(
                      (
                        pid,
                      ) =>
                          processMapEntry(
                        pid,
                        true,
                      ),
                    ),
                ...pids
                    .skip(
                      1,
                    )
                    .map(
                      (
                        pid,
                      ) =>
                          processMapEntry(
                        pid,
                      ),
                    ),
              ],
            ),
          );
        },
      );

  vlm.MapOfMaps _quickLookListMapBuilder(
      {required StreamWindow<model.QuickLook> window}) {
    Iterable<int> cpuNumbers = window.isEmpty
        ? []
        : window
            .map(
              (
                index,
              ) =>
                  index.timeStamp.model.allCpus.map(
                (
                  cpu,
                ) =>
                    cpu.number,
              ),
            )
            .first;

    return vlm.MapOfMaps(
      (
        b,
      ) {
        MapEntry<String, vlm.ListOfValues> mapEntry(
          int cpuNumber,
          String key,
          double Function(model.AllCpus) getter,
        ) =>
            MapEntry(
              key,
              vlm.ListOfValues(
                (
                  b,
                ) {
                  final selectionText = _allCpusSelectionText(
                    cpuNumber,
                    key,
                  );

                  b
                    ..color = _colorFromKey(
                      selectionText,
                    )
                    ..selectionText = selectionText
                    ..defaultVisible = true
                    ..list = bc.ListBuilder(
                      window.map(
                        (
                          index,
                        ) {
                          final cpu = index.timeStamp.model.allCpus.firstWhere(
                            (
                              cpu,
                            ) =>
                                cpu.number == cpuNumber,
                          );
                          return vlm.Value(
                            (
                              b,
                            ) =>
                                b
                                  ..timeStamp = index.timeStamp.timeStamp
                                  ..value = getter(
                                    cpu,
                                  )
                                  ..normalized = getter(
                                        cpu,
                                      ) /
                                      _percentUpperBound
                                  ..hoverText = _percentHoverText(
                                    selectionText,
                                    getter(
                                      cpu,
                                    ),
                                  )
                                  ..streamIndex = index.index,
                          );
                        },
                      ),
                    );
                },
              ),
            );

        b.map = bc.MapBuilder(
          Map.fromEntries(
            [
              MapEntry(
                  'Totals',
                  vlm.MapOfMaps((
                    b,
                  ) =>
                      b
                        ..map = bc.MapBuilder(Map.fromEntries([
                          MapEntry(
                              'CPU',
                              vlm.MapOfLists((
                                b,
                              ) =>
                                  b
                                    ..map = bc.MapBuilder(Map.fromEntries([
                                      _mapEntry<model.QuickLook>(
                                        'CPU Total',
                                        window,
                                        (
                                          cpu,
                                        ) =>
                                            cpu.cpu,
                                        _percentUpperBound,
                                        _percentHoverText,
                                        true,
                                      ),
                                      _mapEntry<model.QuickLook>(
                                        'CPU Speed',
                                        window,
                                        (
                                          cpu,
                                        ) =>
                                            cpu.cpuHertzCurrent,
                                        window.isEmpty
                                            ? 10000000000.0
                                            : window
                                                .first.timeStamp.model.cpuHertz,
                                        _cpuHertzHoverText,
                                      ),
                                    ])))),
                          MapEntry(
                              'Memory',
                              vlm.MapOfLists((
                                b,
                              ) =>
                                  b
                                    ..map = bc.MapBuilder(Map.fromEntries([
                                      _mapEntry<model.QuickLook>(
                                        'Memory Used',
                                        window,
                                        (
                                          cpu,
                                        ) =>
                                            cpu.memory,
                                        _percentUpperBound,
                                        _percentHoverText,
                                      ),
                                      _mapEntry<model.QuickLook>(
                                        'Memory Swap',
                                        window,
                                        (
                                          cpu,
                                        ) =>
                                            cpu.swap,
                                        _percentUpperBound,
                                        _percentHoverText,
                                      ),
                                    ]))))
                        ])))),
              MapEntry(
                'All CPUs',
                vlm.MapOfMaps(
                  (
                    b,
                  ) =>
                      b.map = bc.MapBuilder(
                    Map.fromEntries(
                      cpuNumbers.map(
                        (
                          cpuNumber,
                        ) =>
                            MapEntry(
                          _cpuKey(
                            cpuNumber,
                          ),
                          vlm.MapOfLists(
                            (
                              b,
                            ) =>
                                b.map = bc.MapBuilder(
                              Map.fromEntries(
                                [
                                  mapEntry(
                                    cpuNumber,
                                    'Total',
                                    (
                                      cpu,
                                    ) =>
                                        cpu.total,
                                  ),
                                  mapEntry(
                                    cpuNumber,
                                    'User',
                                    (
                                      cpu,
                                    ) =>
                                        cpu.user,
                                  ),
                                  mapEntry(
                                    cpuNumber,
                                    'System',
                                    (
                                      cpu,
                                    ) =>
                                        cpu.system,
                                  ),
                                  mapEntry(
                                    cpuNumber,
                                    'Idle',
                                    (
                                      cpu,
                                    ) =>
                                        cpu.idle,
                                  ),
                                  mapEntry(
                                    cpuNumber,
                                    'Nice',
                                    (
                                      cpu,
                                    ) =>
                                        cpu.nice,
                                  ),
                                  mapEntry(
                                    cpuNumber,
                                    'IO Wait',
                                    (
                                      cpu,
                                    ) =>
                                        cpu.ioWait,
                                  ),
                                  mapEntry(
                                    cpuNumber,
                                    'IRQ',
                                    (
                                      cpu,
                                    ) =>
                                        cpu.irq,
                                  ),
                                  mapEntry(
                                    cpuNumber,
                                    'Soft IRQ',
                                    (
                                      cpu,
                                    ) =>
                                        cpu.softIrq,
                                  ),
                                  mapEntry(
                                    cpuNumber,
                                    'Steal',
                                    (
                                      cpu,
                                    ) =>
                                        cpu.steal,
                                  ),
                                  mapEntry(
                                    cpuNumber,
                                    'Guest',
                                    (
                                      cpu,
                                    ) =>
                                        cpu.guest,
                                  ),
                                  mapEntry(
                                    cpuNumber,
                                    'Guest Nice',
                                    (
                                      cpu,
                                    ) =>
                                        cpu.softIrq,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  model.QuickLookHistory? _quickLookHistoryModel;
  Future<vlm.MapOfMaps> quickLookHistory({
    required chart.Window window,
    bool reset = false,
  }) async {
    _quickLookHistoryModel = _quickLookHistoryModel == null || reset
        ? await _client.quickLookHistory()
        : _quickLookHistoryModel;

    final fixedLength = [
      0,
      _quickLookHistoryModel!.cpu.length,
      _quickLookHistoryModel!.mem.length,
      _quickLookHistoryModel!.swap.length,
      _quickLookHistoryModel!.allCpus.length,
    ].reduce(
      math.max,
    );

    return vlm.MapOfMaps(
      (
        b,
      ) =>
          b
            ..map = bc.MapBuilder(
              Map.fromEntries(
                [
                  MapEntry(
                    'Totals',
                    vlm.FixedLengthMapOfMapOfLists(
                      (
                        b,
                      ) =>
                          b
                            ..fixedLength = fixedLength
                            ..map = bc.MapBuilder(
                              Map.fromEntries(
                                [
                                  MapEntry(
                                    'CPU',
                                    vlm.FixedLengthMapOfLists(
                                      (
                                        b,
                                      ) =>
                                          b
                                            ..fixedLength = fixedLength
                                            ..map = bc.MapBuilder(
                                              Map.fromEntries(
                                                [
                                                  _historyMapEntry(
                                                    'CPU Total',
                                                    window,
                                                    _quickLookHistoryModel!.cpu,
                                                    _percentUpperBound,
                                                    _percentHoverText,
                                                  ),
                                                ],
                                              ),
                                            ),
                                    ),
                                  ),
                                  MapEntry(
                                    'Memory',
                                    vlm.FixedLengthMapOfLists(
                                      (
                                        b,
                                      ) =>
                                          b
                                            ..fixedLength = fixedLength
                                            ..map = bc.MapBuilder(
                                              Map.fromEntries(
                                                [
                                                  _historyMapEntry(
                                                    'Memory Used',
                                                    window,
                                                    _quickLookHistoryModel!.mem,
                                                    _percentUpperBound,
                                                    _percentHoverText,
                                                  ),
                                                  _historyMapEntry(
                                                    'Memory Swap Used',
                                                    window,
                                                    _quickLookHistoryModel!
                                                        .swap,
                                                    _percentUpperBound,
                                                    _percentHoverText,
                                                  ),
                                                ],
                                              ),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                  MapEntry(
                    'All CPUs',
                    vlm.FixedLengthMapOfMapOfLists(
                      (
                        b,
                      ) {
                        final Iterable<int> cpuNumbers = _quickLookHistoryModel!
                                .allCpus.isEmpty
                            ? []
                            : _quickLookHistoryModel!.allCpus[
                                    _quickLookHistoryModel!.allCpus.keys.first]!
                                .map(
                                (
                                  cpu,
                                ) =>
                                    cpu.number,
                              );

                        final Iterable<DateTime> sortedCPUTimeStamps =
                            _quickLookHistoryModel!.allCpus.keys.sorted();

                        b
                          ..fixedLength = fixedLength
                          ..map = bc.MapBuilder(
                            Map.fromEntries(
                              cpuNumbers.map(
                                (
                                  number,
                                ) =>
                                    MapEntry(
                                  _cpuKey(
                                    number,
                                  ),
                                  vlm.FixedLengthMapOfLists(
                                    (
                                      b,
                                    ) {
                                      MapEntry<String, vlm.ListOfValues>
                                          mapEntry(
                                        String key,
                                        double Function(model.AllCpus) getter,
                                      ) {
                                        final label = '${_cpuKey(number)} $key';
                                        return MapEntry(
                                          key,
                                          vlm.ListOfValues(
                                            (
                                              b,
                                            ) =>
                                                b
                                                  ..color = _colorFromKey(
                                                    label,
                                                  )
                                                  ..selectionText = label
                                                  ..defaultVisible = true
                                                  ..list = bc.ListBuilder(
                                                    sortedCPUTimeStamps
                                                        .mapIndexed(
                                                      (
                                                        index,
                                                        timeStamp,
                                                      ) =>
                                                          vlm.Value((
                                                        b,
                                                      ) {
                                                        final cpu =
                                                            _quickLookHistoryModel!
                                                                .allCpus[
                                                                    timeStamp]!
                                                                .firstWhere(
                                                          (
                                                            cpu,
                                                          ) =>
                                                              cpu.number ==
                                                              number,
                                                        );
                                                        b
                                                          ..timeStamp =
                                                              timeStamp
                                                          ..value = getter(
                                                            cpu,
                                                          )
                                                          ..normalized = getter(
                                                                cpu,
                                                              ) /
                                                              _percentUpperBound
                                                          ..hoverText =
                                                              _percentHoverText(
                                                            label,
                                                            getter(
                                                              cpu,
                                                            ),
                                                          )
                                                          ..streamIndex = index;
                                                      }),
                                                    ),
                                                  ),
                                          ),
                                        );
                                      }

                                      b
                                        ..fixedLength = fixedLength
                                        ..map = bc.MapBuilder(
                                          Map.fromEntries(
                                            [
                                              mapEntry(
                                                'Total',
                                                (
                                                  cpu,
                                                ) =>
                                                    cpu.total,
                                              ),
                                              mapEntry(
                                                'User',
                                                (
                                                  cpu,
                                                ) =>
                                                    cpu.user,
                                              ),
                                              mapEntry(
                                                'System',
                                                (
                                                  cpu,
                                                ) =>
                                                    cpu.system,
                                              ),
                                              mapEntry(
                                                'Idle',
                                                (
                                                  cpu,
                                                ) =>
                                                    cpu.idle,
                                              ),
                                              mapEntry(
                                                'Nice',
                                                (
                                                  cpu,
                                                ) =>
                                                    cpu.nice,
                                              ),
                                              mapEntry(
                                                'IO Wait',
                                                (
                                                  cpu,
                                                ) =>
                                                    cpu.ioWait,
                                              ),
                                              mapEntry(
                                                'IRQ',
                                                (
                                                  cpu,
                                                ) =>
                                                    cpu.irq,
                                              ),
                                              mapEntry(
                                                'Soft IRQ',
                                                (
                                                  cpu,
                                                ) =>
                                                    cpu.softIrq,
                                              ),
                                              mapEntry(
                                                'Steal',
                                                (
                                                  cpu,
                                                ) =>
                                                    cpu.steal,
                                              ),
                                              mapEntry(
                                                'Guest',
                                                (
                                                  cpu,
                                                ) =>
                                                    cpu.guest,
                                              ),
                                              mapEntry(
                                                'Guest Nice',
                                                (
                                                  cpu,
                                                ) =>
                                                    cpu.guestNice,
                                              ),
                                            ],
                                          ),
                                        );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  vlm.MapOfLists _sensorListMapBuilder({
    required StreamWindow<model.SensorList> window,
  }) =>
      vlm.MapOfLists(
        (
          b,
        ) {
          final Iterable<String> sensorNames = window.isEmpty
              ? <String>{}
              : Set.from(
                  window.first.timeStamp.model.list.map(
                    (
                      sensor,
                    ) =>
                        sensor.label,
                  ),
                );

          final upperBound = [
            1,
            ...window.map(
              (
                index,
              ) =>
                  index.timeStamp.model.list
                      .map((
                        sensor,
                      ) =>
                          sensor.value)
                      .reduce(
                        math.max,
                      ),
            )
          ]
              .reduce(
                math.max,
              )
              .toDouble();

          b.map = bc.MapBuilder(
            Map.fromEntries(
              sensorNames.map(
                (
                  name,
                ) =>
                    MapEntry(
                  name,
                  vlm.ListOfValues((
                    b,
                  ) {
                    b
                      ..color = _colorFromKey(name)
                      ..selectionText = name
                      ..defaultVisible = true
                      ..list = bc.ListBuilder(window.map(
                        (
                          index,
                        ) {
                          final sensor = index.timeStamp.model.list.firstWhere(
                            (
                              sensor,
                            ) =>
                                sensor.label == name,
                          );
                          return vlm.Value(
                            (
                              b,
                            ) =>
                                b
                                  ..timeStamp = index.timeStamp.timeStamp
                                  ..value = sensor.value
                                  ..normalized =
                                      sensor.value.toDouble() / upperBound
                                  ..hoverText =
                                      '$name ${sensor.value.toDouble().toStringAsFixed(
                                            2,
                                          )} °${sensor.unit}'
                                  ..streamIndex = index.index,
                          );
                        },
                      ));
                  }),
                ),
              ),
            ),
          );
        },
      );

  ValueListMapBuilder({
    required glances_client.Client client,
  }) : _client = client {
    _cpuList = _client.listFuncBuilder(
      modelFunc: _client.cpu,
    );
    _allCpusList = _client.listFuncBuilder(
      modelFunc: _client.allCpus,
    );
    _cpuLoadList = _client.listFuncBuilder(
      modelFunc: _client.cpuLoad,
    );
    _diskIoList = _client.listFuncBuilder(
      modelFunc: _client.diskIo,
    );
    _fileSystemList = _client.listFuncBuilder(
      modelFunc: _client.fileSystem,
    );
    _memoryList = _client.listFuncBuilder(
      modelFunc: _client.memory,
    );
    _memorySwapList = _client.listFuncBuilder(
      modelFunc: _client.memorySwap,
    );
    _networkInterfaceList = _client.listFuncBuilder(
      modelFunc: _client.networkInterface,
    );
    _processCountList = _client.listFuncBuilder(
      modelFunc: _client.processCount,
    );
    _processList = _client.listFuncBuilder(
      modelFunc: _client.processList,
    );
    _quickLookList = _client.listFuncBuilder(
      modelFunc: _client.quickLook,
    );
    _sensorList = _client.listFuncBuilder(
      modelFunc: _client.sensors,
    );

    cpuStreamIndexList = _streamIndexListFuncBuilder(
      listFunc: _cpuList,
    );
    allCpusStreamIndexList = _streamIndexListFuncBuilder(
      listFunc: _allCpusList,
    );
    cpuLoadStreamIndexList = _streamIndexListFuncBuilder(
      listFunc: _cpuLoadList,
    );
    diskIoStreamIndexList = _streamIndexListFuncBuilder(
      listFunc: _diskIoList,
    );
    fileSystemStreamIndexList = _streamIndexListFuncBuilder(
      listFunc: _fileSystemList,
    );
    memoryStreamIndexList = _streamIndexListFuncBuilder(
      listFunc: _memoryList,
    );
    memorySwapStreamIndexList = _streamIndexListFuncBuilder(
      listFunc: _memorySwapList,
    );
    networkInterfaceStreamIndexList = _streamIndexListFuncBuilder(
      listFunc: _networkInterfaceList,
    );
    processCountStreamIndexList = _streamIndexListFuncBuilder(
      listFunc: _processCountList,
    );
    processStreamIndexList = _streamIndexListFuncBuilder(
      listFunc: _processList,
    );
    quickLookStreamIndexList = _streamIndexListFuncBuilder(
      listFunc: _quickLookList,
    );
    sensorStreamIndexList = _streamIndexListFuncBuilder(
      listFunc: _sensorList,
    );

    cpuMap = _listFuncBuilder<vlm.MapOfMaps, model.Cpu>(
      listFunc: _cpuList,
      mapBuilder: _cpuListMapBuilder,
    );
    allCpusMap = _listFuncBuilder<vlm.MapOfMaps, model.AllCpusList>(
      listFunc: _allCpusList,
      mapBuilder: _allCpusListMapBuilder,
    );
    cpuLoadMap = _listFuncBuilder<vlm.MapOfLists, model.CpuLoad>(
      listFunc: _cpuLoadList,
      mapBuilder: _cpuLoadListMapBuilder,
    );
    diskIoMap = _listFuncBuilder<vlm.MapOfMaps, model.DiskIoList>(
      listFunc: _diskIoList,
      mapBuilder: _diskIoListMapBuilder,
    );
    fileSystemMap = _listFuncBuilder<vlm.MapOfMaps, model.FileSystemList>(
      listFunc: _fileSystemList,
      mapBuilder: _fileSystemListMapBuilder,
    );
    memoryMap = _listFuncBuilder<vlm.MapOfLists, model.Memory>(
      listFunc: _memoryList,
      mapBuilder: _memoryListMapBuilder,
    );
    memorySwapMap = _listFuncBuilder<vlm.MapOfMaps, model.MemorySwap>(
      listFunc: _memorySwapList,
      mapBuilder: _memorySwapListMapBuilder,
    );
    networkInterfaceMap =
        _listFuncBuilder<vlm.MapOfMaps, model.NetworkInterfaceList>(
      listFunc: _networkInterfaceList,
      mapBuilder: _networkInterfaceListMapBuilder,
    );
    processCountMap = _listFuncBuilder<vlm.MapOfLists, model.ProcessCount>(
      listFunc: _processCountList,
      mapBuilder: _processCountListMapBuilder,
    );
    processMap = _listFuncBuilder<vlm.MapOfMaps, model.ProcessList>(
      listFunc: _processList,
      mapBuilder: _processListMapBuilder,
    );
    quickLookMap = _listFuncBuilder<vlm.MapOfMaps, model.QuickLook>(
      listFunc: _quickLookList,
      mapBuilder: _quickLookListMapBuilder,
    );
    sensorMap = _listFuncBuilder<vlm.MapOfLists, model.SensorList>(
      listFunc: _sensorList,
      mapBuilder: _sensorListMapBuilder,
    );
  }
}

final builder = ValueListMapBuilder(
  client: glances_client.client,
);
