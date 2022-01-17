import 'dart:io' as io;

import 'package:test/test.dart' as test;
import 'package:glances_dashboard/src/model.dart' as model;
import 'package:glances_dashboard/src/serializers.dart' as serializers;

import 'package:glances_dashboard/src/client.dart' as glances_client;
import 'package:glances_dashboard/src/mock_client.dart' as mock_client;

void main() {
  final client = mock_client.MockClient();

  test.group(
    'Now',
    () {
      test.test(
        'fromQuoted() removes quotes',
        () async {
          test.expect(
            !(await client.now()).now.contains(
                  '"',
                ),
            test.isTrue,
          );
        },
      );

      test.test(
        'supports equality',
        () async {
          final now = await client.now();
          test.expect(
            now,
            test.equals(
              now,
            ),
          );
        },
      );
    },
  );

  test.group(
    'nowStream()',
    () {
      test.test(
        'can build a list that is non-empty',
        () async {
          final list = [];
          client.nowStream().listen(
            (
              now,
            ) {
              list.add(
                now,
              );
            },
          );
          await Future.delayed(
            const Duration(
              seconds: 2,
            ),
          );
          test.expect(
            list,
            test.isNotEmpty,
          );
        },
      );
    },
  );

  test.group(
    'UpTime',
    () {
      test.test(
        'fromQuoted() removes quotes',
        () async {
          test.expect(
            !(await client.upTime()).upTime.contains(
                  '"',
                ),
            test.isTrue,
          );
        },
      );

      test.test(
        'supports equality',
        () async {
          final upTime = await client.upTime();

          test.expect(
            upTime,
            test.equals(
              upTime,
            ),
          );
        },
      );
    },
  );

  test.group(
    'upTimeStream()',
    () {
      test.test(
        'can build a list that is non-empty',
        () async {
          final list = [];
          client.upTimeStream().listen(
            (
              now,
            ) {
              list.add(
                now,
              );
            },
          );
          await Future.delayed(
            const Duration(
              seconds: 2,
            ),
          );
          test.expect(
            list,
            test.isNotEmpty,
          );
        },
      );
    },
  );

  test.group(
    'PluginList',
    () {
      test.test(
        'deserializes and serializes',
        () async {
          test.expect(
            serializers.standardSerializers.serialize(
              await client.pluginsList(),
            )!,
            test.equals(
              {
                '\$': 'PluginList',
                'list': glances_client
                    .decodeJsonListFromString(
                      string: await io.File(
                        'test/json/plugins_list.json',
                      ).readAsString(),
                    )
                    .map(
                      (
                        s,
                      ) =>
                          {
                        'value': s,
                      },
                    )
                    .toList(),
              },
            ),
          );
        },
      );
    },
  );

  test.group(
    'Cores',
    () {
      test.test(
        'deserializes and serializes',
        () async {
          test.expect(
            serializers.standardSerializers.serialize(
              await client.cores(),
            )!,
            test.equals(
              glances_client.decodeJsonMapFromString(
                string: await io.File(
                  'test/json/cores.json',
                ).readAsString(),
              )..addAll(
                  {
                    '\$': 'Cores',
                  },
                ),
            ),
          );
        },
      );
    },
  );

  test.group(
    'Cpu',
    () {
      test.test(
        'deserializes and serializes',
        () async {
          test.expect(
            serializers.standardSerializers.serialize(
              (await client.cpu()).model,
            )!,
            test.equals(
              glances_client.decodeJsonMapFromString(
                string: await io.File(
                  'test/json/cpu.json',
                ).readAsString(),
              )..addAll(
                  {
                    '\$': 'Cpu',
                  },
                ),
            ),
          );
        },
      );
    },
  );

  test.group(
    'CpuHistoryValue',
    () {
      test.test(
        'deserializes and serializes',
        () async {
          final map = glances_client.decodeJsonMapFromString(
            string: await io.File(
              'test/json/cpu_history.json',
            ).readAsString(),
          );
          test.expect(
            serializers.standardSerializers.serialize(
              serializers.standardSerializers.deserializeWith(
                model.CpuHistoryValue.serializer,
                map,
              )!,
            )!,
            test.equals(
              map
                ..addAll(
                  {
                    '\$': 'CpuHistoryValue',
                  },
                ),
            ),
          );
        },
      );
    },
  );

  test.group(
    'CpuHistory',
    () {
      test.test(
        'serializes',
        () async {
          test.expect(
            serializers.standardSerializers.serialize(
              await client.cpuHistory(),
            )!,
            test.equals(
              glances_client.decodeJsonMapFromString(
                string: await io.File(
                  'test/json/cpu_history_output.json',
                ).readAsString(),
              ),
            ),
          );
        },
      );
    },
  );

  test.group(
    'AllCpuList',
    () {
      test.test(
        'deserializes and serializes',
        () async {
          test.expect(
            serializers.standardSerializers.serialize(
              (await client.allCpus()).model,
            )!,
            test.equals(
              {
                '\$': 'AllCpusList',
                'list': glances_client.decodeJsonListFromString(
                  string: await io.File(
                    'test/json/all_cpus.json',
                  ).readAsString(),
                ),
              },
            ),
          );
        },
      );
    },
  );

  test.group(
    'AllCpusHistoryValue',
    () {
      test.test(
        'deserializes',
        () async {
          final map = glances_client.decodeJsonMapFromString(
            string: await io.File(
              'test/json/all_cpus_history.json',
            ).readAsString(),
          );
          test.expect(
            serializers.standardSerializers.serializeWith(
              model.AllCpusHistoryValue.serializer,
              model.AllCpusHistoryValue.fromJson(
                map: map,
              ),
            )!,
            test.equals(
              {
                'history': map,
              },
            ),
          );
        },
      );
    },
  );

  test.group(
    'AllCpusHistory',
    () {
      test.test(
        'serializes',
        () async {
          test.expect(
            serializers.standardSerializers.serialize(
              await client.allCpusHistory(),
            )!,
            test.equals(
              glances_client.decodeJsonMapFromString(
                string: await io.File(
                  'test/json/all_cpus_history_output.json',
                ).readAsString(),
              ),
            ),
          );
        },
      );
    },
  );

  test.group(
    'CpuLoad',
    () {
      test.test(
        'deserializes and serializes',
        () async {
          test.expect(
            serializers.standardSerializers.serialize(
              (await client.cpuLoad()).model,
            )!,
            test.equals(
              glances_client.decodeJsonMapFromString(
                string: await io.File(
                  'test/json/cpu_load.json',
                ).readAsString(),
              )..addAll(
                  {
                    '\$': 'CpuLoad',
                  },
                ),
            ),
          );
        },
      );
    },
  );

  test.group(
    'CpuLoadHistoryValue',
    () {
      test.test(
        'deserializes and serializes',
        () async {
          final map = glances_client.decodeJsonMapFromString(
            string: await io.File(
              'test/json/cpu_load_history.json',
            ).readAsString(),
          );
          test.expect(
            serializers.standardSerializers.serialize(
              serializers.standardSerializers.deserializeWith(
                model.CpuLoadHistoryValue.serializer,
                map,
              )!,
            )!,
            test.equals(
              map
                ..addAll(
                  {
                    '\$': 'CpuLoadHistoryValue',
                  },
                ),
            ),
          );
        },
      );
    },
  );

  test.group(
    'CpuLoadHistory',
    () {
      test.test(
        'serializes',
        () async {
          test.expect(
            serializers.standardSerializers.serialize(
              await client.cpuLoadHistory(),
            )!,
            test.equals(
              glances_client.decodeJsonMapFromString(
                string: await io.File(
                  'test/json/cpu_load_history_output.json',
                ).readAsString(),
              ),
            ),
          );
        },
      );
    },
  );

  test.group(
    'DiskIoList',
    () {
      test.test(
        'deserializes and serializes',
        () async {
          test.expect(
            serializers.standardSerializers.serialize(
              (await client.diskIo()).model,
            )!,
            test.equals(
              {
                '\$': 'DiskIoList',
                'list': glances_client.decodeJsonListFromString(
                  string: await io.File(
                    'test/json/disk_io.json',
                  ).readAsString(),
                ),
              },
            ),
          );
        },
      );
    },
  );

  test.group(
    'DiskIoHistoryValue',
    () {
      test.test(
        'deserializes and serializes',
        () async {
          final map = glances_client.decodeJsonMapFromString(
            string: await io.File(
              'test/json/disk_io_history.json',
            ).readAsString(),
          );
          test.expect(
            serializers.standardSerializers.serializeWith(
              model.DiskIoHistoryValue.serializer,
              model.DiskIoHistoryValue.fromJson(
                map: map,
              ),
            )!,
            test.equals(
              {
                'history': map,
              },
            ),
          );
        },
      );
    },
  );

  test.group(
    'DiskIoHistory',
    () {
      test.test(
        'serializes',
        () async {
          test.expect(
            serializers.standardSerializers.serialize(
              await client.diskIoHistory(),
            )!,
            test.equals(
              glances_client.decodeJsonMapFromString(
                string: await io.File(
                  'test/json/disk_io_history_output.json',
                ).readAsString(),
              ),
            ),
          );
        },
      );
    },
  );

  test.group(
    'FileSystemList',
    () {
      test.test(
        'deserializes and serializes',
        () async {
          test.expect(
            serializers.standardSerializers.serialize(
              (await client.fileSystem()).model,
            )!,
            test.equals(
              {
                '\$': 'FileSystemList',
                'list': glances_client.decodeJsonListFromString(
                  string: await io.File(
                    'test/json/file_system.json',
                  ).readAsString(),
                ),
              },
            ),
          );
        },
      );
    },
  );

  test.group(
    'FileSystemHistoryValue',
    () {
      test.test(
        'deserializes and serializes',
        () async {
          final map = glances_client.decodeJsonMapFromString(
            string: await io.File(
              'test/json/file_system_history.json',
            ).readAsString(),
          );
          test.expect(
            serializers.standardSerializers.serializeWith(
              model.FileSystemHistoryValue.serializer,
              model.FileSystemHistoryValue.fromJson(
                map: map,
              ),
            )!,
            test.equals(
              {
                'history': map,
              },
            ),
          );
        },
      );
    },
  );

  test.group(
    'FileSystemHistory',
    () {
      test.test(
        'serializes',
        () async {
          test.expect(
            serializers.standardSerializers.serialize(
              await client.fileSystemHistory(),
            )!,
            test.equals(
              glances_client.decodeJsonMapFromString(
                string: await io.File(
                  'test/json/file_system_history_output.json',
                ).readAsString(),
              ),
            ),
          );
        },
      );
    },
  );

  test.group(
    'InternetProtocol',
    () {
      test.test(
        'deserializes and serializes',
        () async {
          test.expect(
            serializers.standardSerializers.serialize(
              await client.internetProtocol(),
            )!,
            test.equals(
              glances_client.decodeJsonMapFromString(
                  string: await io.File(
                'test/json/internet_protocol.json',
              ).readAsString())
                ..addAll(
                  {
                    '\$': 'InternetProtocol',
                  },
                ),
            ),
          );
        },
      );
    },
  );

  test.group(
    'Memory',
    () {
      test.test(
        'deserializes and serializes',
        () async {
          test.expect(
            serializers.standardSerializers.serialize(
              (await client.memory()).model,
            )!,
            test.equals(
              glances_client.decodeJsonMapFromString(
                string: await io.File(
                  'test/json/memory.json',
                ).readAsString(),
              )..addAll(
                  {
                    '\$': 'Memory',
                  },
                ),
            ),
          );
        },
      );
    },
  );

  test.group(
    'MemoryHistoryValue',
    () {
      test.test(
        'deserializes and serializes',
        () async {
          final map = glances_client.decodeJsonMapFromString(
            string: await io.File(
              'test/json/memory_history.json',
            ).readAsString(),
          );
          test.expect(
            serializers.standardSerializers.serialize(
              serializers.standardSerializers.deserializeWith(
                model.MemoryHistoryValue.serializer,
                map,
              )!,
            )!,
            test.equals(
              map
                ..addAll(
                  {
                    '\$': 'MemoryHistoryValue',
                  },
                ),
            ),
          );
        },
      );
    },
  );

  test.group(
    'MemoryHistory',
    () {
      test.test(
        'serializes',
        () async {
          test.expect(
            serializers.standardSerializers.serialize(
              await client.memoryHistory(),
            )!,
            test.equals(
              glances_client.decodeJsonMapFromString(
                string: await io.File(
                  'test/json/memory_history_output.json',
                ).readAsString(),
              ),
            ),
          );
        },
      );
    },
  );

  test.group(
    'MemorySwap',
    () {
      test.test(
        'deserializes and serializes',
        () async {
          test.expect(
            serializers.standardSerializers.serialize(
              (await client.memorySwap()).model,
            )!,
            test.equals(
              glances_client.decodeJsonMapFromString(
                string: await io.File(
                  'test/json/memory_swap.json',
                ).readAsString(),
              )..addAll(
                  {
                    '\$': 'MemorySwap',
                  },
                ),
            ),
          );
        },
      );
    },
  );

  test.group(
    'MemorySwapHistoryValue',
    () {
      test.test(
        'deserializes and serializes',
        () async {
          final map = glances_client.decodeJsonMapFromString(
            string: await io.File(
              'test/json/memory_swap_history.json',
            ).readAsString(),
          );
          test.expect(
            serializers.standardSerializers.serialize(
              serializers.standardSerializers.deserializeWith(
                model.MemorySwapHistoryValue.serializer,
                map,
              )!,
            )!,
            test.equals(
              map
                ..addAll(
                  {
                    '\$': 'MemorySwapHistoryValue',
                  },
                ),
            ),
          );
        },
      );
    },
  );

  test.group(
    'MemorySwapHistory',
    () {
      test.test(
        'serializes',
        () async {
          test.expect(
            serializers.standardSerializers.serialize(
              await client.memorySwapHistory(),
            )!,
            test.equals(
              glances_client.decodeJsonMapFromString(
                string: await io.File(
                  'test/json/memory_swap_history_output.json',
                ).readAsString(),
              ),
            ),
          );
        },
      );
    },
  );

  test.group(
    'NetworkInterfaceList',
    () {
      test.test(
        'deserializes and serializes',
        () async {
          test.expect(
            serializers.standardSerializers.serialize(
              (await client.networkInterface()).model,
            )!,
            test.equals(
              {
                '\$': 'NetworkInterfaceList',
                'list': glances_client
                    .decodeJsonListFromString(
                  string: await io.File(
                    'test/json/network_interface.json',
                  ).readAsString(),
                )
                    .map(
                  (
                    map,
                  ) {
                    map.remove(
                      'alias',
                    );
                    return map;
                  },
                ).toList(),
              },
            ),
          );
        },
      );
    },
  );

  test.group(
    'NetworkHistoryValue',
    () {
      test.test(
        'deserializes and serializes',
        () async {
          final map = glances_client.decodeJsonMapFromString(
            string: await io.File(
              'test/json/network_history.json',
            ).readAsString(),
          );
          test.expect(
            serializers.standardSerializers.serializeWith(
              model.NetworkHistoryValue.serializer,
              model.NetworkHistoryValue.fromJson(
                map: map,
              ),
            )!,
            test.equals(
              {
                'history': map,
              },
            ),
          );
        },
      );
    },
  );

  test.group(
    'NetworkHistory',
    () {
      test.test(
        'serializes',
        () async {
          test.expect(
            serializers.standardSerializers.serialize(
              await client.networkHistory(),
            )!,
            test.equals(
              glances_client.decodeJsonMapFromString(
                string: await io.File(
                  'test/json/network_history_output.json',
                ).readAsString(),
              ),
            ),
          );
        },
      );
    },
  );

  test.group(
    'ProcessCount',
    () {
      test.test(
        'deserializes and serializes',
        () async {
          test.expect(
            serializers.standardSerializers.serialize(
              (await client.processCount()).model,
            )!,
            test.equals(
              glances_client.decodeJsonMapFromString(
                string: await io.File(
                  'test/json/process_count.json',
                ).readAsString(),
              )..addAll(
                  {
                    '\$': 'ProcessCount',
                  },
                ),
            ),
          );
        },
      );
    },
  );

  test.group(
    'ProcessCountHistoryValue',
    () {
      test.test(
        'deserializes and serializes',
        () async {
          final map = glances_client.decodeJsonMapFromString(
            string: await io.File(
              'test/json/process_count_history.json',
            ).readAsString(),
          );
          test.expect(
            serializers.standardSerializers.serialize(
              serializers.standardSerializers.deserializeWith(
                model.ProcessCountHistoryValue.serializer,
                map,
              )!,
            )!,
            test.equals(
              map
                ..addAll(
                  {
                    '\$': 'ProcessCountHistoryValue',
                  },
                ),
            ),
          );
        },
      );
    },
  );

  test.group(
    'ProcessCountHistory',
    () {
      test.test(
        'serializes',
        () async {
          test.expect(
            serializers.standardSerializers.serialize(
              await client.processCountHistory(),
            )!,
            test.equals(
              glances_client.decodeJsonMapFromString(
                string: await io.File(
                  'test/json/process_count_history_output.json',
                ).readAsString(),
              ),
            ),
          );
        },
      );
    },
  );

  test.group(
    'ProcessList',
    () {
      test.test(
        'deserializes and serializes',
        () async {
          test.expect(
            serializers.standardSerializers.serialize(
              (await client.processList()).model,
            )!,
            test.equals(
              {
                '\$': 'ProcessList',
                'list': glances_client.decodeJsonListFromString(
                  string: await io.File(
                    'test/json/process_list.json',
                  ).readAsString(),
                ),
              },
            ),
          );
        },
      );
    },
  );

  test.group(
    'QuickLook',
    () {
      test.test(
        'deserializes and serializes',
        () async {
          test.expect(
            serializers.standardSerializers.serialize(
              (await client.quickLook()).model,
            )!,
            test.equals(
              glances_client.decodeJsonMapFromString(
                string: await io.File(
                  'test/json/quick_look.json',
                ).readAsString(),
              )..addAll(
                  {
                    '\$': 'QuickLook',
                  },
                ),
            ),
          );
        },
      );
    },
  );

  test.group(
    'QuickLookHistoryValue',
    () {
      test.test(
        'deserializes and serializes',
        () async {
          final map = glances_client.decodeJsonMapFromString(
            string: await io.File(
              'test/json/quick_look_history.json',
            ).readAsString(),
          );
          test.expect(
            serializers.standardSerializers.serialize(
              serializers.standardSerializers.deserializeWith(
                model.QuickLookHistoryValue.serializer,
                map,
              )!,
            )!,
            test.equals(
              map
                ..addAll(
                  {
                    '\$': 'QuickLookHistoryValue',
                  },
                ),
            ),
          );
        },
      );
    },
  );

  test.group(
    'QuickLookHistory',
    () {
      test.test(
        'serializes',
        () async {
          test.expect(
            serializers.standardSerializers.serialize(
              await client.quickLookHistory(),
            )!,
            test.equals(
              glances_client.decodeJsonMapFromString(
                string: await io.File(
                  'test/json/quick_look_history_output.json',
                ).readAsString(),
              ),
            ),
          );
        },
      );
    },
  );

  test.group(
    'SensorList',
    () {
      test.test(
        'deserializes and serializes',
        () async {
          test.expect(
            serializers.standardSerializers.serialize(
              (await client.sensors()).model,
            )!,
            test.equals(
              {
                '\$': 'SensorList',
                'list': glances_client
                    .decodeJsonListFromString(
                  string: await io.File(
                    'test/json/sensors.json',
                  ).readAsString(),
                )
                    .map(
                  (
                    sensor,
                  ) {
                    sensor.remove(
                      'warning',
                    );
                    sensor.remove(
                      'critical',
                    );
                    return sensor;
                  },
                ),
              },
            ),
          );
        },
      );
    },
  );

  test.group(
    'System',
    () {
      test.test(
        'deserializes and serializes',
        () async {
          test.expect(
            serializers.standardSerializers.serialize(
              await client.system(),
            )!,
            test.equals(
              glances_client.decodeJsonMapFromString(
                string: await io.File(
                  'test/json/system.json',
                ).readAsString(),
              )..addAll(
                  {
                    '\$': 'System',
                  },
                ),
            ),
          );
        },
      );
    },
  );
}
