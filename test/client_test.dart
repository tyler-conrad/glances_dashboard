import 'package:test/test.dart' as t;

import 'package:glances_dashboard/src/model.dart' as md;
import 'package:glances_dashboard/src/client.dart' as c;

void main() {
  final c.Client client = c.Client();

  t.group(
    'now()',
    () {
      t.test(
        'returns a Now object',
        () async {
          t.expect(
            await client.now(),
            t.isA<md.Now>(),
          );
        },
      );
    },
  );

  t.group(
    'upTime()',
    () {
      t.test(
        'returns a UpTime object',
        () async {
          t.expect(
            await client.upTime(),
            t.isA<md.UpTime>(),
          );
        },
      );
    },
  );

  t.group(
    'pluginsList()',
    () {
      t.test(
        'returns a PluginsList object',
        () async {
          t.expect(
            await client.pluginsList(),
            t.isA<md.PluginsList>(),
          );
        },
      );
    },
  );

  t.group(
    'core()',
    () {
      t.test(
        'returns a Core object',
        () async {
          t.expect(
            await client.core(),
            t.isA<md.Core>(),
          );
        },
      );
    },
  );

  t.group(
    'cpu()',
    () {
      t.test(
        'returns a Cpu object',
        () async {
          t.expect(
            await client.cpu(),
            t.isA<md.Cpu>(),
          );
        },
      );
    },
  );

  t.group(
    'cpuHistory()',
    () {
      t.test(
        'returns a CpuHistory object',
        () async {
          t.expect(
            await client.cpuHistory(),
            t.isA<md.CpuHistory>(),
          );
        },
      );
    },
  );

  t.group(
    'perCpu()',
    () {
      t.test(
        'returns a PerCpuList object',
        () async {
          t.expect(
            await client.perCpu(),
            t.isA<md.PerCpuList>(),
          );
        },
      );
    },
  );

  t.group(
    'perCpuHistory()',
    () {
      t.test(
        'returns a PerCpuHistory object',
        () async {
          t.expect(
            await client.perCpuHistory(),
            t.isA<md.PerCpuHistory>(),
          );
        },
      );
    },
  );

  t.group(
    'cpuLoad()',
        () {
      t.test(
        'returns a CpuLoad object',
            () async {
          t.expect(
            await client.cpuLoad(),
            t.isA<md.CpuLoad>(),
          );
        },
      );
    },
  );

  t.group(
    'cpuLoadHistory()',
        () {
      t.test(
        'returns a CpuLoadHistory object',
            () async {
          t.expect(
            await client.cpuLoadHistory(),
            t.isA<md.CpuLoadHistory>(),
          );
        },
      );
    },
  );

  t.group(
    'diskIo()',
    () {
      t.test(
        'returns a DiskIoList object',
        () async {
          t.expect(
            await client.diskIo(),
            t.isA<md.DiskIoList>(),
          );
        },
      );
    },
  );

  t.group(
    'diskIoHistory()',
    () {
      t.test(
        'returns a DiskIoHistory object',
        () async {
          t.expect(
            await client.diskIoHistory(),
            t.isA<md.DiskIoHistory>(),
          );
        },
      );
    },
  );

  t.group(
    'fileSystem()',
    () {
      t.test(
        'returns a FileSystemList object',
        () async {
          t.expect(
            await client.fileSystem(),
            t.isA<md.FileSystemList>(),
          );
        },
      );
    },
  );

  t.group(
    'fileSystemHistory()',
    () {
      t.test(
        'returns a FileSystemHistory object',
        () async {
          t.expect(
            await client.fileSystemHistory(),
            t.isA<md.FileSystemHistory>(),
          );
        },
      );
    },
  );

  t.group(
    'internetProtocol()',
    () {
      t.test(
        'returns a InternetProtocol object',
        () async {
          t.expect(
            await client.internetProtocol(),
            t.isA<md.InternetProtocol>(),
          );
        },
      );
    },
  );

  t.group(
    'memory()',
    () {
      t.test(
        'returns a Memory object',
        () async {
          t.expect(
            await client.memory(),
            t.isA<md.Memory>(),
          );
        },
      );
    },
  );

  t.group(
    'memoryHistory()',
    () {
      t.test(
        'returns a MemoryHistory object',
        () async {
          t.expect(
            await client.memoryHistory(),
            t.isA<md.MemoryHistory>(),
          );
        },
      );
    },
  );

  t.group(
    'memorySwap()',
    () {
      t.test(
        'returns a MemorySwap object',
        () async {
          t.expect(
            await client.memorySwap(),
            t.isA<md.MemorySwap>(),
          );
        },
      );
    },
  );

  t.group(
    'memorySwapHistory()',
    () {
      t.test(
        'returns a MemorySwapHistory object',
        () async {
          t.expect(
            await client.memorySwapHistory(),
            t.isA<md.MemorySwapHistory>(),
          );
        },
      );
    },
  );

  t.group(
    'networkInterface()',
    () {
      t.test(
        'returns a NetworkInterfaceList object',
        () async {
          t.expect(
            await client.networkInterface(),
            t.isA<md.NetworkInterfaceList>(),
          );
        },
      );
    },
  );

  t.group(
    'networkHistory()',
    () {
      t.test(
        'returns a NetworkHistory object',
        () async {
          t.expect(
            await client.networkHistory(),
            t.isA<md.NetworkHistory>(),
          );
        },
      );
    },
  );

  t.group(
    'processCount()',
    () {
      t.test(
        'returns a ProcessCount object',
        () async {
          t.expect(
            await client.processCount(),
            t.isA<md.ProcessCount>(),
          );
        },
      );
    },
  );

  t.group(
    'processCountHistory()',
    () {
      t.test(
        'returns a ProcessCountHistory object',
        () async {
          t.expect(
            await client.processCountHistory(),
            t.isA<md.ProcessCountHistory>(),
          );
        },
      );
    },
  );

  t.group(
    'processList()',
    () {
      t.test(
        'returns a ProcessList object',
        () async {
          t.expect(
            await client.processList(),
            t.isA<md.ProcessList>(),
          );
        },
      );
    },
  );

  t.group(
    'quickLook()',
    () {
      t.test(
        'returns a QuickLook object',
        () async {
          t.expect(
            await client.quickLook(),
            t.isA<md.QuickLook>(),
          );
        },
      );
    },
  );

  t.group(
    'quickLookHistory()',
    () {
      t.test(
        'returns a QuickLookHistory object',
        () async {
          t.expect(
            await client.quickLookHistory(),
            t.isA<md.QuickLookHistory>(),
          );
        },
      );
    },
  );

  t.group(
    'sensors()',
    () {
      t.test(
        'returns a SensorList object',
        () async {
          t.expect(
            await client.sensors(),
            t.isA<md.SensorList>(),
          );
        },
      );
    },
  );

  t.group(
    'system()',
    () {
      t.test(
        'returns a System object',
        () async {
          t.expect(
            await client.system(),
            t.isA<md.System>(),
          );
        },
      );
    },
  );
}
