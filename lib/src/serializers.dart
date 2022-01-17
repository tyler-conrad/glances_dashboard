import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';

import 'model.dart';
import 'value_list_map.dart';
import 'chart.dart';

part 'serializers.g.dart';

@SerializersFor([
  HistoryTimeStamp,
  TimeStamp,
  StreamIndex,
  Plugin,
  PluginList,
  Cpu,
  CpuHistoryValue,
  CpuHistory,
  AllCpus,
  AllCpusList,
  AllCpusHistoryValue,
  AllCpusHistory,
  Cores,
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
  Value,
  FileSystemHoverText,
  ListOfValues,
  MapOfLists,
  FixedLengthMapOfLists,
  MapOfMaps,
  FixedLengthMapOfMapOfLists,
  Window,
  PreviousNextPair,
])
final Serializers serializers = _$serializers;

final Serializers standardSerializers = (serializers.toBuilder()
      ..addBuilderFactory(
        const FullType(HistoryTimeStamp, [FullType(num)]),
        () => HistoryTimeStampBuilder<num>(),
      )
      ..addBuilderFactory(
        const FullType(HistoryTimeStamp, [FullType(double)]),
        () => HistoryTimeStampBuilder<double>(),
      )
      ..addBuilderFactory(
        const FullType(HistoryTimeStamp, [FullType(int)]),
        () => HistoryTimeStampBuilder<int>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [
          FullType(HistoryTimeStamp, [
            FullType(double),
          ]),
        ]),
        () => ListBuilder<HistoryTimeStampBuilder<double>>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [
          FullType(HistoryTimeStamp, [
            FullType(int),
          ]),
        ]),
        () => ListBuilder<HistoryTimeStampBuilder<int>>(),
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
