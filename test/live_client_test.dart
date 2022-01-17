import 'package:test/test.dart' as test;

import 'package:glances_dashboard/src/model.dart' as model;
import 'package:glances_dashboard/src/client.dart' as glances_client;

void main() {
  final client = glances_client.Client();

  test.group(
    'now()',
    () {
      test.test(
        'returns a Now object',
        () async {
          test.expect(
            await client.now(),
            test.isA<model.Now>(),
          );
        },
      );
    },
  );

  test.group(
    'upTime()',
    () {
      test.test(
        'returns a UpTime object',
        () async {
          test.expect(
            await client.upTime(),
            test.isA<model.UpTime>(),
          );
        },
      );
    },
  );

  test.group(
    'pluginsList()',
    () {
      test.test(
        'returns a PluginsList object',
        () async {
          test.expect(
            await client.pluginsList(),
            test.isA<model.PluginList>(),
          );
        },
      );
    },
  );

  test.group(
    'cores()',
    () {
      test.test(
        'returns a Cores object',
        () async {
          test.expect(
            await client.cores(),
            test.isA<model.Cores>(),
          );
        },
      );
    },
  );

  test.group(
    'cpu()',
    () {
      test.test(
        'returns a Cpu object',
        () async {
          test.expect(
            await client.cpu(),
            test.isA<model.TimeStamp<model.Cpu>>(),
          );
        },
      );
    },
  );

  test.group(
    'cpuHistory()',
    () {
      test.test(
        'returns a CpuHistory object',
        () async {
          test.expect(
            await client.cpuHistory(),
            test.isA<model.CpuHistory>(),
          );
        },
      );
    },
  );

  test.group(
    'allCpus()',
    () {
      test.test(
        'returns a AllCpusList object',
        () async {
          test.expect(
            await client.allCpus(),
            test.isA<model.TimeStamp<model.AllCpusList>>(),
          );
        },
      );
    },
  );

  test.group(
    'allCpusHistory()',
    () {
      test.test(
        'returns a AllCpusHistory object',
        () async {
          test.expect(
            await client.allCpusHistory(),
            test.isA<model.AllCpusHistory>(),
          );
        },
      );
    },
  );

  test.group(
    'cpuLoad()',
    () {
      test.test(
        'returns a CpuLoad object',
        () async {
          test.expect(
            await client.cpuLoad(),
            test.isA<model.TimeStamp<model.CpuLoad>>(),
          );
        },
      );
    },
  );

  test.group(
    'cpuLoadHistory()',
    () {
      test.test(
        'returns a CpuLoadHistory object',
        () async {
          test.expect(
            await client.cpuLoadHistory(),
            test.isA<model.CpuLoadHistory>(),
          );
        },
      );
    },
  );

  test.group(
    'diskIo()',
    () {
      test.test(
        'returns a DiskIoList object',
        () async {
          test.expect(
            await client.diskIo(),
            test.isA<model.TimeStamp<model.DiskIoList>>(),
          );
        },
      );
    },
  );

  test.group(
    'diskIoHistory()',
    () {
      test.test(
        'returns a DiskIoHistory object',
        () async {
          test.expect(
            await client.diskIoHistory(),
            test.isA<model.DiskIoHistory>(),
          );
        },
      );
    },
  );

  test.group(
    'fileSystem()',
    () {
      test.test(
        'returns a FileSystemList object',
        () async {
          test.expect(
            await client.fileSystem(),
            test.isA<model.TimeStamp<model.FileSystemList>>(),
          );
        },
      );
    },
  );

  test.group(
    'fileSystemHistory()',
    () {
      test.test(
        'returns a FileSystemHistory object',
        () async {
          test.expect(
            await client.fileSystemHistory(),
            test.isA<model.FileSystemHistory>(),
          );
        },
      );
    },
  );

  test.group(
    'internetProtocol()',
    () {
      test.test(
        'returns a InternetProtocol object',
        () async {
          test.expect(
            await client.internetProtocol(),
            test.isA<model.InternetProtocol>(),
          );
        },
      );
    },
  );

  test.group(
    'memory()',
    () {
      test.test(
        'returns a Memory object',
        () async {
          test.expect(
            await client.memory(),
            test.isA<model.TimeStamp<model.Memory>>(),
          );
        },
      );
    },
  );

  test.group(
    'memoryHistory()',
    () {
      test.test(
        'returns a MemoryHistory object',
        () async {
          test.expect(
            await client.memoryHistory(),
            test.isA<model.MemoryHistory>(),
          );
        },
      );
    },
  );

  test.group(
    'memorySwap()',
    () {
      test.test(
        'returns a MemorySwap object',
        () async {
          test.expect(
            await client.memorySwap(),
            test.isA<model.TimeStamp<model.MemorySwap>>(),
          );
        },
      );
    },
  );

  test.group(
    'memorySwapHistory()',
    () {
      test.test(
        'returns a MemorySwapHistory object',
        () async {
          test.expect(
            await client.memorySwapHistory(),
            test.isA<model.MemorySwapHistory>(),
          );
        },
      );
    },
  );

  test.group(
    'networkInterface()',
    () {
      test.test(
        'returns a NetworkInterfaceList object',
        () async {
          test.expect(
            await client.networkInterface(),
            test.isA<model.TimeStamp<model.NetworkInterfaceList>>(),
          );
        },
      );
    },
  );

  test.group(
    'networkHistory()',
    () {
      test.test(
        'returns a NetworkHistory object',
        () async {
          test.expect(
            await client.networkHistory(),
            test.isA<model.NetworkHistory>(),
          );
        },
      );
    },
  );

  test.group(
    'processCount()',
    () {
      test.test(
        'returns a ProcessCount object',
        () async {
          test.expect(
            await client.processCount(),
            test.isA<model.TimeStamp<model.ProcessCount>>(),
          );
        },
      );
    },
  );

  test.group(
    'processCountHistory()',
    () {
      test.test(
        'returns a ProcessCountHistory object',
        () async {
          test.expect(
            await client.processCountHistory(),
            test.isA<model.ProcessCountHistory>(),
          );
        },
      );
    },
  );

  test.group(
    'processList()',
    () {
      test.test(
        'returns a ProcessList object',
        () async {
          test.expect(
            await client.processList(),
            test.isA<model.TimeStamp<model.ProcessList>>(),
          );
        },
      );
    },
  );

  test.group(
    'quickLook()',
    () {
      test.test(
        'returns a QuickLook object',
        () async {
          test.expect(
            await client.quickLook(),
            test.isA<model.TimeStamp<model.QuickLook>>(),
          );
        },
      );
    },
  );

  test.group(
    'quickLookHistory()',
    () {
      test.test(
        'returns a QuickLookHistory object',
        () async {
          test.expect(
            await client.quickLookHistory(),
            test.isA<model.QuickLookHistory>(),
          );
        },
      );
    },
  );

  test.group(
    'sensors()',
    () {
      test.test(
        'returns a SensorList object',
        () async {
          test.expect(
            await client.sensors(),
            test.isA<model.TimeStamp<model.SensorList>>(),
          );
        },
      );
    },
  );

  test.group(
    'system()',
    () {
      test.test(
        'returns a System object',
        () async {
          test.expect(
            await client.system(),
            test.isA<model.System>(),
          );
        },
      );
    },
  );
}
