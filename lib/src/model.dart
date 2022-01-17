import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:equatable/equatable.dart' as eq;
import 'package:glances_dashboard/src/serializers.dart';

part 'model.g.dart';

abstract class HistoryTimeStamp<T extends num>
    implements Built<HistoryTimeStamp<T>, HistoryTimeStampBuilder<T>> {
  static Serializer<HistoryTimeStamp<num>> get serializer =>
      _$historyTimeStampSerializer;

  DateTime get timeStamp;

  T get value;

  factory HistoryTimeStamp([
    Function(HistoryTimeStampBuilder<T>) updates,
  ]) = _$HistoryTimeStamp<T>;

  HistoryTimeStamp._();
}

ListBuilder<HistoryTimeStamp<T>>
    timeStampListBuilderFromJsonObjectList<T extends num>(
            {required BuiltList<BuiltList<JsonObject>> list}) =>
        ListBuilder(
          list.map(
            (timeStamp) => HistoryTimeStamp<T>(
              (b) => b
                ..timeStamp = DateTime.parse(timeStamp[0].asString).toUtc()
                ..value = timeStamp[1].asNum as T,
            ),
          ),
        );

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

MapBuilder<String, BuiltList<HistoryTimeStamp<T>>>
    timeStampMapper<T extends num>({
  required BuiltMap<String, BuiltList<BuiltList<JsonObject>>> map,
}) {
  return MapBuilder(
    map.map(
      (
        key,
        list,
      ) =>
          MapEntry(
        key,
        timeStampListBuilderFromJsonObjectList<T>(
          list: list,
        ).build(),
      ),
    ),
  );
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

class UpTime extends eq.Equatable {
  final String upTime;

  @override
  List<Object> get props => [
        upTime,
      ];

  @override
  bool get stringify => true;

  factory UpTime.fromQuoted({
    required String quoted,
  }) {
    return UpTime(
      upTime: quoted.replaceAll(
        '"',
        '',
      ),
    );
  }

  const UpTime({
    required this.upTime,
  });
}

@BuiltValue(instantiable: false)
abstract class ModelBase extends Object {
  ModelBase rebuild(
    void Function(ModelBaseBuilder) updates,
  );

  ModelBaseBuilder toBuilder();
}

@BuiltValue(instantiable: false)
abstract class Model extends Object implements ModelBase {
  @override
  Model rebuild(
    void Function(ModelBuilder) updates,
  );

  @override
  ModelBuilder toBuilder();
}

@BuiltValue(instantiable: false)
abstract class StreamModel extends Object implements ModelBase {
  @override
  StreamModel rebuild(
    void Function(StreamModelBuilder) updates,
  );

  @override
  StreamModelBuilder toBuilder();
}

abstract class TimeStamp<M extends StreamModel>
    implements Built<TimeStamp<M>, TimeStampBuilder<M>> {
  static Serializer<TimeStamp<StreamModel>> get serializer =>
      _$timeStampSerializer;

  DateTime get timeStamp;
  M get model;

  TimeStamp._();
  factory TimeStamp([
    void Function(TimeStampBuilder<M>) updates,
  ]) = _$TimeStamp<M>;
}

abstract class StreamIndex<M extends StreamModel>
    implements Built<StreamIndex<M>, StreamIndexBuilder<M>> {
  static Serializer<StreamIndex<StreamModel>> get serializer =>
      _$streamIndexSerializer;

  int get index;
  TimeStamp<M> get timeStamp;

  StreamIndex._();
  factory StreamIndex([
    void Function(StreamIndexBuilder<M>) updates,
  ]) = _$StreamIndex<M>;
}

@BuiltValue(instantiable: false)
abstract class HistoryModel extends Object implements ModelBase {
  @override
  HistoryModel rebuild(
    void Function(HistoryModelBuilder) updates,
  );

  @override
  HistoryModelBuilder toBuilder();
}

@BuiltValue(instantiable: false)
abstract class ModelList<M extends Model> extends Object
    implements StreamModel {
  BuiltList<M> get list;

  @override
  ModelList<M> rebuild(
    void Function(ModelListBuilder<M>) updates,
  );

  @override
  ModelListBuilder<M> toBuilder();
}

abstract class Plugin implements Model, Built<Plugin, PluginBuilder> {
  static Serializer<Plugin> get serializer => _$pluginSerializer;

  String get value;

  Plugin._();
  factory Plugin([
    void Function(PluginBuilder) updates,
  ]) = _$Plugin;
}

abstract class PluginList
    implements ModelList<Plugin>, Built<PluginList, PluginListBuilder> {
  static Serializer<PluginList> get serializer => _$pluginListSerializer;

  @override
  BuiltList<Plugin> get list;

  PluginList._();

  factory PluginList([
    void Function(PluginListBuilder) updates,
  ]) = _$PluginList;

  factory PluginList.fromJson({
    required List<dynamic> list,
  }) {
    return PluginList(
      (b) => b
        ..list = ListBuilder<Plugin>(
          list.map(
            (s) => Plugin((
              b,
            ) =>
                b.value = s),
          ),
        ),
    );
  }
}

abstract class Cores implements Model, Built<Cores, CoresBuilder> {
  static Serializer<Cores> get serializer => _$coresSerializer;

  @BuiltValueField(
    wireName: 'phys',
  )
  int get physical;

  @BuiltValueField(
    wireName: 'log',
  )
  int get logical;

  Cores._();

  factory Cores([
    void Function(CoresBuilder) updates,
  ]) = _$Cores;
}

abstract class Cpu implements StreamModel, Built<Cpu, CpuBuilder> {
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
  int get cpuCoresCount;

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

abstract class CpuHistory
    implements HistoryModel, Built<CpuHistory, CpuHistoryBuilder> {
  static Serializer<CpuHistory> get serializer => _$cpuHistorySerializer;

  BuiltList<HistoryTimeStamp<double>> get user;

  BuiltList<HistoryTimeStamp<double>> get system;

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

abstract class AllCpus implements Model, Built<AllCpus, AllCpusBuilder> {
  static Serializer<AllCpus> get serializer => _$allCpusSerializer;

  String get key;

  @BuiltValueField(
    wireName: 'cpu_number',
  )
  int get number;

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

  AllCpus._();

  factory AllCpus([
    void Function(AllCpusBuilder) updates,
  ]) = _$AllCpus;
}

abstract class AllCpusList
    implements ModelList<AllCpus>, Built<AllCpusList, AllCpusListBuilder> {
  static Serializer<AllCpusList> get serializer => _$allCpusListSerializer;

  @override
  BuiltList<AllCpus> get list;

  AllCpusList._();

  factory AllCpusList([
    void Function(AllCpusListBuilder) updates,
  ]) = _$AllCpusList;

  factory AllCpusList.fromJson({
    required List<dynamic> list,
  }) {
    return AllCpusList(
      (b) => b
        ..list = ListBuilder(
          list.map(
            (perCpu) => standardSerializers.deserializeWith(
              AllCpus.serializer,
              perCpu,
            )!,
          ),
        ),
    );
  }
}

abstract class AllCpusHistoryValue
    implements Built<AllCpusHistoryValue, AllCpusHistoryValueBuilder> {
  static Serializer<AllCpusHistoryValue> get serializer =>
      _$allCpusHistoryValueSerializer;

  BuiltMap<String, BuiltList<BuiltList<JsonObject>>> get history;

  AllCpusHistoryValue._();

  factory AllCpusHistoryValue([
    void Function(AllCpusHistoryValueBuilder) updates,
  ]) = _$AllCpusHistoryValue;

  factory AllCpusHistoryValue.fromJson({
    required Map<String, dynamic> map,
  }) {
    return AllCpusHistoryValue(
      (b) => b
        ..history = timeStampJsonObjectMapBuilder(
          map: map,
        ),
    );
  }
}

abstract class AllCpusHistory
    implements HistoryModel, Built<AllCpusHistory, AllCpusHistoryBuilder> {
  static Serializer<AllCpusHistory> get serializer =>
      _$allCpusHistorySerializer;

  BuiltMap<String, BuiltList<HistoryTimeStamp<double>>> get history;

  AllCpusHistory._();

  factory AllCpusHistory([
    void Function(AllCpusHistoryBuilder) updates,
  ]) = _$AllCpusHistory;

  factory AllCpusHistory.fromAllCpusHistoryValue({
    required AllCpusHistoryValue value,
  }) {
    return AllCpusHistory(
      (b) => b
        ..history = timeStampMapper<double>(
          map: value.history,
        ),
    );
  }
}

abstract class CpuLoad implements StreamModel, Built<CpuLoad, CpuLoadBuilder> {
  static Serializer<CpuLoad> get serializer => _$cpuLoadSerializer;

  double get min1;

  double get min5;

  double get min15;

  @BuiltValueField(
    wireName: 'cpucore',
  )
  int get cpuCoresCount;

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
    implements HistoryModel, Built<CpuLoadHistory, CpuLoadHistoryBuilder> {
  static Serializer<CpuLoadHistory> get serializer =>
      _$cpuLoadHistorySerializer;

  BuiltList<HistoryTimeStamp<double>> get min1;

  BuiltList<HistoryTimeStamp<double>> get min5;

  BuiltList<HistoryTimeStamp<double>> get min15;

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

abstract class DiskIo implements Model, Built<DiskIo, DiskIoBuilder> {
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

abstract class DiskIoList
    implements ModelList<DiskIo>, Built<DiskIoList, DiskIoListBuilder> {
  static Serializer<DiskIoList> get serializer => _$diskIoListSerializer;

  @override
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
    implements HistoryModel, Built<DiskIoHistory, DiskIoHistoryBuilder> {
  static Serializer<DiskIoHistory> get serializer => _$diskIoHistorySerializer;

  BuiltMap<String, BuiltList<HistoryTimeStamp<int>>> get history;

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

abstract class FileSystem
    implements Model, Built<FileSystem, FileSystemBuilder> {
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
    implements
        ModelList<FileSystem>,
        Built<FileSystemList, FileSystemListBuilder> {
  static Serializer<FileSystemList> get serializer =>
      _$fileSystemListSerializer;

  @override
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
    implements
        HistoryModel,
        Built<FileSystemHistory, FileSystemHistoryBuilder> {
  static Serializer<FileSystemHistory> get serializer =>
      _$fileSystemHistorySerializer;

  BuiltMap<String, BuiltList<HistoryTimeStamp<double>>> get history;

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
    implements Model, Built<InternetProtocol, InternetProtocolBuilder> {
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

abstract class Memory implements StreamModel, Built<Memory, MemoryBuilder> {
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
    implements HistoryModel, Built<MemoryHistory, MemoryHistoryBuilder> {
  static Serializer<MemoryHistory> get serializer => _$memoryHistorySerializer;

  BuiltList<HistoryTimeStamp<double>> get percent;

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

abstract class MemorySwap
    implements StreamModel, Built<MemorySwap, MemorySwapBuilder> {
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
    implements
        HistoryModel,
        Built<MemorySwapHistory, MemorySwapHistoryBuilder> {
  static Serializer<MemorySwapHistory> get serializer =>
      _$memorySwapHistorySerializer;

  BuiltList<HistoryTimeStamp<double>> get percent;

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
    implements Model, Built<NetworkInterface, NetworkInterfaceBuilder> {
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
    implements
        ModelList<NetworkInterface>,
        Built<NetworkInterfaceList, NetworkInterfaceListBuilder> {
  static Serializer<NetworkInterfaceList> get serializer =>
      _$networkInterfaceListSerializer;

  @override
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
    implements HistoryModel, Built<NetworkHistory, NetworkHistoryBuilder> {
  static Serializer<NetworkHistory> get serializer =>
      _$networkHistorySerializer;

  BuiltMap<String, BuiltList<HistoryTimeStamp<int>>> get history;

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

abstract class ProcessCount
    implements StreamModel, Built<ProcessCount, ProcessCountBuilder> {
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
    implements
        HistoryModel,
        Built<ProcessCountHistory, ProcessCountHistoryBuilder> {
  static Serializer<ProcessCountHistory> get serializer =>
      _$processCountHistorySerializer;

  BuiltList<HistoryTimeStamp<int>> get total;

  BuiltList<HistoryTimeStamp<int>> get running;

  BuiltList<HistoryTimeStamp<int>> get sleeping;

  BuiltList<HistoryTimeStamp<int>> get thread;

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

abstract class Process implements Model, Built<Process, ProcessBuilder> {
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

abstract class ProcessList
    implements ModelList<Process>, Built<ProcessList, ProcessListBuilder> {
  static Serializer<ProcessList> get serializer => _$processListSerializer;

  @override
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

abstract class QuickLook
    implements StreamModel, Built<QuickLook, QuickLookBuilder> {
  static Serializer<QuickLook> get serializer => _$quickLookSerializer;

  double get cpu;

  @BuiltValueField(
    wireName: 'percpu',
  )
  BuiltList<AllCpus> get allCpus;

  @BuiltValueField(
    wireName: 'mem',
  )
  double get memory;

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
  BuiltList<BuiltList<JsonObject>> get allCpus;

  BuiltList<BuiltList<JsonObject>> get mem;

  BuiltList<BuiltList<JsonObject>> get swap;

  QuickLookHistoryValue._();

  factory QuickLookHistoryValue([
    void Function(QuickLookHistoryValueBuilder) updates,
  ]) = _$QuickLookHistoryValue;
}

Iterable<MapEntry<DateTime, BuiltList<AllCpus>>>
    mapEntryIterableAllCpusListJsonObject({
  required BuiltList<BuiltList<JsonObject>> list,
}) sync* {
  for (final perCpuHistoryTime in list) {
    final iterator = perCpuHistoryTime.iterator;
    if (!iterator.moveNext()) {
      break;
    }
    final dateTime = DateTime.parse(
      iterator.current.asString,
    ).toUtc();
    iterator.moveNext();
    BuiltList<AllCpus> allCpusList = BuiltList(
      iterator.current.asList.map(
        (perCpu) => standardSerializers.deserializeWith(
          AllCpus.serializer,
          perCpu,
        )!,
      ),
    );
    yield MapEntry<DateTime, BuiltList<AllCpus>>(
      dateTime,
      allCpusList,
    );
  }
}

MapBuilder<DateTime, BuiltList<AllCpus>> mapBuilderFromQuickLookPerCpuList({
  required BuiltList<BuiltList<JsonObject>> list,
}) =>
    MapBuilder(
      Map.fromEntries(
        mapEntryIterableAllCpusListJsonObject(
          list: list,
        ),
      ),
    );

abstract class QuickLookHistory
    implements HistoryModel, Built<QuickLookHistory, QuickLookHistoryBuilder> {
  static Serializer<QuickLookHistory> get serializer =>
      _$quickLookHistorySerializer;

  BuiltList<HistoryTimeStamp<double>> get cpu;

  BuiltMap<DateTime, BuiltList<AllCpus>> get allCpus;

  BuiltList<HistoryTimeStamp<double>> get mem;

  BuiltList<HistoryTimeStamp<double>> get swap;

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
        ..allCpus = mapBuilderFromQuickLookPerCpuList(list: value.allCpus)
        ..mem = timeStampListBuilderFromJsonObjectList<double>(list: value.mem)
        ..swap =
            timeStampListBuilderFromJsonObjectList<double>(list: value.swap),
    );
  }
}

abstract class Sensor implements Model, Built<Sensor, SensorBuilder> {
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

abstract class SensorList
    implements ModelList<Sensor>, Built<SensorList, SensorListBuilder> {
  static Serializer<SensorList> get serializer => _$sensorListSerializer;

  @override
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

abstract class System implements Model, Built<System, SystemBuilder> {
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
