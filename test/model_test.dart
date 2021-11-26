import 'dart:convert' as convert;
import 'dart:io' as io;

import 'package:glances_dashboard/model.dart' as model;
import 'package:glances_dashboard/serializers.dart' as s;
import 'package:test/test.dart' as t;

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

void main() {
  t.group(
    'PluginsList',
    () {
      t.test(
        'deserializes and serializes',
        () async {
          var json =
              await io.File('test/json/plugins_list.json').readAsString();
          var list = decodeJsonListFromString(
            string: json,
          );
          t.expect(
            s.standardSerializers.serialize(
              model.PluginsList.fromJson(
                list: list,
              ),
            )!,
            t.equals(
              {
                '\$': 'PluginsList',
                'list': list,
              },
            ),
          );
        },
      );
    },
  );

  t.group(
    'Cpu',
    () {
      t.test(
        'deserializes and serializes',
        () async {
          var json = await io.File('test/json/cpu.json').readAsString();
          var map = decodeJsonMapFromString(
            string: json,
          );
          t.expect(
            s.standardSerializers.serialize(
              s.standardSerializers.deserializeWith(
                model.Cpu.serializer,
                map,
              )!,
            )!,
            t.equals(
              map
                ..addAll(
                  {'\$': 'Cpu'},
                ),
            ),
          );
        },
      );
    },
  );

  t.group(
    'CpuHistoryValue',
    () {
      t.test(
        'deserializes and serializes',
        () async {
          var json = await io.File('test/json/cpu_history.json').readAsString();
          var map = decodeJsonMapFromString(
            string: json,
          );
          t.expect(
            s.standardSerializers.serialize(
              s.standardSerializers.deserializeWith(
                model.CpuHistoryValue.serializer,
                map,
              )!,
            )!,
            t.equals(
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

  t.group(
    'CpuHistory',
    () {
      t.test(
        'serializes',
        () async {
          var json = await io.File('test/json/cpu_history.json').readAsString();
          var output =
              await io.File('test/json/cpu_history_output.json').readAsString();
          t.expect(
            s.standardSerializers.serialize(
              model.CpuHistory.fromCpuHistoryValue(
                value: s.standardSerializers.deserializeWith(
                  model.CpuHistoryValue.serializer,
                  decodeJsonMapFromString(
                    string: json,
                  ),
                )!,
              ),
            )!,
            t.equals(
              decodeJsonMapFromString(
                string: output,
              ),
            ),
          );
        },
      );
    },
  );

  t.group(
    'PerCpuList',
    () {
      t.test(
        'deserializes and serializes',
        () async {
          var json = await io.File('test/json/per_cpu.json').readAsString();
          var list = decodeJsonListFromString(
            string: json,
          );
          t.expect(
            s.standardSerializers.serialize(
              model.PerCpuList.fromJson(
                list: list,
              ),
            )!,
            t.equals(
              {
                '\$': 'PerCpuList',
                'list': list,
              },
            ),
          );
        },
      );
    },
  );

  t.group(
    'PerCpuHistoryValue',
    () {
      t.test(
        'deserializes',
        () async {
          var string =
              await io.File('test/json/per_cpu_history.json').readAsString();
          var map = decodeJsonMapFromString(string: string);
          t.expect(
            s.standardSerializers.serializeWith(
              model.PerCpuHistoryValue.serializer,
              model.PerCpuHistoryValue.fromJson(
                map: map,
              ),
            )!,
            t.equals(
              {
                'history': map,
              },
            ),
          );
        },
      );
    },
  );

  t.group(
    'PerCpuHistory',
    () {
      t.test(
        'serializes',
        () async {
          var json =
              await io.File('test/json/per_cpu_history.json').readAsString();
          var output = await io.File('test/json/per_cpu_history_output.json')
              .readAsString();
          t.expect(
            s.standardSerializers.serialize(
              model.PerCpuHistory.fromPerCpuHistoryValue(
                value: model.PerCpuHistoryValue.fromJson(
                  map: decodeJsonMapFromString(
                    string: json,
                  ),
                ),
              ),
            )!,
            t.equals(
              decodeJsonMapFromString(
                string: output,
              ),
            ),
          );
        },
      );
    },
  );

  t.group(
    'Core',
    () {
      t.test(
        'deserializes and serializes',
        () async {
          var json = await io.File('test/json/core.json').readAsString();
          var map = decodeJsonMapFromString(
            string: json,
          );
          t.expect(
            s.standardSerializers.serialize(
              s.standardSerializers.deserializeWith(
                model.Core.serializer,
                map,
              )!,
            )!,
            t.equals(
              map
                ..addAll(
                  {'\$': 'Core'},
                ),
            ),
          );
        },
      );
    },
  );

  t.group(
    'DiskIoList',
    () {
      t.test(
        'deserializes and serializes',
        () async {
          var json = await io.File('test/json/disk_io.json').readAsString();
          var list = decodeJsonListFromString(
            string: json,
          );
          t.expect(
            s.standardSerializers.serialize(
              model.DiskIoList.fromJson(
                list: list,
              ),
            )!,
            t.equals(
              {
                '\$': 'DiskIoList',
                'list': list,
              },
            ),
          );
        },
      );
    },
  );

  t.group(
    'DiskIoHistoryValue',
    () {
      t.test(
        'deserializes and serializes',
        () async {
          var string =
              await io.File('test/json/disk_io_history.json').readAsString();
          var map = decodeJsonMapFromString(string: string);
          t.expect(
            s.standardSerializers.serializeWith(
              model.DiskIoHistoryValue.serializer,
              model.DiskIoHistoryValue.fromJson(
                map: map,
              ),
            )!,
            t.equals(
              {
                'history': map,
              },
            ),
          );
        },
      );
    },
  );

  t.group(
    'DiskIoHistory',
    () {
      t.test(
        'serializes',
        () async {
          var json =
              await io.File('test/json/disk_io_history.json').readAsString();
          var output = await io.File('test/json/disk_io_history_output.json')
              .readAsString();
          t.expect(
            s.standardSerializers.serialize(
              model.DiskIoHistory.fromDiskIoHistoryValue(
                value: model.DiskIoHistoryValue.fromJson(
                  map: decodeJsonMapFromString(
                    string: json,
                  ),
                ),
              ),
            )!,
            t.equals(
              decodeJsonMapFromString(
                string: output,
              ),
            ),
          );
        },
      );
    },
  );

  t.group(
    'FileSystemList',
    () {
      t.test(
        'deserializes and serializes',
        () async {
          var json = await io.File('test/json/file_system.json').readAsString();
          var list = decodeJsonListFromString(
            string: json,
          );
          t.expect(
            s.standardSerializers.serialize(
              model.FileSystemList.fromJson(
                list: list,
              ),
            )!,
            t.equals(
              {
                '\$': 'FileSystemList',
                'list': list,
              },
            ),
          );
        },
      );
    },
  );

  t.group(
    'FileSystemHistoryValue',
    () {
      t.test(
        'deserializes and serializes',
        () async {
          var string = await io.File('test/json/file_system_history.json')
              .readAsString();
          var map = decodeJsonMapFromString(string: string);
          t.expect(
            s.standardSerializers.serializeWith(
              model.FileSystemHistoryValue.serializer,
              model.FileSystemHistoryValue.fromJson(
                map: map,
              ),
            )!,
            t.equals(
              {
                'history': map,
              },
            ),
          );
        },
      );
    },
  );

  t.group(
    'FileSystemHistory',
    () {
      t.test(
        'serializes',
        () async {
          var json = await io.File('test/json/file_system_history.json')
              .readAsString();
          var output =
              await io.File('test/json/file_system_history_output.json')
                  .readAsString();
          t.expect(
            s.standardSerializers.serialize(
              model.FileSystemHistory.fromFileSystemHistoryValue(
                value: model.FileSystemHistoryValue.fromJson(
                  map: decodeJsonMapFromString(
                    string: json,
                  ),
                ),
              ),
            )!,
            t.equals(
              decodeJsonMapFromString(
                string: output,
              ),
            ),
          );
        },
      );
    },
  );

  t.group(
    'InternetProtocol',
    () {
      t.test(
        'deserializes and serializes',
        () async {
          var json =
              await io.File('test/json/internet_protocol.json').readAsString();
          var map = decodeJsonMapFromString(
            string: json,
          );
          t.expect(
            s.standardSerializers.serialize(
              s.standardSerializers.deserializeWith(
                model.InternetProtocol.serializer,
                map,
              )!,
            )!,
            t.equals(
              map
                ..addAll(
                  {'\$': 'InternetProtocol'},
                ),
            ),
          );
        },
      );
    },
  );

  t.group(
    'CpuLoad',
    () {
      t.test(
        'deserializes and serializes',
        () async {
          var json = await io.File('test/json/cpu_load.json').readAsString();
          var map = decodeJsonMapFromString(
            string: json,
          );
          t.expect(
            s.standardSerializers.serialize(
              s.standardSerializers.deserializeWith(
                model.CpuLoad.serializer,
                map,
              )!,
            )!,
            t.equals(
              map
                ..addAll(
                  {'\$': 'CpuLoad'},
                ),
            ),
          );
        },
      );
    },
  );

  t.group(
    'CpuLoadHistoryValue',
    () {
      t.test(
        'deserializes and serializes',
        () async {
          var json =
              await io.File('test/json/cpu_load_history.json').readAsString();
          var map = decodeJsonMapFromString(
            string: json,
          );
          t.expect(
            s.standardSerializers.serialize(
              s.standardSerializers.deserializeWith(
                model.CpuLoadHistoryValue.serializer,
                map,
              )!,
            )!,
            t.equals(
              map
                ..addAll(
                  {'\$': 'CpuLoadHistoryValue'},
                ),
            ),
          );
        },
      );
    },
  );

  t.group(
    'CpuLoadHistory',
    () {
      t.test(
        'serializes',
        () async {
          var json =
              await io.File('test/json/cpu_load_history.json').readAsString();
          var output = await io.File('test/json/cpu_load_history_output.json')
              .readAsString();
          t.expect(
            s.standardSerializers.serialize(
              model.CpuLoadHistory.fromCpuLoadHistoryValue(
                value: s.standardSerializers.deserializeWith(
                  model.CpuLoadHistoryValue.serializer,
                  decodeJsonMapFromString(
                    string: json,
                  ),
                )!,
              ),
            )!,
            t.equals(
              decodeJsonMapFromString(
                string: output,
              ),
            ),
          );
        },
      );
    },
  );

  t.group(
    'Memory',
    () {
      t.test(
        'deserializes and serializes',
        () async {
          var json = await io.File('test/json/memory.json').readAsString();
          var map = decodeJsonMapFromString(
            string: json,
          );
          t.expect(
            s.standardSerializers.serialize(
              s.standardSerializers.deserializeWith(
                model.Memory.serializer,
                map,
              )!,
            )!,
            t.equals(
              map
                ..addAll(
                  {'\$': 'Memory'},
                ),
            ),
          );
        },
      );
    },
  );

  t.group(
    'MemoryHistoryValue',
    () {
      t.test(
        'deserializes and serializes',
        () async {
          var json =
              await io.File('test/json/memory_history.json').readAsString();
          var map = decodeJsonMapFromString(
            string: json,
          );
          t.expect(
            s.standardSerializers.serialize(
              s.standardSerializers.deserializeWith(
                model.MemoryHistoryValue.serializer,
                map,
              )!,
            )!,
            t.equals(
              map
                ..addAll(
                  {'\$': 'MemoryHistoryValue'},
                ),
            ),
          );
        },
      );
    },
  );

  t.group(
    'MemoryHistory',
    () {
      t.test(
        'serializes',
        () async {
          var json =
              await io.File('test/json/memory_history.json').readAsString();
          var output = await io.File('test/json/memory_history_output.json')
              .readAsString();
          t.expect(
            s.standardSerializers.serialize(
              model.MemoryHistory.fromMemoryHistoryValue(
                value: s.standardSerializers.deserializeWith(
                  model.MemoryHistoryValue.serializer,
                  decodeJsonMapFromString(
                    string: json,
                  ),
                )!,
              ),
            )!,
            t.equals(
              decodeJsonMapFromString(
                string: output,
              ),
            ),
          );
        },
      );
    },
  );

  t.group(
    'MemorySwap',
    () {
      t.test(
        'deserializes and serializes',
        () async {
          var json = await io.File('test/json/memory_swap.json').readAsString();
          var map = decodeJsonMapFromString(
            string: json,
          );
          t.expect(
            s.standardSerializers.serialize(
              s.standardSerializers.deserializeWith(
                model.MemorySwap.serializer,
                map,
              )!,
            )!,
            t.equals(
              map
                ..addAll(
                  {'\$': 'MemorySwap'},
                ),
            ),
          );
        },
      );
    },
  );

  t.group(
    'MemorySwapHistoryValue',
    () {
      t.test(
        'deserializes and serializes',
        () async {
          var json = await io.File('test/json/memory_swap_history.json')
              .readAsString();
          var map = decodeJsonMapFromString(
            string: json,
          );
          t.expect(
            s.standardSerializers.serialize(
              s.standardSerializers.deserializeWith(
                model.MemorySwapHistoryValue.serializer,
                map,
              )!,
            )!,
            t.equals(
              map
                ..addAll(
                  {'\$': 'MemorySwapHistoryValue'},
                ),
            ),
          );
        },
      );
    },
  );

  t.group(
    'MemorySwapHistory',
    () {
      t.test(
        'serializes',
        () async {
          var json = await io.File('test/json/memory_swap_history.json')
              .readAsString();
          var output =
              await io.File('test/json/memory_swap_history_output.json')
                  .readAsString();
          t.expect(
            s.standardSerializers.serialize(
              model.MemorySwapHistory.fromMemorySwapHistoryValue(
                value: s.standardSerializers.deserializeWith(
                  model.MemorySwapHistoryValue.serializer,
                  decodeJsonMapFromString(
                    string: json,
                  ),
                )!,
              ),
            )!,
            t.equals(
              decodeJsonMapFromString(
                string: output,
              ),
            ),
          );
        },
      );
    },
  );

  t.group(
    'NetworkInterfaceList',
    () {
      t.test(
        'deserializes and serializes',
        () async {
          var json =
              await io.File('test/json/network_interface.json').readAsString();
          var list = decodeJsonListFromString(
            string: json,
          );
          t.expect(
            s.standardSerializers.serialize(
              model.NetworkInterfaceList.fromJson(
                list: list,
              ),
            )!,
            t.equals(
              {
                '\$': 'NetworkInterfaceList',
                'list': list.map(
                  (map) {
                    map.remove('alias');
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

  t.group(
    'NetworkHistoryValue',
    () {
      t.test(
        'deserializes and serializes',
        () async {
          var string =
              await io.File('test/json/network_history.json').readAsString();
          var map = decodeJsonMapFromString(string: string);
          t.expect(
            s.standardSerializers.serializeWith(
              model.NetworkHistoryValue.serializer,
              model.NetworkHistoryValue.fromJson(
                map: map,
              ),
            )!,
            t.equals(
              {
                'history': map,
              },
            ),
          );
        },
      );
    },
  );

  t.group(
    'NetworkHistory',
    () {
      t.test(
        'serializes',
        () async {
          var json =
              await io.File('test/json/network_history.json').readAsString();
          var output = await io.File('test/json/network_history_output.json')
              .readAsString();
          t.expect(
            s.standardSerializers.serialize(
              model.NetworkHistory.fromNetworkHistoryValue(
                value: model.NetworkHistoryValue.fromJson(
                  map: decodeJsonMapFromString(
                    string: json,
                  ),
                ),
              ),
            )!,
            t.equals(
              decodeJsonMapFromString(
                string: output,
              ),
            ),
          );
        },
      );
    },
  );

  t.group(
    'Now',
    () {
      t.test(
        'fromQuoted() removes quotes',
        () async {
          var string = await io.File('test/json/now.json').readAsString();
          t.expect(
              !model.Now.fromQuoted(quoted: string).now.contains(
                    '"',
                  ),
              t.isTrue);
        },
      );

      t.test(
        'supports equality',
        () async {
          var string = await io.File('test/json/now.json').readAsString();
          t.expect(
            model.Now.fromQuoted(quoted: string),
            t.equals(
              model.Now.fromQuoted(quoted: string),
            ),
          );
        },
      );
    },
  );

  t.group(
    'ProcessCount',
    () {
      t.test(
        'deserializes and serializes',
        () async {
          var json =
              await io.File('test/json/process_count.json').readAsString();
          var map = decodeJsonMapFromString(
            string: json,
          );
          t.expect(
            s.standardSerializers.serialize(
              s.standardSerializers.deserializeWith(
                model.ProcessCount.serializer,
                map,
              )!,
            )!,
            t.equals(
              map
                ..addAll(
                  {'\$': 'ProcessCount'},
                ),
            ),
          );
        },
      );
    },
  );

  t.group(
    'ProcessCountHistoryValue',
    () {
      t.test(
        'deserializes and serializes',
        () async {
          var json = await io.File('test/json/process_count_history.json')
              .readAsString();
          var map = decodeJsonMapFromString(
            string: json,
          );
          t.expect(
            s.standardSerializers.serialize(
              s.standardSerializers.deserializeWith(
                model.ProcessCountHistoryValue.serializer,
                map,
              )!,
            )!,
            t.equals(
              map
                ..addAll(
                  {'\$': 'ProcessCountHistoryValue'},
                ),
            ),
          );
        },
      );
    },
  );

  t.group(
    'ProcessCountHistory',
    () {
      t.test(
        'serializes',
        () async {
          var json = await io.File('test/json/process_count_history.json')
              .readAsString();
          var output =
              await io.File('test/json/process_count_history_output.json')
                  .readAsString();
          t.expect(
            s.standardSerializers.serialize(
              model.ProcessCountHistory.fromProcessCountHistoryValue(
                value: s.standardSerializers.deserializeWith(
                  model.ProcessCountHistoryValue.serializer,
                  decodeJsonMapFromString(
                    string: json,
                  ),
                )!,
              ),
            )!,
            t.equals(
              decodeJsonMapFromString(
                string: output,
              ),
            ),
          );
        },
      );
    },
  );

  t.group(
    'ProcessList',
    () {
      t.test(
        'deserializes and serializes',
        () async {
          var json =
              await io.File('test/json/process_list.json').readAsString();
          var list = decodeJsonListFromString(
            string: json,
          );
          t.expect(
            s.standardSerializers.serialize(
              model.ProcessList.fromJson(
                list: list,
              ),
            )!,
            t.equals(
              {
                '\$': 'ProcessList',
                'list': list,
              },
            ),
          );
        },
      );
    },
  );

  t.group(
    'QuickLook',
    () {
      t.test(
        'deserializes and serializes',
        () async {
          var json = await io.File('test/json/quick_look.json').readAsString();
          var map = decodeJsonMapFromString(
            string: json,
          );
          t.expect(
            s.standardSerializers.serialize(
              s.standardSerializers.deserializeWith(
                model.QuickLook.serializer,
                map,
              )!,
            )!,
            t.equals(
              map
                ..addAll(
                  {'\$': 'QuickLook'},
                ),
            ),
          );
        },
      );
    },
  );

  t.group(
    'QuickLookHistoryValue',
    () {
      t.test(
        'deserializes and serializes',
        () async {
          var json =
              await io.File('test/json/quick_look_history.json').readAsString();
          var map = decodeJsonMapFromString(
            string: json,
          );
          t.expect(
            s.standardSerializers.serialize(
              s.standardSerializers.deserializeWith(
                model.QuickLookHistoryValue.serializer,
                map,
              )!,
            )!,
            t.equals(
              map
                ..addAll(
                  {'\$': 'QuickLookHistoryValue'},
                ),
            ),
          );
        },
      );
    },
  );

  t.group(
    'QuickLookHistory',
    () {
      t.test(
        'serializes',
        () async {
          var json =
              await io.File('test/json/quick_look_history.json').readAsString();
          var output = await io.File('test/json/quick_look_history_output.json')
              .readAsString();
          t.expect(
            s.standardSerializers.serialize(
              model.QuickLookHistory.fromQuickLookHistoryValue(
                value: s.standardSerializers.deserializeWith(
                  model.QuickLookHistoryValue.serializer,
                  decodeJsonMapFromString(
                    string: json,
                  ),
                )!,
              ),
            )!,
            t.equals(
              decodeJsonMapFromString(
                string: output,
              ),
            ),
          );
        },
      );
    },
  );

  t.group(
    'SensorList',
    () {
      t.test(
        'deserializes and serializes',
        () async {
          var json = await io.File('test/json/sensors.json').readAsString();
          var list = decodeJsonListFromString(
            string: json,
          );
          t.expect(
            s.standardSerializers.serialize(
              model.SensorList.fromJson(
                list: list,
              ),
            )!,
            t.equals(
              {
                '\$': 'SensorList',
                'list': list.map(
                  (sensor) {
                    sensor.remove('warning');
                    sensor.remove('critical');
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

  t.group(
    'System',
    () {
      t.test(
        'deserializes and serializes',
        () async {
          var json = await io.File('test/json/system.json').readAsString();
          var map = decodeJsonMapFromString(
            string: json,
          );
          t.expect(
            s.standardSerializers.serialize(
              s.standardSerializers.deserializeWith(
                model.System.serializer,
                map,
              )!,
            )!,
            t.equals(
              map
                ..addAll(
                  {'\$': 'System'},
                ),
            ),
          );
        },
      );
    },
  );

  t.group(
    'UpTime',
    () {
      t.test(
        'fromQuoted() removes quotes',
        () async {
          var string = await io.File('test/json/up_time.json').readAsString();
          t.expect(
              !model.UpTime.fromQuoted(quoted: string).now.contains(
                    '"',
                  ),
              t.isTrue);
        },
      );

      t.test(
        'supports equality',
        () async {
          var string = await io.File('test/json/up_time.json').readAsString();
          t.expect(
            model.UpTime.fromQuoted(quoted: string),
            t.equals(
              model.UpTime.fromQuoted(quoted: string),
            ),
          );
        },
      );
    },
  );
}
