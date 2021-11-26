import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';

import 'model.dart';

part 'serializers.g.dart';

@SerializersFor([
  PluginsList,
  Cpu,
  CpuHistoryValue,
  CpuHistory,
  PerCpu,
  PerCpuHistoryValue,
  PerCpuHistory,
  PerCpuList,
  Core,
  DiskIo,
  DiskIoList,
  DiskIoHistoryValue,
  DiskIoHistory,
  FileSystem,
  FileSystemList,
  FileSystemHistoryValue,
  FileSystemHistory,
  InternetProtocol,
  CpuLoad,
  CpuLoadHistoryValue,
  CpuLoadHistory,
  Memory,
  MemoryHistoryValue,
  MemoryHistory,
  MemorySwap,
  MemorySwapHistoryValue,
  MemorySwapHistory,
  NetworkInterface,
  NetworkInterfaceList,
  NetworkHistoryValue,
  NetworkHistory,
  ProcessCount,
  ProcessCountHistoryValue,
  ProcessCountHistory,
  Process,
  ProcessList,
  QuickLook,
  QuickLookHistoryValue,
  QuickLookHistory,
  Sensor,
  SensorList,
  System,
])
final Serializers serializers = _$serializers;

final Serializers standardSerializers = (serializers.toBuilder()
      ..addBuilderFactory(
        const FullType(TimeStamp, [FullType(num)]),
        () => TimeStampBuilder<num>(),
      )
      ..addBuilderFactory(
        const FullType(TimeStamp, [FullType(double)]),
        () => TimeStampBuilder<double>(),
      )
      ..addBuilderFactory(
        const FullType(TimeStamp, [FullType(int)]),
        () => TimeStampBuilder<int>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [
          FullType(TimeStamp, [
            FullType(double),
          ]),
        ]),
        () => ListBuilder<TimeStampBuilder<double>>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [
          FullType(TimeStamp, [
            FullType(int),
          ]),
        ]),
        () => ListBuilder<TimeStampBuilder<int>>(),
      )
      ..addBuilderFactory(
        const FullType(
          BuiltMap,
          [
            FullType(String),
            FullType(
              BuiltList,
              [
                FullType(
                  BuiltList,
                  [
                    FullType(JsonObject),
                  ],
                ),
              ],
            ),
          ],
        ),
        () => MapBuilder<String, BuiltList<BuiltList<JsonObject>>>(),
      )
      ..addBuilderFactory(
        const FullType(
          BuiltList,
          [
            FullType(JsonObject),
          ],
        ),
        () => ListBuilder<JsonObject>(),
      )
      ..addPlugin(StandardJsonPlugin()))
    .build();
