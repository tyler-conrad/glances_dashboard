import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:glances_dashboard/serializers.dart';
import 'package:equatable/equatable.dart' as eq;

part 'model.g.dart';

abstract class TimeStamp<T extends num>
    implements Built<TimeStamp<T>, TimeStampBuilder<T>> {
  static Serializer<TimeStamp> get serializer => _$timeStampSerializer;

  DateTime get timeStamp;
  T get value;

  factory TimeStamp([
    Function(TimeStampBuilder<T>) updates,
  ]) = _$TimeStamp<T>;
  TimeStamp._();
}

ListBuilder<TimeStamp<T>> timeStampListBuilderFromJsonObjectList<T extends num>(
    {required BuiltList<BuiltList<JsonObject>> list}) {
  return list
      .map(
        (timeStamp) {
          return TimeStamp<T>(
            (b) => b
              ..timeStamp = DateTime.parse(timeStamp[0].asString).toUtc()
              ..value = timeStamp[1].asNum as T,
          );
        },
      )
      .toBuiltList()
      .toBuilder();
}

MapBuilder<String, BuiltList<BuiltList<JsonObject>>>
    timeStampJsonObjectMapBuilder({required Map<String, dynamic> map}) {
  return (standardSerializers.deserialize(
    map,
    specifiedType: const FullType(
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
  )! as BuiltMap<String, BuiltList<BuiltList<JsonObject>>>)
      .toBuilder();
}

MapBuilder<String, BuiltList<TimeStamp<T>>> timeStampMapper<T extends num>({
  required BuiltMap<String, BuiltList<BuiltList<JsonObject>>> map,
}) {
  return map
      .map<String, BuiltList<TimeStamp<T>>>(
        (
          key,
          list,
        ) =>
            MapEntry<String, BuiltList<TimeStamp<T>>>(
          key,
          timeStampListBuilderFromJsonObjectList<T>(
            list: list,
          ).build(),
        ),
      )
      .toBuilder();
}

abstract class PluginsList implements Built<PluginsList, PluginsListBuilder> {
  static Serializer<PluginsList> get serializer => _$pluginsListSerializer;

  BuiltList<String> get list;

  PluginsList._();
  factory PluginsList([
    void Function(PluginsListBuilder) updates,
  ]) = _$PluginsList;

  factory PluginsList.fromJson({
    required List<dynamic> list,
  }) {
    return PluginsList(
      (b) => b
        ..list = ListBuilder<String>(
          list,
        ),
    );
  }
}

abstract class Cpu implements Built<Cpu, CpuBuilder> {
  static Serializer<Cpu> get serializer => _$cpuSerializer;

  double get total;
  double get user;
  double get nice;
  double get system;
  double get idle;
  @BuiltValueField(
    wireName: 'iowait',
  )
  double get ioWait;
  double get irq;
  @BuiltValueField(
    wireName: 'softirq',
  )
  double get softIrq;
  double get steal;
  double get guest;
  @BuiltValueField(
    wireName: 'guest_nice',
  )
  double get guestNice;
  @BuiltValueField(
    wireName: 'time_since_update',
  )
  double get timeSinceUpdate;
  @BuiltValueField(
    wireName: 'cpucore',
  )
  int get cpuCore;
  @BuiltValueField(
    wireName: 'ctx_switches',
  )
  int get contextSwitches;
  int get interrupts;
  @BuiltValueField(
    wireName: 'soft_interrupts',
  )
  int get softInterrupts;
  @BuiltValueField(
    wireName: 'syscalls',
  )
  int get sysCalls;

  Cpu._();
  factory Cpu([
    void Function(CpuBuilder) updates,
  ]) = _$Cpu;
}

abstract class CpuHistoryValue
    implements Built<CpuHistoryValue, CpuHistoryValueBuilder> {
  static Serializer<CpuHistoryValue> get serializer =>
      _$cpuHistoryValueSerializer;

  BuiltList<BuiltList<JsonObject>> get user;
  BuiltList<BuiltList<JsonObject>> get system;

  CpuHistoryValue._();
  factory CpuHistoryValue([
    void Function(CpuHistoryValueBuilder) updates,
  ]) = _$CpuHistoryValue;
}

abstract class CpuHistory implements Built<CpuHistory, CpuHistoryBuilder> {
  static Serializer<CpuHistory> get serializer => _$cpuHistorySerializer;

  BuiltList<TimeStamp> get user;
  BuiltList<TimeStamp> get system;

  CpuHistory._();
  factory CpuHistory([
    void Function(CpuHistoryBuilder) updates,
  ]) = _$CpuHistory;

  factory CpuHistory.fromCpuHistoryValue({
    required CpuHistoryValue value,
  }) {
    return CpuHistory(
      (b) => b
        ..user = timeStampListBuilderFromJsonObjectList<double>(
          list: value.user,
        )
        ..system = timeStampListBuilderFromJsonObjectList<double>(
          list: value.system,
        ),
    );
  }
}

abstract class PerCpu implements Built<PerCpu, PerCpuBuilder> {
  static Serializer<PerCpu> get serializer => _$perCpuSerializer;

  String get key;
  @BuiltValueField(
    wireName: 'cpu_number',
  )
  int get cpuNumber;
  double get total;
  double get user;
  double get system;
  double get idle;
  double get nice;
  @BuiltValueField(
    wireName: 'iowait',
  )
  double get ioWait;
  double get irq;
  @BuiltValueField(
    wireName: 'softirq',
  )
  double get softIrq;
  double get steal;
  double get guest;
  @BuiltValueField(
    wireName: 'guest_nice',
  )
  double get guestNice;

  PerCpu._();
  factory PerCpu([
    void Function(PerCpuBuilder) updates,
  ]) = _$PerCpu;
}

abstract class PerCpuList implements Built<PerCpuList, PerCpuListBuilder> {
  static Serializer<PerCpuList> get serializer => _$perCpuListSerializer;

  BuiltList<PerCpu> get list;

  PerCpuList._();
  factory PerCpuList([
    void Function(PerCpuListBuilder) updates,
  ]) = _$PerCpuList;

  factory PerCpuList.fromJson({
    required List<dynamic> list,
  }) {
    return PerCpuList(
      (b) => b
        ..list = ListBuilder(
          list.map(
            (perCpu) => standardSerializers.deserializeWith(
              PerCpu.serializer,
              perCpu,
            )!,
          ),
        ),
    );
  }
}

abstract class PerCpuHistoryValue
    implements Built<PerCpuHistoryValue, PerCpuHistoryValueBuilder> {
  static Serializer<PerCpuHistoryValue> get serializer =>
      _$perCpuHistoryValueSerializer;

  BuiltMap<String, BuiltList<BuiltList<JsonObject>>> get history;

  PerCpuHistoryValue._();
  factory PerCpuHistoryValue([
    void Function(PerCpuHistoryValueBuilder) updates,
  ]) = _$PerCpuHistoryValue;

  factory PerCpuHistoryValue.fromJson({
    required Map<String, dynamic> map,
  }) {
    return PerCpuHistoryValue(
      (b) => b
        ..history = timeStampJsonObjectMapBuilder(
          map: map,
        ),
    );
  }
}

abstract class PerCpuHistory
    implements Built<PerCpuHistory, PerCpuHistoryBuilder> {
  static Serializer<PerCpuHistory> get serializer => _$perCpuHistorySerializer;

  BuiltMap<String, BuiltList<TimeStamp<double>>> get history;

  PerCpuHistory._();
  factory PerCpuHistory([
    void Function(PerCpuHistoryBuilder) updates,
  ]) = _$PerCpuHistory;

  factory PerCpuHistory.fromPerCpuHistoryValue({
    required PerCpuHistoryValue value,
  }) {
    return PerCpuHistory(
      (b) => b
        ..history = timeStampMapper<double>(
          map: value.history,
        ),
    );
  }
}

abstract class Core implements Built<Core, CoreBuilder> {
  static Serializer<Core> get serializer => _$coreSerializer;

  @BuiltValueField(
    wireName: 'phys',
  )
  int get physical;
  @BuiltValueField(
    wireName: 'log',
  )
  int get logical;

  Core._();
  factory Core([
    void Function(CoreBuilder) updates,
  ]) = _$Core;
}

abstract class DiskIo implements Built<DiskIo, DiskIoBuilder> {
  static Serializer<DiskIo> get serializer => _$diskIoSerializer;

  String get key;
  @BuiltValueField(
    wireName: 'time_since_update',
  )
  double get timeSinceUpdate;
  @BuiltValueField(
    wireName: 'disk_name',
  )
  String get diskName;
  @BuiltValueField(
    wireName: 'read_count',
  )
  int get readCount;
  @BuiltValueField(
    wireName: 'write_count',
  )
  int get writeCount;
  @BuiltValueField(
    wireName: 'read_bytes',
  )
  int get readBytes;
  @BuiltValueField(
    wireName: 'write_bytes',
  )
  int get writeBytes;

  DiskIo._();
  factory DiskIo([
    void Function(DiskIoBuilder) updates,
  ]) = _$DiskIo;
}

abstract class DiskIoList implements Built<DiskIoList, DiskIoListBuilder> {
  static Serializer<DiskIoList> get serializer => _$diskIoListSerializer;

  BuiltList<DiskIo> get list;

  DiskIoList._();
  factory DiskIoList([void Function(DiskIoListBuilder) updates]) = _$DiskIoList;

  factory DiskIoList.fromJson({
    required List<dynamic> list,
  }) {
    return DiskIoList(
      (b) => b
        ..list = ListBuilder(
          list.map(
            (diskIo) => standardSerializers.deserializeWith(
              DiskIo.serializer,
              diskIo,
            )!,
          ),
        ),
    );
  }
}

abstract class DiskIoHistoryValue
    implements Built<DiskIoHistoryValue, DiskIoHistoryValueBuilder> {
  static Serializer<DiskIoHistoryValue> get serializer =>
      _$diskIoHistoryValueSerializer;

  BuiltMap<String, BuiltList<BuiltList<JsonObject>>> get history;

  DiskIoHistoryValue._();
  factory DiskIoHistoryValue([
    void Function(DiskIoHistoryValueBuilder) updates,
  ]) = _$DiskIoHistoryValue;

  factory DiskIoHistoryValue.fromJson({
    required Map<String, dynamic> map,
  }) {
    return DiskIoHistoryValue(
      (b) => b
        ..history = timeStampJsonObjectMapBuilder(
          map: map,
        ),
    );
  }
}

abstract class DiskIoHistory
    implements Built<DiskIoHistory, DiskIoHistoryBuilder> {
  static Serializer<DiskIoHistory> get serializer => _$diskIoHistorySerializer;

  BuiltMap<String, BuiltList<TimeStamp<int>>> get history;

  DiskIoHistory._();
  factory DiskIoHistory([
    void Function(DiskIoHistoryBuilder) updates,
  ]) = _$DiskIoHistory;

  factory DiskIoHistory.fromDiskIoHistoryValue({
    required DiskIoHistoryValue value,
  }) {
    return DiskIoHistory(
      (b) => b
        ..history = timeStampMapper<int>(
          map: value.history,
        ),
    );
  }
}

abstract class FileSystem implements Built<FileSystem, FileSystemBuilder> {
  static Serializer<FileSystem> get serializer => _$fileSystemSerializer;

  String get key;
  @BuiltValueField(
    wireName: 'device_name',
  )
  String get deviceName;
  @BuiltValueField(
    wireName: 'fs_type',
  )
  String get type;
  @BuiltValueField(
    wireName: 'mnt_point',
  )
  String get mountPoint;
  int get size;
  int get used;
  int get free;
  double get percent;

  FileSystem._();
  factory FileSystem([
    void Function(FileSystemBuilder) updates,
  ]) = _$FileSystem;
}

abstract class FileSystemList
    implements Built<FileSystemList, FileSystemListBuilder> {
  static Serializer<FileSystemList> get serializer =>
      _$fileSystemListSerializer;

  BuiltList<FileSystem> get list;

  FileSystemList._();
  factory FileSystemList([
    void Function(FileSystemListBuilder) updates,
  ]) = _$FileSystemList;

  factory FileSystemList.fromJson({
    required List<dynamic> list,
  }) {
    return FileSystemList(
      (b) => b
        ..list = ListBuilder(
          list.map(
            (fileSystem) => standardSerializers.deserializeWith(
              FileSystem.serializer,
              fileSystem,
            )!,
          ),
        ),
    );
  }
}

abstract class FileSystemHistoryValue
    implements Built<FileSystemHistoryValue, FileSystemHistoryValueBuilder> {
  static Serializer<FileSystemHistoryValue> get serializer =>
      _$fileSystemHistoryValueSerializer;

  BuiltMap<String, BuiltList<BuiltList<JsonObject>>> get history;

  FileSystemHistoryValue._();
  factory FileSystemHistoryValue([
    void Function(FileSystemHistoryValueBuilder) updates,
  ]) = _$FileSystemHistoryValue;

  factory FileSystemHistoryValue.fromJson({
    required Map<String, dynamic> map,
  }) {
    return FileSystemHistoryValue(
      (b) => b
        ..history = timeStampJsonObjectMapBuilder(
          map: map,
        ),
    );
  }
}

abstract class FileSystemHistory
    implements Built<FileSystemHistory, FileSystemHistoryBuilder> {
  static Serializer<FileSystemHistory> get serializer =>
      _$fileSystemHistorySerializer;

  BuiltMap<String, BuiltList<TimeStamp<double>>> get history;

  FileSystemHistory._();
  factory FileSystemHistory([
    void Function(FileSystemHistoryBuilder) updates,
  ]) = _$FileSystemHistory;

  factory FileSystemHistory.fromFileSystemHistoryValue({
    required FileSystemHistoryValue value,
  }) {
    return FileSystemHistory(
      (b) => b
        ..history = timeStampMapper<double>(
          map: value.history,
        ),
    );
  }
}

abstract class InternetProtocol
    implements Built<InternetProtocol, InternetProtocolBuilder> {
  static Serializer<InternetProtocol> get serializer =>
      _$internetProtocolSerializer;

  String get address;
  String get mask;
  @BuiltValueField(
    wireName: 'mask_cidr',
  )
  int get maskCidr;
  String get gateway;

  InternetProtocol._();
  factory InternetProtocol([
    void Function(InternetProtocolBuilder) updates,
  ]) = _$InternetProtocol;
}

abstract class CpuLoad implements Built<CpuLoad, CpuLoadBuilder> {
  static Serializer<CpuLoad> get serializer => _$cpuLoadSerializer;

  double get min1;
  double get min5;
  double get min15;
  @BuiltValueField(
    wireName: 'cpucore',
  )
  int get cpuCoreCount;

  CpuLoad._();
  factory CpuLoad([
    void Function(CpuLoadBuilder) updates,
  ]) = _$CpuLoad;
}

abstract class CpuLoadHistoryValue
    implements Built<CpuLoadHistoryValue, CpuLoadHistoryValueBuilder> {
  static Serializer<CpuLoadHistoryValue> get serializer =>
      _$cpuLoadHistoryValueSerializer;

  BuiltList<BuiltList<JsonObject>> get min1;
  BuiltList<BuiltList<JsonObject>> get min5;
  BuiltList<BuiltList<JsonObject>> get min15;

  CpuLoadHistoryValue._();
  factory CpuLoadHistoryValue([
    void Function(CpuLoadHistoryValueBuilder) updates,
  ]) = _$CpuLoadHistoryValue;
}

abstract class CpuLoadHistory
    implements Built<CpuLoadHistory, CpuLoadHistoryBuilder> {
  static Serializer<CpuLoadHistory> get serializer =>
      _$cpuLoadHistorySerializer;

  BuiltList<TimeStamp<double>> get min1;
  BuiltList<TimeStamp<double>> get min5;
  BuiltList<TimeStamp<double>> get min15;

  CpuLoadHistory._();
  factory CpuLoadHistory([
    void Function(CpuLoadHistoryBuilder) updates,
  ]) = _$CpuLoadHistory;

  factory CpuLoadHistory.fromCpuLoadHistoryValue({
    required CpuLoadHistoryValue value,
  }) {
    return CpuLoadHistory(
      (b) => b
        ..min1 =
            timeStampListBuilderFromJsonObjectList<double>(list: value.min1)
        ..min5 =
            timeStampListBuilderFromJsonObjectList<double>(list: value.min5)
        ..min15 =
            timeStampListBuilderFromJsonObjectList<double>(list: value.min15),
    );
  }
}

abstract class Memory implements Built<Memory, MemoryBuilder> {
  static Serializer<Memory> get serializer => _$memorySerializer;

  int get total;
  int get available;
  double get percent;
  int get used;
  int get free;
  int get active;
  int get inactive;
  int get buffers;
  int get cached;
  int get shared;

  Memory._();
  factory Memory([
    void Function(MemoryBuilder) updates,
  ]) = _$Memory;
}

abstract class MemoryHistoryValue
    implements Built<MemoryHistoryValue, MemoryHistoryValueBuilder> {
  static Serializer<MemoryHistoryValue> get serializer =>
      _$memoryHistoryValueSerializer;

  BuiltList<BuiltList<JsonObject>> get percent;

  MemoryHistoryValue._();
  factory MemoryHistoryValue([
    void Function(MemoryHistoryValueBuilder) updates,
  ]) = _$MemoryHistoryValue;
}

abstract class MemoryHistory
    implements Built<MemoryHistory, MemoryHistoryBuilder> {
  static Serializer<MemoryHistory> get serializer => _$memoryHistorySerializer;

  BuiltList<TimeStamp<double>> get percent;

  MemoryHistory._();
  factory MemoryHistory([
    void Function(MemoryHistoryBuilder) updates,
  ]) = _$MemoryHistory;

  factory MemoryHistory.fromMemoryHistoryValue({
    required MemoryHistoryValue value,
  }) {
    return MemoryHistory(
      (b) => b
        ..percent =
            timeStampListBuilderFromJsonObjectList<double>(list: value.percent),
    );
  }
}

abstract class MemorySwap implements Built<MemorySwap, MemorySwapBuilder> {
  static Serializer<MemorySwap> get serializer => _$memorySwapSerializer;

  int get total;
  int get used;
  int get free;
  double get percent;
  int get sin;
  int get sout;
  @BuiltValueField(
    wireName: 'time_since_update',
  )
  double get timeSinceUpdate;

  MemorySwap._();
  factory MemorySwap([
    void Function(MemorySwapBuilder) updates,
  ]) = _$MemorySwap;
}

abstract class MemorySwapHistoryValue
    implements Built<MemorySwapHistoryValue, MemorySwapHistoryValueBuilder> {
  static Serializer<MemorySwapHistoryValue> get serializer =>
      _$memorySwapHistoryValueSerializer;

  BuiltList<BuiltList<JsonObject>> get percent;

  MemorySwapHistoryValue._();
  factory MemorySwapHistoryValue([
    void Function(MemorySwapHistoryValueBuilder) updates,
  ]) = _$MemorySwapHistoryValue;
}

abstract class MemorySwapHistory
    implements Built<MemorySwapHistory, MemorySwapHistoryBuilder> {
  static Serializer<MemorySwapHistory> get serializer =>
      _$memorySwapHistorySerializer;

  BuiltList<TimeStamp<double>> get percent;

  MemorySwapHistory._();
  factory MemorySwapHistory([
    void Function(MemorySwapHistoryBuilder) updates,
  ]) = _$MemorySwapHistory;

  factory MemorySwapHistory.fromMemorySwapHistoryValue({
    required MemorySwapHistoryValue value,
  }) {
    return MemorySwapHistory(
      (b) => b
        ..percent =
            timeStampListBuilderFromJsonObjectList<double>(list: value.percent),
    );
  }
}

abstract class NetworkInterface
    implements Built<NetworkInterface, NetworkInterfaceBuilder> {
  static Serializer<NetworkInterface> get serializer =>
      _$networkInterfaceSerializer;

  String get key;
  @BuiltValueField(
    wireName: 'interface_name',
  )
  String get name;
  String? get alias;
  @BuiltValueField(
    wireName: 'time_since_update',
  )
  double get timeSinceUpdate;
  @BuiltValueField(
    wireName: 'cumulative_rx',
  )
  int get cumulativeRx;
  int get rx;
  @BuiltValueField(
    wireName: 'cumulative_tx',
  )
  int get cumulativeTx;
  int get tx;
  @BuiltValueField(
    wireName: 'cumulative_cx',
  )
  int get cumulativeCx;
  int get cx;
  @BuiltValueField(
    wireName: 'is_up',
  )
  bool get isUp;
  int get speed;

  NetworkInterface._();
  factory NetworkInterface([
    void Function(NetworkInterfaceBuilder) updates,
  ]) = _$NetworkInterface;
}

abstract class NetworkInterfaceList
    implements Built<NetworkInterfaceList, NetworkInterfaceListBuilder> {
  static Serializer<NetworkInterfaceList> get serializer =>
      _$networkInterfaceListSerializer;

  BuiltList<NetworkInterface> get list;

  NetworkInterfaceList._();
  factory NetworkInterfaceList([
    void Function(NetworkInterfaceListBuilder) updates,
  ]) = _$NetworkInterfaceList;

  factory NetworkInterfaceList.fromJson({
    required List<dynamic> list,
  }) {
    return NetworkInterfaceList(
      (b) => b
        ..list = ListBuilder(
          list.map(
            (interface) => standardSerializers.deserializeWith(
              NetworkInterface.serializer,
              interface,
            )!,
          ),
        ),
    );
  }
}

abstract class NetworkHistoryValue
    implements Built<NetworkHistoryValue, NetworkHistoryValueBuilder> {
  static Serializer<NetworkHistoryValue> get serializer =>
      _$networkHistoryValueSerializer;

  BuiltMap<String, BuiltList<BuiltList<JsonObject>>> get history;

  NetworkHistoryValue._();
  factory NetworkHistoryValue([
    void Function(NetworkHistoryValueBuilder) updates,
  ]) = _$NetworkHistoryValue;

  factory NetworkHistoryValue.fromJson({
    required Map<String, dynamic> map,
  }) {
    return NetworkHistoryValue(
      (b) => b
        ..history = timeStampJsonObjectMapBuilder(
          map: map,
        ),
    );
  }
}

abstract class NetworkHistory
    implements Built<NetworkHistory, NetworkHistoryBuilder> {
  static Serializer<NetworkHistory> get serializer =>
      _$networkHistorySerializer;

  BuiltMap<String, BuiltList<TimeStamp<int>>> get history;

  NetworkHistory._();
  factory NetworkHistory([
    void Function(NetworkHistoryBuilder) updates,
  ]) = _$NetworkHistory;

  factory NetworkHistory.fromNetworkHistoryValue({
    required NetworkHistoryValue value,
  }) {
    return NetworkHistory(
      (b) => b
        ..history = timeStampMapper<int>(
          map: value.history,
        ),
    );
  }
}

class Now extends eq.Equatable {
  final String now;

  @override
  List<Object> get props => [
        now,
      ];

  @override
  bool get stringify => true;

  factory Now.fromQuoted({
    required String quoted,
  }) {
    return Now(
      now: quoted.replaceAll(
        '"',
        '',
      ),
    );
  }

  const Now({
    required this.now,
  });
}

abstract class ProcessCount
    implements Built<ProcessCount, ProcessCountBuilder> {
  static Serializer<ProcessCount> get serializer => _$processCountSerializer;

  int get total;
  int get running;
  int get sleeping;
  int get thread;
  @BuiltValueField(
    wireName: 'pid_max',
  )
  int get pidMax;

  ProcessCount._();
  factory ProcessCount([
    void Function(ProcessCountBuilder) updates,
  ]) = _$ProcessCount;
}

abstract class ProcessCountHistoryValue
    implements
        Built<ProcessCountHistoryValue, ProcessCountHistoryValueBuilder> {
  static Serializer<ProcessCountHistoryValue> get serializer =>
      _$processCountHistoryValueSerializer;

  BuiltList<BuiltList<JsonObject>> get total;
  BuiltList<BuiltList<JsonObject>> get running;
  BuiltList<BuiltList<JsonObject>> get sleeping;
  BuiltList<BuiltList<JsonObject>> get thread;

  ProcessCountHistoryValue._();
  factory ProcessCountHistoryValue([
    void Function(ProcessCountHistoryValueBuilder) updates,
  ]) = _$ProcessCountHistoryValue;
}

abstract class ProcessCountHistory
    implements Built<ProcessCountHistory, ProcessCountHistoryBuilder> {
  static Serializer<ProcessCountHistory> get serializer =>
      _$processCountHistorySerializer;

  BuiltList<TimeStamp<int>> get total;
  BuiltList<TimeStamp<int>> get running;
  BuiltList<TimeStamp<int>> get sleeping;
  BuiltList<TimeStamp<int>> get thread;

  ProcessCountHistory._();
  factory ProcessCountHistory([
    void Function(ProcessCountHistoryBuilder) updates,
  ]) = _$ProcessCountHistory;

  factory ProcessCountHistory.fromProcessCountHistoryValue({
    required ProcessCountHistoryValue value,
  }) {
    return ProcessCountHistory(
      (b) => b
        ..total = timeStampListBuilderFromJsonObjectList<int>(list: value.total)
        ..running =
            timeStampListBuilderFromJsonObjectList<int>(list: value.running)
        ..sleeping =
            timeStampListBuilderFromJsonObjectList<int>(list: value.sleeping)
        ..thread =
            timeStampListBuilderFromJsonObjectList<int>(list: value.thread),
    );
  }
}

abstract class Process implements Built<Process, ProcessBuilder> {
  static Serializer<Process> get serializer => _$processSerializer;

  String get key;
  @BuiltValueField(
    wireName: 'num_threads',
  )
  int get numThreads;
  @BuiltValueField(
    wireName: 'memory_info',
  )
  BuiltList<int> get memoryInfo;
  String get status;
  int get nice;
  int get pid;
  @BuiltValueField(
    wireName: 'io_counters',
  )
  BuiltList<int> get ioCounters;
  BuiltList<int> get gids;
  @BuiltValueField(
    wireName: 'cpu_times',
  )
  BuiltList<double> get cpuTimes;
  @BuiltValueField(
    wireName: 'memory_percent',
  )
  double get memoryPercent;
  String get name;
  int get ppid;
  @BuiltValueField(
    wireName: 'cpu_percent',
  )
  double get cpuPercent;
  @BuiltValueField(
    wireName: 'ionice',
  )
  BuiltList<int>? get ioNice;
  @BuiltValueField(
    wireName: 'num_ctx_switches',
  )
  BuiltList<int>? get numContextSwitches;
  @BuiltValueField(
    wireName: 'cpu_affinity',
  )
  BuiltList<int>? get cpuAffinity;
  @BuiltValueField(
    wireName: 'num_fds',
  )
  int? get numFileDescriptors;
  @BuiltValueField(
    wireName: 'memory_swap',
  )
  int? get memorySwap;
  int? get tcp;
  int? get udp;
  @BuiltValueField(
    wireName: 'extended_stats',
  )
  bool? get extendedStats;
  @BuiltValueField(
    wireName: 'time_since_update',
  )
  double get timeSinceUpdate;
  @BuiltValueField(
    wireName: 'cmdline',
  )
  BuiltList<String> get commandLine;
  @BuiltValueField(
    wireName: 'username',
  )
  String get userName;

  Process._();
  factory Process([void Function(ProcessBuilder) updates]) = _$Process;
}

abstract class ProcessList implements Built<ProcessList, ProcessListBuilder> {
  static Serializer<ProcessList> get serializer => _$processListSerializer;

  BuiltList<Process> get list;

  ProcessList._();
  factory ProcessList([
    void Function(ProcessListBuilder) updates,
  ]) = _$ProcessList;

  factory ProcessList.fromJson({
    required List<dynamic> list,
  }) {
    return ProcessList(
      (b) => b
        ..list = ListBuilder(
          list.map(
            (process) => standardSerializers.deserializeWith(
              Process.serializer,
              process,
            )!,
          ),
        ),
    );
  }
}

abstract class QuickLook implements Built<QuickLook, QuickLookBuilder> {
  static Serializer<QuickLook> get serializer => _$quickLookSerializer;

  double get cpu;
  @BuiltValueField(
    wireName: 'percpu',
  )
  BuiltList<PerCpu> get perCpu;
  double get mem;
  double get swap;
  @BuiltValueField(
    wireName: 'cpu_name',
  )
  String get cpuName;
  @BuiltValueField(
    wireName: 'cpu_hz_current',
  )
  double get cpuHertzCurrent;
  @BuiltValueField(
    wireName: 'cpu_hz',
  )
  double get cpuHertz;

  QuickLook._();
  factory QuickLook([
    void Function(QuickLookBuilder) updates,
  ]) = _$QuickLook;
}

abstract class QuickLookHistoryValue
    implements Built<QuickLookHistoryValue, QuickLookHistoryValueBuilder> {
  static Serializer<QuickLookHistoryValue> get serializer =>
      _$quickLookHistoryValueSerializer;

  BuiltList<BuiltList<JsonObject>> get cpu;
  @BuiltValueField(
    wireName: 'percpu',
  )
  BuiltList<BuiltList<JsonObject>> get perCpu;
  BuiltList<BuiltList<JsonObject>> get mem;
  BuiltList<BuiltList<JsonObject>> get swap;

  QuickLookHistoryValue._();
  factory QuickLookHistoryValue([
    void Function(QuickLookHistoryValueBuilder) updates,
  ]) = _$QuickLookHistoryValue;
}

Iterable<MapEntry<DateTime, BuiltList<PerCpu>>>
    mapEntryIterablePerCpuListJsonObject({
  required BuiltList<BuiltList<JsonObject>> list,
}) sync* {
  for (final perCpuHistoryTime in list) {
    var iterator = perCpuHistoryTime.iterator;
    var iterating = iterator.moveNext();
    if (!iterating) {
      break;
    }
    var dateTime = DateTime.parse(
      iterator.current.asString,
    ).toUtc();
    iterator.moveNext();
    BuiltList<PerCpu> perCpuList = BuiltList(
      iterator.current.asList.map(
        (perCpu) => standardSerializers.deserializeWith(
          PerCpu.serializer,
          perCpu,
        )!,
      ),
    );
    yield MapEntry<DateTime, BuiltList<PerCpu>>(
      dateTime,
      perCpuList,
    );
  }
}

MapBuilder<DateTime, BuiltList<PerCpu>> mapBuilderFromQuickLookPerCpuList({
  required BuiltList<BuiltList<JsonObject>> list,
}) {
  var builder = BuiltMap<DateTime, BuiltList<PerCpu>>().toBuilder();
  builder.addEntries(
    mapEntryIterablePerCpuListJsonObject(
      list: list,
    ),
  );
  return builder;
}

abstract class QuickLookHistory
    implements Built<QuickLookHistory, QuickLookHistoryBuilder> {
  static Serializer<QuickLookHistory> get serializer =>
      _$quickLookHistorySerializer;

  BuiltList<TimeStamp<double>> get cpu;
  BuiltMap<DateTime, BuiltList<PerCpu>> get perCpu;
  BuiltList<TimeStamp<double>> get mem;
  BuiltList<TimeStamp<double>> get swap;

  QuickLookHistory._();
  factory QuickLookHistory([
    void Function(QuickLookHistoryBuilder) updates,
  ]) = _$QuickLookHistory;

  factory QuickLookHistory.fromQuickLookHistoryValue({
    required QuickLookHistoryValue value,
  }) {
    return QuickLookHistory(
      (b) => b
        ..cpu = timeStampListBuilderFromJsonObjectList<double>(list: value.cpu)
        ..perCpu = mapBuilderFromQuickLookPerCpuList(list: value.perCpu)
        ..mem = timeStampListBuilderFromJsonObjectList<double>(list: value.mem)
        ..swap =
            timeStampListBuilderFromJsonObjectList<double>(list: value.swap),
    );
  }
}

abstract class Sensor implements Built<Sensor, SensorBuilder> {
  static Serializer<Sensor> get serializer => _$sensorSerializer;

  String get key;
  String get label;
  int get value;
  int? get warning;
  int? get critical;
  String get unit;
  String get type;

  Sensor._();
  factory Sensor([
    void Function(SensorBuilder) updates,
  ]) = _$Sensor;
}

abstract class SensorList implements Built<SensorList, SensorListBuilder> {
  static Serializer<SensorList> get serializer => _$sensorListSerializer;

  BuiltList<Sensor> get list;

  SensorList._();
  factory SensorList([
    void Function(SensorListBuilder) updates,
  ]) = _$SensorList;

  factory SensorList.fromJson({
    required List<dynamic> list,
  }) {
    return SensorList(
      (b) => b
        ..list = ListBuilder(
          list.map(
            (sensor) => standardSerializers.deserializeWith(
              Sensor.serializer,
              sensor,
            )!,
          ),
        ),
    );
  }
}

abstract class System implements Built<System, SystemBuilder> {
  static Serializer<System> get serializer => _$systemSerializer;

  @BuiltValueField(
    wireName: 'os_name',
  )
  String get osName;
  String get hostname;
  String get platform;
  @BuiltValueField(
    wireName: 'linux_distro',
  )
  String get linuxDistro;
  @BuiltValueField(
    wireName: 'os_version',
  )
  String get osVersion;
  @BuiltValueField(
    wireName: 'hr_name',
  )
  String get hrName;

  System._();
  factory System([
    void Function(SystemBuilder) updates,
  ]) = _$System;
}

class UpTime extends eq.Equatable {
  final String now;

  @override
  List<Object> get props => [
        now,
      ];

  @override
  bool get stringify => true;

  factory UpTime.fromQuoted({
    required String quoted,
  }) {
    return UpTime(
      now: quoted.replaceAll(
        '"',
        '',
      ),
    );
  }

  const UpTime({
    required this.now,
  });
}
