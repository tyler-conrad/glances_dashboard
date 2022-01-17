import 'package:test/test.dart' as test;

import 'package:glances_dashboard/src/mock_client.dart' as mock_client;
import 'package:glances_dashboard/src/value_list_map.dart' as vlm;
import 'package:glances_dashboard/src/value_list_map_builder.dart' as vlmb;
import 'package:glances_dashboard/src/chart.dart' as chart;

void main() {
  final builder = vlmb.ValueListMapBuilder(
    client: mock_client.MockClient(),
  );

  test.group(
    'cpuStreamIndexList',
    () {
      test.test(
        'is not empty',
        () async {
          await builder.cpuStreamIndexList();
          await Future.delayed(
            const Duration(seconds: 2),
          );
          test.expect(
            await builder.cpuStreamIndexList(),
            test.isNotEmpty,
          );
        },
      );
    },
  );

  test.group(
    'allCpusStreamIndexList',
    () {
      test.test(
        'is not empty',
        () async {
          await builder.allCpusStreamIndexList();
          await Future.delayed(
            const Duration(seconds: 2),
          );
          test.expect(
            await builder.allCpusStreamIndexList(),
            test.isNotEmpty,
          );
        },
      );
    },
  );

  test.group(
    'cpuLoadStreamIndexList',
    () {
      test.test(
        'is not empty',
        () async {
          await builder.cpuLoadStreamIndexList();
          await Future.delayed(
            const Duration(seconds: 2),
          );
          test.expect(
            await builder.cpuLoadStreamIndexList(),
            test.isNotEmpty,
          );
        },
      );
    },
  );

  test.group(
    'diskIoStreamIndexList',
    () {
      test.test(
        'is not empty',
        () async {
          await builder.diskIoStreamIndexList();
          await Future.delayed(
            const Duration(seconds: 2),
          );
          test.expect(
            await builder.diskIoStreamIndexList(),
            test.isNotEmpty,
          );
        },
      );
    },
  );

  test.group(
    'fileSystemStreamIndexList',
    () {
      test.test(
        'is not empty',
        () async {
          await builder.fileSystemStreamIndexList();
          await Future.delayed(
            const Duration(seconds: 2),
          );
          test.expect(
            await builder.fileSystemStreamIndexList(),
            test.isNotEmpty,
          );
        },
      );
    },
  );

  test.group(
    'memoryStreamIndexList',
    () {
      test.test(
        'is not empty',
        () async {
          await builder.memoryStreamIndexList();
          await Future.delayed(
            const Duration(seconds: 2),
          );
          test.expect(
            await builder.memoryStreamIndexList(),
            test.isNotEmpty,
          );
        },
      );
    },
  );

  test.group(
    'memorySwapStreamIndexList',
    () {
      test.test(
        'is not empty',
        () async {
          await builder.memorySwapStreamIndexList();
          await Future.delayed(
            const Duration(seconds: 2),
          );
          test.expect(
            await builder.memorySwapStreamIndexList(),
            test.isNotEmpty,
          );
        },
      );
    },
  );

  test.group(
    'networkInterfaceStreamIndexList',
    () {
      test.test(
        'is not empty',
        () async {
          await builder.networkInterfaceStreamIndexList();
          await Future.delayed(
            const Duration(seconds: 2),
          );
          test.expect(
            await builder.networkInterfaceStreamIndexList(),
            test.isNotEmpty,
          );
        },
      );
    },
  );

  test.group(
    'processCountStreamIndexList',
    () {
      test.test(
        'is not empty',
        () async {
          await builder.processCountStreamIndexList();
          await Future.delayed(
            const Duration(seconds: 2),
          );
          test.expect(
            await builder.processCountStreamIndexList(),
            test.isNotEmpty,
          );
        },
      );
    },
  );

  test.group(
    'processStreamIndexList',
    () {
      test.test(
        'is not empty',
        () async {
          await builder.processStreamIndexList();
          await Future.delayed(
            const Duration(seconds: 2),
          );
          test.expect(
            await builder.processStreamIndexList(),
            test.isNotEmpty,
          );
        },
      );
    },
  );

  test.group(
    'quickLookStreamIndexList',
    () {
      test.test(
        'is not empty',
        () async {
          await builder.quickLookStreamIndexList();
          await Future.delayed(
            const Duration(seconds: 2),
          );
          test.expect(
            await builder.quickLookStreamIndexList(),
            test.isNotEmpty,
          );
        },
      );
    },
  );

  test.group(
    'sensorStreamIndexList',
    () {
      test.test(
        'is not empty',
        () async {
          await builder.sensorStreamIndexList();
          await Future.delayed(
            const Duration(seconds: 2),
          );
          test.expect(
            await builder.sensorStreamIndexList(),
            test.isNotEmpty,
          );
        },
      );
    },
  );

  final _window = chart.Window(
    (
      b,
    ) =>
        b
          ..index = 0
          ..width = 300,
  );

  Future<void> _setup(vlmb.ListFunc<vlm.MapBase> listFunc) async {
    await listFunc(
      window: _window,
    );
    await Future.delayed(
      const Duration(
        seconds: 2,
      ),
    );
  }

  test.group(
    'cpuMap',
    () {
      test.test(
        'is a MapOfMaps',
        () async {
          test.expect(
            await builder.cpuMap(
              window: _window,
            ),
            test.isA<vlm.MapOfMaps>(),
          );
        },
      );

      test.test(
        'is not empty',
        () async {
          _setup(
            builder.cpuMap,
          );
          test.expect(
            (await builder.cpuMap(
              window: _window,
            ))
                .map,
            test.isNotEmpty,
          );
        },
      );

      test.test(
        'has Percentages and Counts keys',
        () async {
          test.expect(
            (await builder.cpuMap(
              window: _window,
            ))
                .map
                .keys,
            test.containsAll(
              [
                'Percentages',
                'Counts',
              ],
            ),
          );
        },
      );

      test.test(
        'Percentages and Counts have the correct keys',
        () async {
          final mapOfMaps = (await builder.cpuMap(
            window: _window,
          ))
              .map;
          final percentages = (mapOfMaps['Percentages']! as vlm.MapOfLists).map;
          final counts = (mapOfMaps['Counts']! as vlm.MapOfLists).map;
          test.expect(
            percentages.keys,
            test.containsAll(
              [
                'Total',
                'User',
                'Nice',
                'System',
                'Idle',
                'IO Wait',
                'IRQ',
                'Soft IRQ',
                'Steal',
                'Guest',
                'Guest Nice',
              ],
            ),
          );

          test.expect(
            counts.keys,
            test.containsAll(
              [
                'Context Switches',
                'Interrupts',
                'Soft Interrupts',
                'System Calls',
              ],
            ),
          );
        },
      );

      test.test(
        'ListOfValues are not empty',
        () async {
          await _setup(builder.cpuMap);
          final mapOfMaps = (await builder.cpuMap(
            window: _window,
          ))
              .map;
          final percentages = (mapOfMaps['Percentages']! as vlm.MapOfLists).map;
          final counts = (mapOfMaps['Counts']! as vlm.MapOfLists).map;
          test.expect(
            percentages['Total']!.list,
            test.isNotEmpty,
          );

          test.expect(
            percentages['User']!.list,
            test.isNotEmpty,
          );

          test.expect(
            percentages['Nice']!.list,
            test.isNotEmpty,
          );

          test.expect(
            percentages['System']!.list,
            test.isNotEmpty,
          );

          test.expect(
            percentages['Idle']!.list,
            test.isNotEmpty,
          );

          test.expect(
            percentages['IO Wait']!.list,
            test.isNotEmpty,
          );

          test.expect(
            percentages['IRQ']!.list,
            test.isNotEmpty,
          );

          test.expect(
            percentages['Soft IRQ']!.list,
            test.isNotEmpty,
          );

          test.expect(
            percentages['Steal']!.list,
            test.isNotEmpty,
          );

          test.expect(
            percentages['Guest']!.list,
            test.isNotEmpty,
          );

          test.expect(
            percentages['Guest Nice']!.list,
            test.isNotEmpty,
          );

          test.expect(
            counts['Context Switches']!.list,
            test.isNotEmpty,
          );

          test.expect(
            counts['Interrupts']!.list,
            test.isNotEmpty,
          );

          test.expect(
            counts['Soft Interrupts']!.list,
            test.isNotEmpty,
          );

          test.expect(
            counts['System Calls']!.list,
            test.isNotEmpty,
          );
        },
      );
    },
  );

  test.group(
    'cpuHistory',
    () {
      test.test(
        'User MapEntry ListOfValues is not empty',
        () async {
          final history = await builder.cpuHistory(
            window: _window,
          );
          test.expect(history.map['User']!.list, test.isNotEmpty);
        },
      );

      test.test(
        'System MapEntry ListOfValues is not empty',
        () async {
          final history = await builder.cpuHistory(
            window: _window,
          );
          test.expect(
            history.map['System']!.list,
            test.isNotEmpty,
          );
        },
      );
    },
  );

  test.group(
    'allCpusMap',
    () {
      test.test(
        'is a MapOfMaps',
        () async {
          test.expect(
            await builder.allCpusMap(
              window: _window,
            ),
            test.isA<vlm.MapOfMaps>(),
          );
        },
      );

      test.test(
        'is not empty',
        () async {
          await _setup(
            builder.allCpusMap,
          );
          test.expect(
            (await builder.allCpusMap(
              window: _window,
            ))
                .map,
            test.isNotEmpty,
          );
        },
      );

      test.test(
        'Core 0 MapEntry has the correct keys',
        () async {
          test.expect(
            ((await builder.allCpusMap(
              window: _window,
            ))
                    .map['Core 0']! as vlm.MapOfLists)
                .map
                .keys,
            test.containsAll(
              [
                'Total',
                'User',
                'System',
                'Idle',
                'Nice',
                'IO Wait',
                'IRQ',
                'Soft IRQ',
                'Steal',
                'Guest',
                'Guest Nice',
              ],
            ),
          );
        },
      );

      test.test(
        'Core 0 MapEntry has non-empty ListOfValues',
        () async {
          _setup(builder.allCpusMap);
          final map = ((await builder.allCpusMap(
            window: _window,
          ))
                  .map['Core 0']! as vlm.MapOfLists)
              .map;

          test.expect(
            map['Total']!.list,
            test.isNotEmpty,
          );

          test.expect(
            map['User']!.list,
            test.isNotEmpty,
          );

          test.expect(
            map['System']!.list,
            test.isNotEmpty,
          );

          test.expect(
            map['Idle']!.list,
            test.isNotEmpty,
          );

          test.expect(
            map['Nice']!.list,
            test.isNotEmpty,
          );

          test.expect(
            map['IO Wait']!.list,
            test.isNotEmpty,
          );

          test.expect(
            map['IRQ']!.list,
            test.isNotEmpty,
          );

          test.expect(
            map['Soft IRQ']!.list,
            test.isNotEmpty,
          );

          test.expect(
            map['Steal']!.list,
            test.isNotEmpty,
          );

          test.expect(
            map['Guest']!.list,
            test.isNotEmpty,
          );

          test.expect(
            map['Guest Nice']!.list,
            test.isNotEmpty,
          );
        },
      );
    },
  );

  test.group(
    'allCpusHistory',
    () {
      test.test(
        'is a FixedLengthMapOfLists',
        () async {
          test.expect(
            await builder.allCpusHistory(window: _window),
            test.isA<vlm.FixedLengthMapOfMapOfLists>(),
          );
        },
      );

      test.test(
        'System key is not empty',
        () async {
          test.expect(
            ((await builder.allCpusHistory(window: _window)).map['System']!
                    as vlm.FixedLengthMapOfLists)
                .map['Core 0']!
                .list,
            test.isNotEmpty,
          );
        },
      );

      test.test(
        'User key is not empty',
        () async {
          test.expect(
            ((await builder.allCpusHistory(window: _window)).map['User']!
                    as vlm.FixedLengthMapOfLists)
                .map['Core 0']!
                .list,
            test.isNotEmpty,
          );
        },
      );
    },
  );

  test.group(
    'cpuLoadMap',
    () {
      test.test(
        'is a MapOfLists',
        () async {
          test.expect(
            await builder.cpuLoadMap(
              window: _window,
            ),
            test.isA<vlm.MapOfLists>(),
          );
        },
      );

      test.test(
        'is not empty',
        () async {
          await _setup(
            builder.cpuLoadMap,
          );

          test.expect(
            (await builder.cpuLoadMap(window: _window)).map,
            test.isNotEmpty,
          );
        },
      );

      test.test(
        'has the correct keys',
        () async {
          test.expect(
            (await builder.cpuLoadMap(window: _window)).map.keys,
            test.containsAll(
              [
                '1 Minute Avg Load',
                '5 Minute Avg Load',
                '15 Minute Avg Load',
              ],
            ),
          );
        },
      );

      test.test(
        'the ListOfValues are not empty',
        () async {
          await _setup(
            builder.cpuLoadMap,
          );
          final load = await builder.cpuLoadMap(window: _window);

          test.expect(
            load.map['1 Minute Avg Load']!.list,
            test.isNotEmpty,
          );
          test.expect(
            load.map['5 Minute Avg Load']!.list,
            test.isNotEmpty,
          );
          test.expect(
            load.map['15 Minute Avg Load']!.list,
            test.isNotEmpty,
          );
        },
      );
    },
  );

  test.group(
    'cpuLoadHistory',
    () {
      test.test(
        'is a FixedLengthMapOfLists',
        () async {
          test.expect(
            await builder.cpuLoadHistory(window: _window),
            test.isA<vlm.FixedLengthMapOfLists>(),
          );
        },
      );

      test.test(
        '1 Minute Avg Load key is not empty',
        () async {
          test.expect(
            (await builder.cpuLoadHistory(
              window: _window,
            ))
                .map['1 Minute Avg Load']!
                .list,
            test.isNotEmpty,
          );
        },
      );

      test.test(
        '5 Minute Avg Load key is not empty',
        () async {
          test.expect(
            (await builder.cpuLoadHistory(
              window: _window,
            ))
                .map['5 Minute Avg Load']!
                .list,
            test.isNotEmpty,
          );
        },
      );

      test.test(
        '15 Minute Avg Load key is not empty',
        () async {
          test.expect(
            (await builder.cpuLoadHistory(
              window: _window,
            ))
                .map['15 Minute Avg Load']!
                .list,
            test.isNotEmpty,
          );
        },
      );
    },
  );

  test.group(
    'diskIoMap',
    () {
      test.test(
        'is a MapOfMaps',
        () async {
          test.expect(
            await builder.diskIoMap(
              window: _window,
            ),
            test.isA<vlm.MapOfMaps>(),
          );
        },
      );

      test.test(
        'is not empty',
        () async {
          await _setup(
            builder.diskIoMap,
          );

          test.expect(
            (await builder.diskIoMap(
              window: _window,
            ))
                .map,
            test.isNotEmpty,
          );
        },
      );

      test.test(
        'has the correct non-empty keys',
        () async {
          await _setup(
            builder.diskIoMap,
          );

          test.expect(
            (((await builder.diskIoMap(window: _window)).map['loop0']!
                        as vlm.MapOfMaps)
                    .map['Counts']! as vlm.MapOfLists)
                .map,
            test.isNotEmpty,
          );

          test.expect(
            (((await builder.diskIoMap(window: _window)).map['loop0']!
                        as vlm.MapOfMaps)
                    .map['Memory']! as vlm.MapOfLists)
                .map,
            test.isNotEmpty,
          );

          test.expect(
            (((await builder.diskIoMap(window: _window)).map['loop0']!
                        as vlm.MapOfMaps)
                    .map['Counts']! as vlm.MapOfLists)
                .map['Read Count']!
                .list,
            test.isNotEmpty,
          );

          test.expect(
            (((await builder.diskIoMap(window: _window)).map['loop0']!
                        as vlm.MapOfMaps)
                    .map['Counts']! as vlm.MapOfLists)
                .map['Write Count']!
                .list,
            test.isNotEmpty,
          );

          test.expect(
            (((await builder.diskIoMap(window: _window)).map['loop0']!
                        as vlm.MapOfMaps)
                    .map['Memory']! as vlm.MapOfLists)
                .map['Read Memory']!
                .list,
            test.isNotEmpty,
          );

          test.expect(
            (((await builder.diskIoMap(window: _window)).map['loop0']!
                        as vlm.MapOfMaps)
                    .map['Memory']! as vlm.MapOfLists)
                .map['Write Memory']!
                .list,
            test.isNotEmpty,
          );
        },
      );
    },
  );

  test.group(
    'diskIoHistory',
    () {
      test.test(
        'is a FixedLengthMapOfMapOfLists',
        () async {
          test.expect(
            await builder.diskIoHistory(window: _window),
            test.isA<vlm.FixedLengthMapOfMapOfLists>(),
          );
        },
      );

      test.test(
        'Read Memory key is not empty',
        () async {
          test.expect(
            ((await builder.diskIoHistory(window: _window)).map['Read Memory']!
                    as vlm.FixedLengthMapOfLists)
                .map,
            test.isNotEmpty,
          );
        },
      );

      test.test(
        'Write Memory key is not empty',
        () async {
          test.expect(
            ((await builder.diskIoHistory(window: _window)).map['Write Memory']!
                    as vlm.FixedLengthMapOfLists)
                .map,
            test.isNotEmpty,
          );
        },
      );

      test.test(
        'Read Memory loop0 disk has data',
        () async {
          test.expect(
            ((await builder.diskIoHistory(window: _window)).map['Read Memory']!
                    as vlm.FixedLengthMapOfLists)
                .map['loop0']!
                .list,
            test.isNotEmpty,
          );
        },
      );

      test.test(
        'Write Memory loop0 disk has data',
        () async {
          test.expect(
            ((await builder.diskIoHistory(window: _window)).map['Write Memory']!
                    as vlm.FixedLengthMapOfLists)
                .map['loop0']!
                .list,
            test.isNotEmpty,
          );
        },
      );
    },
  );

  test.group(
    'fileSystemMap',
    () {
      test.test(
        'is a MapOfMaps',
        () async {
          test.expect(
            await builder.fileSystemMap(
              window: _window,
            ),
            test.isA<vlm.MapOfMaps>(),
          );
        },
      );

      test.test(
        'is not empty',
        () async {
          await _setup(
            builder.fileSystemMap,
          );

          test.expect(
            (await builder.fileSystemMap(window: _window)).map,
            test.isNotEmpty,
          );
        },
      );

      test.test(
        'sdb5 file system has the correct keys',
        () async {
          await _setup(
            builder.fileSystemMap,
          );

          test.expect(
            ((await builder.fileSystemMap(window: _window)).map['/dev/sdb5']!
                    as vlm.MapOfLists)
                .map['Used']!
                .list,
            test.isNotEmpty,
          );

          test.expect(
            ((await builder.fileSystemMap(window: _window)).map['/dev/sdb5']!
                    as vlm.MapOfLists)
                .map['Free']!
                .list,
            test.isNotEmpty,
          );
        },
      );
    },
  );

  test.group(
    'fileSystemHistory',
    () {
      test.test(
        'is a FixedLengthMapOfLists',
        () async {
          test.expect(
            await builder.fileSystemHistory(window: _window),
            test.isA<vlm.FixedLengthMapOfLists>(),
          );
        },
      );

      test.test(
        'is not emtpy',
        () async {
          test.expect(
            (await builder.fileSystemHistory(window: _window)).map,
            test.isNotEmpty,
          );
        },
      );

      test.test(
        '/_percent file system entry is not empty',
        () async {
          test.expect(
            (await builder.fileSystemHistory(window: _window))
                .map['/_percent']!
                .list,
            test.isNotEmpty,
          );
        },
      );
    },
  );

  test.group(
    'memoryMap',
    () {
      test.test(
        'is a MapOfLists',
        () async {
          test.expect(
            await builder.memoryMap(window: _window),
            test.isA<vlm.MapOfLists>(),
          );
        },
      );

      test.test(
        'is not empty',
        () async {
          await _setup(
            builder.memoryMap,
          );

          test.expect(
            (await builder.memoryMap(window: _window)).map,
            test.isNotEmpty,
          );
        },
      );

      test.test(
        'has the correct keys',
        () async {
          await _setup(
            builder.memoryMap,
          );

          test.expect(
            (await builder.memoryMap(window: _window)).map.keys,
            test.containsAll(
              [
                'Available',
                'Used',
                'Free',
                'Active',
                'Inactive',
                'Buffers',
                'Cached',
                'Shared',
              ],
            ),
          );
        },
      );

      test.test(
        'the ListOfValues are not empty',
        () async {
          await _setup(
            builder.memoryMap,
          );

          test.expect(
            (await builder.memoryMap(
              window: _window,
            ))
                .map['Available']!
                .list,
            test.isNotEmpty,
          );

          test.expect(
            (await builder.memoryMap(
              window: _window,
            ))
                .map['Used']!
                .list,
            test.isNotEmpty,
          );

          test.expect(
            (await builder.memoryMap(
              window: _window,
            ))
                .map['Free']!
                .list,
            test.isNotEmpty,
          );

          test.expect(
            (await builder.memoryMap(
              window: _window,
            ))
                .map['Active']!
                .list,
            test.isNotEmpty,
          );

          test.expect(
            (await builder.memoryMap(
              window: _window,
            ))
                .map['Inactive']!
                .list,
            test.isNotEmpty,
          );

          test.expect(
            (await builder.memoryMap(
              window: _window,
            ))
                .map['Buffers']!
                .list,
            test.isNotEmpty,
          );

          test.expect(
            (await builder.memoryMap(
              window: _window,
            ))
                .map['Cached']!
                .list,
            test.isNotEmpty,
          );

          test.expect(
            (await builder.memoryMap(
              window: _window,
            ))
                .map['Shared']!
                .list,
            test.isNotEmpty,
          );
        },
      );
    },
  );

  test.group(
    'memoryHistory',
    () {
      test.test(
        'is a FixedLengthMapOfLists',
        () async {
          test.expect(
            await builder.memoryHistory(
              window: _window,
            ),
            test.isA<vlm.FixedLengthMapOfLists>(),
          );
        },
      );

      test.test(
        'the Used key is not empty',
        () async {
          test.expect(
            (await builder.memoryHistory(
              window: _window,
            ))
                .map['Used']!
                .list,
            test.isNotEmpty,
          );
        },
      );
    },
  );

  test.group(
    'memorySwapMap',
    () {
      test.test(
        'is a MapOfMaps',
        () async {
          test.expect(
            await builder.memorySwapMap(window: _window),
            test.isA<vlm.MapOfMaps>(),
          );
        },
      );

      test.test(
        'is not empty',
        () async {
          await _setup(
            builder.memorySwapMap,
          );

          test.expect(
            (await builder.memorySwapMap(window: _window)).map,
            test.isNotEmpty,
          );
        },
      );

      test.test(
        'has the correct keys',
        () async {
          await _setup(
            builder.memorySwapMap,
          );

          test.expect(
            (await builder.memorySwapMap(window: _window)).map.keys,
            test.containsAll(
              [
                'Counts',
                'Memory',
              ],
            ),
          );

          test.expect(
            ((await builder.memorySwapMap(window: _window)).map['Counts']!
                    as vlm.MapOfLists)
                .map
                .keys,
            test.containsAll(
              [
                'sin',
                'sout',
              ],
            ),
          );

          test.expect(
            ((await builder.memorySwapMap(window: _window)).map['Memory']!
                    as vlm.MapOfLists)
                .map
                .keys,
            test.containsAll(
              [
                'Used',
                'Free',
              ],
            ),
          );
        },
      );

      test.test(
        'the ListOfValues are not empty',
        () async {
          await _setup(
            builder.memorySwapMap,
          );

          test.expect(
            ((await builder.memorySwapMap(
              window: _window,
            ))
                    .map['Counts']! as vlm.MapOfLists)
                .map['sin']!
                .list,
            test.isNotEmpty,
          );

          test.expect(
            ((await builder.memorySwapMap(
              window: _window,
            ))
                    .map['Counts']! as vlm.MapOfLists)
                .map['sout']!
                .list,
            test.isNotEmpty,
          );

          test.expect(
            ((await builder.memorySwapMap(
              window: _window,
            ))
                    .map['Memory']! as vlm.MapOfLists)
                .map['Used']!
                .list,
            test.isNotEmpty,
          );

          test.expect(
            ((await builder.memorySwapMap(
              window: _window,
            ))
                    .map['Memory']! as vlm.MapOfLists)
                .map['Free']!
                .list,
            test.isNotEmpty,
          );
        },
      );
    },
  );

  test.group(
    'memorySwapHistory',
    () {
      test.test(
        'is a FixedLengthMapOfLists',
        () async {
          test.expect(
            await builder.memorySwapHistory(
              window: _window,
            ),
            test.isA<vlm.FixedLengthMapOfLists>(),
          );
        },
      );

      test.test(
        'the Used key is not empty',
        () async {
          test.expect(
            (await builder.memorySwapHistory(
              window: _window,
            ))
                .map['Used']!
                .list,
            test.isNotEmpty,
          );
        },
      );
    },
  );

  test.group(
    'networkInterfaceMap',
    () {
      test.test(
        'is a MapOfMaps',
        () async {
          test.expect(
            await builder.networkInterfaceMap(window: _window),
            test.isA<vlm.MapOfMaps>(),
          );
        },
      );

      test.test(
        'is not empty',
        () async {
          await _setup(
            builder.networkInterfaceMap,
          );

          test.expect(
            (await builder.networkInterfaceMap(window: _window)).map,
            test.isNotEmpty,
          );
        },
      );

      test.test(
        'has the correct keys',
        () async {
          await _setup(
            builder.networkInterfaceMap,
          );

          test.expect(
            (await builder.networkInterfaceMap(window: _window)).map.keys,
            test.containsAll(
              [
                'Current',
                'Cumulative',
              ],
            ),
          );

          test.expect(
            ((await builder.networkInterfaceMap(window: _window))
                    .map['Current']! as vlm.MapOfMaps)
                .map
                .keys,
            test.containsAll(
              [
                'lo',
                'enp4s0',
                'enp6s0',
              ],
            ),
          );

          test.expect(
            (((await builder.networkInterfaceMap(window: _window))
                        .map['Current']! as vlm.MapOfMaps)
                    .map['lo']! as vlm.MapOfLists)
                .map
                .keys,
            test.containsAll(
              [
                'rx',
                'tx',
                'cx',
              ],
            ),
          );

          test.expect(
            (((await builder.networkInterfaceMap(window: _window))
                        .map['Cumulative']! as vlm.MapOfMaps)
                    .map['lo']! as vlm.MapOfLists)
                .map
                .keys,
            test.containsAll(
              [
                'Cumulative rx',
                'Cumulative tx',
                'Cumulative cx',
              ],
            ),
          );
        },
      );

      test.test(
        'the ListOfValues are not empty',
        () async {
          await _setup(
            builder.networkInterfaceMap,
          );

          test.expect(
            (((await builder.networkInterfaceMap(window: _window))
                        .map['Current']! as vlm.MapOfMaps)
                    .map['lo']! as vlm.MapOfLists)
                .map['rx']!
                .list,
            test.isNotEmpty,
          );

          test.expect(
            (((await builder.networkInterfaceMap(window: _window))
                        .map['Current']! as vlm.MapOfMaps)
                    .map['lo']! as vlm.MapOfLists)
                .map['tx']!
                .list,
            test.isNotEmpty,
          );

          test.expect(
            (((await builder.networkInterfaceMap(window: _window))
                        .map['Current']! as vlm.MapOfMaps)
                    .map['lo']! as vlm.MapOfLists)
                .map['cx']!
                .list,
            test.isNotEmpty,
          );

          test.expect(
            (((await builder.networkInterfaceMap(window: _window))
                        .map['Cumulative']! as vlm.MapOfMaps)
                    .map['lo']! as vlm.MapOfLists)
                .map['Cumulative rx']!
                .list,
            test.isNotEmpty,
          );

          test.expect(
            (((await builder.networkInterfaceMap(window: _window))
                        .map['Cumulative']! as vlm.MapOfMaps)
                    .map['lo']! as vlm.MapOfLists)
                .map['Cumulative tx']!
                .list,
            test.isNotEmpty,
          );

          test.expect(
            (((await builder.networkInterfaceMap(window: _window))
                        .map['Cumulative']! as vlm.MapOfMaps)
                    .map['lo']! as vlm.MapOfLists)
                .map['Cumulative cx']!
                .list,
            test.isNotEmpty,
          );
        },
      );
    },
  );

  test.group(
    'networkHistory',
    () {
      test.test(
        'is a FixedLengthMapOfMapOfLists',
        () async {
          test.expect(
            await builder.networkHistory(window: _window),
            test.isA<vlm.FixedLengthMapOfMapOfLists>(),
          );
        },
      );

      test.test(
        'is not empty',
        () async {
          test.expect(
            (await builder.networkHistory(window: _window)).map,
            test.isNotEmpty,
          );
        },
      );

      test.test(
        'lo interface Current and Cumulative has the correct non-empty keys',
        () async {
          test.expect(
            ((await builder.networkHistory(window: _window)).map['lo']!
                    as vlm.FixedLengthMapOfLists)
                .map['rx']!
                .list,
            test.isNotEmpty,
          );

          test.expect(
            ((await builder.networkHistory(window: _window)).map['lo']!
                    as vlm.FixedLengthMapOfLists)
                .map['tx']!
                .list,
            test.isNotEmpty,
          );
        },
      );
    },
  );

  test.group(
    'processCountMap',
    () {
      test.test(
        'is a MapOfLists',
        () async {
          test.expect(
            await builder.processCountMap(window: _window),
            test.isA<vlm.MapOfLists>(),
          );
        },
      );

      test.test(
        'is not empty',
        () async {
          await _setup(
            builder.processCountMap,
          );

          test.expect(
            (await builder.processCountMap(window: _window)).map,
            test.isNotEmpty,
          );
        },
      );

      test.test(
        'has the correct keys',
        () async {
          await _setup(
            builder.processCountMap,
          );

          test.expect(
            (await builder.processCountMap(window: _window)).map.keys,
            test.containsAll(
              [
                'Total',
                'Running',
                'Sleeping',
                'Thread',
              ],
            ),
          );
        },
      );

      test.test(
        'the ListOfValues are not empty',
        () async {
          await _setup(
            builder.processCountMap,
          );

          test.expect(
            (await builder.processCountMap(window: _window)).map['Total']!.list,
            test.isNotEmpty,
          );

          test.expect(
            (await builder.processCountMap(window: _window))
                .map['Running']!
                .list,
            test.isNotEmpty,
          );

          test.expect(
            (await builder.processCountMap(window: _window))
                .map['Sleeping']!
                .list,
            test.isNotEmpty,
          );

          test.expect(
            (await builder.processCountMap(window: _window))
                .map['Thread']!
                .list,
            test.isNotEmpty,
          );
        },
      );
    },
  );

  test.group(
    'processCountHistory',
    () {
      test.test(
        'is a FixedLengthMapOfLists',
        () async {
          test.expect(
            await builder.processCountHistory(window: _window),
            test.isA<vlm.FixedLengthMapOfLists>(),
          );
        },
      );

      test.test(
        'is not empty',
        () async {
          test.expect(
            (await builder.processCountHistory(window: _window)).map,
            test.isNotEmpty,
          );
        },
      );

      test.test(
        'has the correct non-empty keys',
        () async {
          test.expect(
            (await builder.processCountHistory(window: _window))
                .map['Total']!
                .list,
            test.isNotEmpty,
          );

          test.expect(
            (await builder.processCountHistory(window: _window))
                .map['Running']!
                .list,
            test.isNotEmpty,
          );

          test.expect(
            (await builder.processCountHistory(window: _window))
                .map['Sleeping']!
                .list,
            test.isNotEmpty,
          );

          test.expect(
            (await builder.processCountHistory(window: _window))
                .map['Thread']!
                .list,
            test.isNotEmpty,
          );
        },
      );
    },
  );

  test.group(
    'processMap',
    () {
      test.test(
        'is a MapOfMaps',
        () async {
          test.expect(
            await builder.processMap(
              window: _window,
            ),
            test.isA<vlm.MapOfMaps>(),
          );
        },
      );

      test.test(
        'is not empty',
        () async {
          await _setup(
            builder.processMap,
          );

          test.expect(
            (await builder.processMap(window: _window)).map,
            test.isNotEmpty,
          );
        },
      );

      test.test(
        'has the correct non-empty keys',
        () async {
          await _setup(
            builder.processMap,
          );

          test.expect(
            ((await builder.processMap(window: _window)).map['94929']!
                    as vlm.MapOfLists)
                .map['Threads']!
                .list,
            test.isNotEmpty,
          );

          test.expect(
            ((await builder.processMap(window: _window)).map['94929']!
                    as vlm.MapOfLists)
                .map['Memory']!
                .list,
            test.isNotEmpty,
          );

          test.expect(
            ((await builder.processMap(window: _window)).map['94929']!
                    as vlm.MapOfLists)
                .map['CPU']!
                .list,
            test.isNotEmpty,
          );
        },
      );
    },
  );

  test.group(
    'quickLookMap',
    () {
      test.test(
        'is a MapOfMaps',
        () async {
          test.expect(
            await builder.quickLookMap(window: _window),
            test.isA<vlm.MapOfMaps>(),
          );
        },
      );

      test.test(
        'is not empty',
        () async {
          await _setup(
            builder.quickLookMap,
          );

          test.expect(
            (await builder.quickLookMap(window: _window)).map,
            test.isNotEmpty,
          );
        },
      );

      test.test(
        'has the correct non-empty keys',
        () async {
          await _setup(
            builder.quickLookMap,
          );

          test.expect(
            (((await builder.quickLookMap(window: _window)).map['Totals']!
                        as vlm.MapOfMaps)
                    .map['CPU']! as vlm.MapOfLists)
                .map['CPU Total']!
                .list,
            test.isNotEmpty,
          );

          test.expect(
            (((await builder.quickLookMap(window: _window)).map['Totals']!
                        as vlm.MapOfMaps)
                    .map['CPU']! as vlm.MapOfLists)
                .map['CPU Speed']!
                .list,
            test.isNotEmpty,
          );

          test.expect(
            (((await builder.quickLookMap(window: _window)).map['Totals']!
                        as vlm.MapOfMaps)
                    .map['Memory']! as vlm.MapOfLists)
                .map['Memory Used']!
                .list,
            test.isNotEmpty,
          );

          test.expect(
            (((await builder.quickLookMap(window: _window)).map['Totals']!
                        as vlm.MapOfMaps)
                    .map['Memory']! as vlm.MapOfLists)
                .map['Memory Swap']!
                .list,
            test.isNotEmpty,
          );

          test.expect(
            ((await builder.quickLookMap(window: _window)).map['All CPUs']!
                    as vlm.MapOfMaps)
                .map,
            test.isNotEmpty,
          );

          test.expect(
            (((await builder.quickLookMap(window: _window)).map['All CPUs']!
                        as vlm.MapOfMaps)
                    .map['Core 0']! as vlm.MapOfLists)
                .map,
            test.isNotEmpty,
          );

          test.expect(
            (((await builder.quickLookMap(window: _window)).map['All CPUs']!
                        as vlm.MapOfMaps)
                    .map['Core 0']! as vlm.MapOfLists)
                .map['Total']!
                .list,
            test.isNotEmpty,
          );

          test.expect(
            (((await builder.quickLookMap(window: _window)).map['All CPUs']!
                        as vlm.MapOfMaps)
                    .map['Core 0']! as vlm.MapOfLists)
                .map['User']!
                .list,
            test.isNotEmpty,
          );

          test.expect(
            (((await builder.quickLookMap(window: _window)).map['All CPUs']!
                        as vlm.MapOfMaps)
                    .map['Core 0']! as vlm.MapOfLists)
                .map['System']!
                .list,
            test.isNotEmpty,
          );

          test.expect(
            (((await builder.quickLookMap(window: _window)).map['All CPUs']!
                        as vlm.MapOfMaps)
                    .map['Core 0']! as vlm.MapOfLists)
                .map['Idle']!
                .list,
            test.isNotEmpty,
          );

          test.expect(
            (((await builder.quickLookMap(window: _window)).map['All CPUs']!
                        as vlm.MapOfMaps)
                    .map['Core 0']! as vlm.MapOfLists)
                .map['Nice']!
                .list,
            test.isNotEmpty,
          );

          test.expect(
            (((await builder.quickLookMap(window: _window)).map['All CPUs']!
                        as vlm.MapOfMaps)
                    .map['Core 0']! as vlm.MapOfLists)
                .map['IO Wait']!
                .list,
            test.isNotEmpty,
          );

          test.expect(
            (((await builder.quickLookMap(window: _window)).map['All CPUs']!
                        as vlm.MapOfMaps)
                    .map['Core 0']! as vlm.MapOfLists)
                .map['IRQ']!
                .list,
            test.isNotEmpty,
          );

          test.expect(
            (((await builder.quickLookMap(window: _window)).map['All CPUs']!
                        as vlm.MapOfMaps)
                    .map['Core 0']! as vlm.MapOfLists)
                .map['Soft IRQ']!
                .list,
            test.isNotEmpty,
          );

          test.expect(
            (((await builder.quickLookMap(window: _window)).map['All CPUs']!
                        as vlm.MapOfMaps)
                    .map['Core 0']! as vlm.MapOfLists)
                .map['Steal']!
                .list,
            test.isNotEmpty,
          );

          test.expect(
            (((await builder.quickLookMap(window: _window)).map['All CPUs']!
                        as vlm.MapOfMaps)
                    .map['Core 0']! as vlm.MapOfLists)
                .map['Guest']!
                .list,
            test.isNotEmpty,
          );

          test.expect(
            (((await builder.quickLookMap(window: _window)).map['All CPUs']!
                        as vlm.MapOfMaps)
                    .map['Core 0']! as vlm.MapOfLists)
                .map['Guest Nice']!
                .list,
            test.isNotEmpty,
          );
        },
      );
    },
  );

  test.group(
    'quickLookHistory',
    () {
      test.test(
        'is a MapOfMaps',
        () async {
          test.expect(
            await builder.quickLookHistory(window: _window),
            test.isA<vlm.MapOfMaps>(),
          );
        },
      );

      test.test(
        'has the correct non-empty keys',
        () async {
          test.expect(
            ((await builder.quickLookHistory(window: _window)).map['Totals']!
                    as vlm.FixedLengthMapOfMapOfLists)
                .map,
            test.isNotEmpty,
          );

          test.expect(
            ((await builder.quickLookHistory(window: _window)).map['All CPUs']!
                    as vlm.FixedLengthMapOfMapOfLists)
                .map,
            test.isNotEmpty,
          );

          test.expect(
            (((await builder.quickLookHistory(window: _window)).map['Totals']!
                        as vlm.FixedLengthMapOfMapOfLists)
                    .map['CPU'] as vlm.FixedLengthMapOfLists)
                .map,
            test.isNotEmpty,
          );

          test.expect(
            (((await builder.quickLookHistory(window: _window)).map['Totals']!
                        as vlm.FixedLengthMapOfMapOfLists)
                    .map['Memory'] as vlm.FixedLengthMapOfLists)
                .map,
            test.isNotEmpty,
          );

          test.expect(
            (((await builder.quickLookHistory(window: _window)).map['Totals']!
                        as vlm.FixedLengthMapOfMapOfLists)
                    .map['CPU'] as vlm.FixedLengthMapOfLists)
                .map['CPU Total']!
                .list,
            test.isNotEmpty,
          );

          test.expect(
            (((await builder.quickLookHistory(window: _window)).map['Totals']!
                        as vlm.FixedLengthMapOfMapOfLists)
                    .map['Memory'] as vlm.FixedLengthMapOfLists)
                .map['Memory Used']!
                .list,
            test.isNotEmpty,
          );

          test.expect(
            (((await builder.quickLookHistory(window: _window)).map['Totals']!
                        as vlm.FixedLengthMapOfMapOfLists)
                    .map['Memory'] as vlm.FixedLengthMapOfLists)
                .map['Memory Swap Used']!
                .list,
            test.isNotEmpty,
          );

          test.expect(
            (((await builder.quickLookHistory(window: _window)).map['All CPUs']!
                        as vlm.FixedLengthMapOfMapOfLists)
                    .map['Core 0']! as vlm.FixedLengthMapOfLists)
                .map['Total']!
                .list,
            test.isNotEmpty,
          );

          test.expect(
            (((await builder.quickLookHistory(window: _window)).map['All CPUs']!
                        as vlm.FixedLengthMapOfMapOfLists)
                    .map['Core 0']! as vlm.FixedLengthMapOfLists)
                .map['User']!
                .list,
            test.isNotEmpty,
          );

          test.expect(
            (((await builder.quickLookHistory(window: _window)).map['All CPUs']!
                        as vlm.FixedLengthMapOfMapOfLists)
                    .map['Core 0']! as vlm.FixedLengthMapOfLists)
                .map['System']!
                .list,
            test.isNotEmpty,
          );

          test.expect(
            (((await builder.quickLookHistory(window: _window)).map['All CPUs']!
                        as vlm.FixedLengthMapOfMapOfLists)
                    .map['Core 0']! as vlm.FixedLengthMapOfLists)
                .map['Idle']!
                .list,
            test.isNotEmpty,
          );

          test.expect(
            (((await builder.quickLookHistory(window: _window)).map['All CPUs']!
                        as vlm.FixedLengthMapOfMapOfLists)
                    .map['Core 0']! as vlm.FixedLengthMapOfLists)
                .map['Nice']!
                .list,
            test.isNotEmpty,
          );

          test.expect(
            (((await builder.quickLookHistory(window: _window)).map['All CPUs']!
                        as vlm.FixedLengthMapOfMapOfLists)
                    .map['Core 0']! as vlm.FixedLengthMapOfLists)
                .map['IO Wait']!
                .list,
            test.isNotEmpty,
          );

          test.expect(
            (((await builder.quickLookHistory(window: _window)).map['All CPUs']!
                        as vlm.FixedLengthMapOfMapOfLists)
                    .map['Core 0']! as vlm.FixedLengthMapOfLists)
                .map['IRQ']!
                .list,
            test.isNotEmpty,
          );

          test.expect(
            (((await builder.quickLookHistory(window: _window)).map['All CPUs']!
                        as vlm.FixedLengthMapOfMapOfLists)
                    .map['Core 0']! as vlm.FixedLengthMapOfLists)
                .map['Soft IRQ']!
                .list,
            test.isNotEmpty,
          );

          test.expect(
            (((await builder.quickLookHistory(window: _window)).map['All CPUs']!
                        as vlm.FixedLengthMapOfMapOfLists)
                    .map['Core 0']! as vlm.FixedLengthMapOfLists)
                .map['Steal']!
                .list,
            test.isNotEmpty,
          );

          test.expect(
            (((await builder.quickLookHistory(window: _window)).map['All CPUs']!
                        as vlm.FixedLengthMapOfMapOfLists)
                    .map['Core 0']! as vlm.FixedLengthMapOfLists)
                .map['Guest']!
                .list,
            test.isNotEmpty,
          );

          test.expect(
            (((await builder.quickLookHistory(window: _window)).map['All CPUs']!
                        as vlm.FixedLengthMapOfMapOfLists)
                    .map['Core 0']! as vlm.FixedLengthMapOfLists)
                .map['Guest Nice']!
                .list,
            test.isNotEmpty,
          );
        },
      );
    },
  );

  test.group(
    'sensorMap',
    () {
      test.test(
        'is a MapOfLists',
        () async {
          test.expect(
            await builder.sensorMap(
              window: _window,
            ),
            test.isA<vlm.MapOfLists>(),
          );
        },
      );

      test.test(
        'has non-empty keys',
        () async {
          _setup(
            builder.sensorMap,
          );

          for (final key in (await builder.sensorMap(
            window: _window,
          ))
              .map
              .keys) {
            test.expect(
              ((await builder.sensorMap(window: _window)).map[key]
                      as vlm.ListOfValues)
                  .list,
              test.isNotEmpty,
            );
          }
        },
      );
    },
  );
}
