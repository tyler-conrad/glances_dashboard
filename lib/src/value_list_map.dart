import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart' as m;

part 'value_list_map.g.dart';

abstract class Value implements Built<Value, ValueBuilder> {
  static Serializer<Value> get serializer => _$valueSerializer;

  DateTime get timeStamp;
  num get value;
  double get normalized;
  String get hoverText;
  int get streamIndex;

  Value._();
  factory Value([
    void Function(ValueBuilder) updates,
  ]) = _$Value;
}

mixin FixedLength {
  int get fixedLength;
}

@BuiltValue(instantiable: false)
abstract class HoverTextBase extends Object {
  HoverTextBase rebuild(
      void Function(HoverTextBaseBuilder) updates,
      );

  HoverTextBaseBuilder toBuilder();
}

abstract class FileSystemHoverText implements HoverTextBase, Built<FileSystemHoverText, FileSystemHoverTextBuilder> {
  static Serializer<FileSystemHoverText> get serializer => _$fileSystemHoverTextSerializer;

  String get type;
  String get mountPoint;

  FileSystemHoverText._();
  factory FileSystemHoverText([void Function(FileSystemHoverTextBuilder) updates,]) = _$FileSystemHoverText;
}

abstract class ProcessHoverText implements HoverTextBase, Built<ProcessHoverText, ProcessHoverTextBuilder> {
  static Serializer<ProcessHoverText> get serializer => _$processHoverTextSerializer;

  int get pid;
  String get name;

  ProcessHoverText._();
  factory ProcessHoverText([void Function(ProcessHoverTextBuilder) updates,]) = _$ProcessHoverText;
}

@BuiltValue(instantiable: false)
abstract class MapValueBase extends Object {
  MapValueBase rebuild(
    void Function(MapValueBaseBuilder) updates,
  );

  MapValueBaseBuilder toBuilder();
}

abstract class ListOfValues
    implements MapValueBase, Built<ListOfValues, ListOfValuesBuilder> {
  static Serializer<ListOfValues> get serializer => _$listOfValuesSerializer;

  m.Color get color;
  String get selectionText;

  bool? get defaultVisible;

  BuiltList<Value> get list;

  ListOfValues._();

  factory ListOfValues([
    void Function(ListOfValuesBuilder) updates,
  ]) = _$ListOfValues;
}

@BuiltValue(instantiable: false)
abstract class MapBase extends Object {
  BuiltMap<String, MapValueBase> get map;

  MapBase rebuild(
      void Function(MapBaseBuilder) updates,
      );

  MapBaseBuilder toBuilder();
}

abstract class MapOfLists
    implements MapBase, MapValueBase, Built<MapOfLists, MapOfListsBuilder> {
  static Serializer<MapOfLists> get serializer => _$mapOfListsSerializer;

  HoverTextBase? get hoverText;

  @override
  BuiltMap<String, ListOfValues> get map;

  MapOfLists._();

  factory MapOfLists([
    void Function(MapOfListsBuilder) updates,
  ]) = _$MapOfLists;
}

abstract class FixedLengthMapOfLists
        with FixedLength
    implements
        MapBase,
        MapValueBase,
        Built<FixedLengthMapOfLists, FixedLengthMapOfListsBuilder> {
  static Serializer<FixedLengthMapOfLists> get serializer =>
      _$fixedLengthMapOfListsSerializer;

  @override
  BuiltMap<String, ListOfValues> get map;

  FixedLengthMapOfLists._();

  factory FixedLengthMapOfLists([
    void Function(FixedLengthMapOfListsBuilder) updates,
  ]) = _$FixedLengthMapOfLists;
}

abstract class MapOfMaps
    implements MapValueBase, MapBase, Built<MapOfMaps, MapOfMapsBuilder> {
  static Serializer<MapOfMaps> get serializer =>
      _$mapOfMapsSerializer;

  MapOfMaps._();

  factory MapOfMaps([
    void Function(MapOfMapsBuilder) updates,
  ]) = _$MapOfMaps;
}

abstract class FixedLengthMapOfMapOfLists
    with FixedLength
    implements
        MapBase, MapValueBase, Built<FixedLengthMapOfMapOfLists, FixedLengthMapOfMapOfListsBuilder> {
  static Serializer<FixedLengthMapOfMapOfLists> get serializer =>
      _$fixedLengthMapOfMapOfListsSerializer;

  FixedLengthMapOfMapOfLists._();

  factory FixedLengthMapOfMapOfLists([
    void Function(FixedLengthMapOfMapOfListsBuilder) updates,
  ]) = _$FixedLengthMapOfMapOfLists;
}
