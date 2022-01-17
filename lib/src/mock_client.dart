import 'dart:io' as io;

import 'package:glances_dashboard/src/client.dart' as client;

class MockClient extends client.Client {
  @override
  Future<String> nowString() async =>
      await io.File('test/json/now.json').readAsString();

  @override
  Future<String> upTimeString() async =>
      await io.File('test/json/up_time.json').readAsString();

  @override
  Future<String> pluginsListString() async =>
      await io.File('test/json/plugins_list.json').readAsString();

  @override
  Future<String> coresString() async =>
      await io.File('test/json/cores.json').readAsString();

  @override
  Future<String> cpuString() async =>
      await io.File('test/json/cpu.json').readAsString();

  @override
  Future<String> cpuHistoryString() async =>
      await io.File('test/json/cpu_history.json').readAsString();

  @override
  Future<String> allCpusString() async =>
      await io.File('test/json/all_cpus.json').readAsString();

  @override
  Future<String> allCpusHistoryString() async =>
      await io.File('test/json/all_cpus_history.json').readAsString();

  @override
  Future<String> cpuLoadString() async =>
      await io.File('test/json/cpu_load.json').readAsString();

  @override
  Future<String> cpuLoadHistoryString() async =>
      await io.File('test/json/cpu_load_history.json').readAsString();

  @override
  Future<String> diskIoString() async =>
      await io.File('test/json/disk_io.json').readAsString();

  @override
  Future<String> diskIoHistoryString() async =>
      await io.File('test/json/disk_io_history.json').readAsString();

  @override
  Future<String> fileSystemString() async =>
      await io.File('test/json/file_system.json').readAsString();

  @override
  Future<String> fileSystemHistoryString() async =>
      await io.File('test/json/file_system_history.json').readAsString();

  @override
  Future<String> internetProtocolString() async =>
      await io.File('test/json/internet_protocol.json').readAsString();

  @override
  Future<String> memoryString() async =>
      await io.File('test/json/memory.json').readAsString();

  @override
  Future<String> memoryHistoryString() async =>
      await io.File('test/json/memory_history.json').readAsString();

  @override
  Future<String> memorySwapString() async =>
      await io.File('test/json/memory_swap.json').readAsString();

  @override
  Future<String> memorySwapHistoryString() async =>
      await io.File('test/json/memory_swap_history.json').readAsString();

  @override
  Future<String> networkInterfaceString() async =>
      await io.File('test/json/network_interface.json').readAsString();

  @override
  Future<String> networkHistoryString() async =>
      await io.File('test/json/network_history.json').readAsString();

  @override
  Future<String> processCountString() async =>
      await io.File('test/json/process_count.json').readAsString();

  @override
  Future<String> processCountHistoryString() async =>
      await io.File('test/json/process_count_history.json').readAsString();

  @override
  Future<String> processListString() async =>
      await io.File('test/json/process_list.json').readAsString();

  @override
  Future<String> quickLookString() async =>
      await io.File('test/json/quick_look.json').readAsString();

  @override
  Future<String> quickLookHistoryString() async =>
      await io.File('test/json/quick_look_history.json').readAsString();

  @override
  Future<String> sensorsString() async =>
      await io.File('test/json/sensors.json').readAsString();

  @override
  Future<String> systemString() async =>
      await io.File('test/json/system.json').readAsString();
}
