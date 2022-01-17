import 'package:flutter/material.dart' as m;
import 'package:yaru/yaru.dart' as yaru;

import 'src/model.dart' as model;
import 'src/client.dart' as client;
import 'src/value_list_map_builder.dart' as vlmb;
import 'src/chart.dart' as chart;

void main() {
  m.runApp(
    m.MaterialApp(
      themeMode: m.ThemeMode.dark,
      darkTheme: yaru.yaruDark,
      home: Home(),
    ),
  );
}

class Home extends m.StatelessWidget {
  static const double _appBarHeight = 48.0;

  final List<m.Tab> tabs = [
    const m.Tab(
      text: 'System',
    ),
    const m.Tab(
      text: 'CPU',
    ),
    const m.Tab(
      text: 'CPU Load',
    ),
    const m.Tab(text: 'All CPUs'),
    const m.Tab(
      text: 'Memory',
    ),
    const m.Tab(
      text: 'Disk IO',
    ),
    const m.Tab(
      text: 'Network',
    ),
    const m.Tab(
      text: 'Process Count',
    ),
    const m.Tab(
      text: 'Process List',
    ),
  ];

  @override
  m.Widget build(m.BuildContext context) {
    return m.DefaultTabController(
      length: tabs.length,
      child: m.SafeArea(
        child: m.Scaffold(
          appBar: m.PreferredSize(
            preferredSize: const m.Size.fromHeight(_appBarHeight),
            child: m.AppBar(
              bottom: m.TabBar(
                tabs: tabs,
              ),
            ),
          ),
          body: const m.TabBarView(
            children: [
              System(),
              m.Text('CPU'),
              m.Text('CPU Load'),
              m.Text('All CPUs'),
              m.Text('Memory'),
              m.Text('Disk IO'),
              m.Text('Network'),
              m.Text('Process Count'),
              m.Text('Process List'),
            ],
          ),
        ),
      ),
    );
  }

  Home({m.Key? key}) : super(key: key);
}

class System extends m.StatefulWidget {
  @override
  m.State<m.StatefulWidget> createState() => _SystemState();

  const System({m.Key? key}) : super(key: key);
}

class _SystemState extends m.State<System>
    with
        m.SingleTickerProviderStateMixin,
        m.AutomaticKeepAliveClientMixin<System> {
  static const double _frameOuterPadding = 16.0;
  static const double _frameInnerPadding = 16.0;
  static const double _frameBorderRadius = 4.0;

  final m.ValueNotifier<bool> _chartMaximized = m.ValueNotifier(false);

  late final Stream<model.Now> nowStream;
  late final Stream<model.UpTime> upTimeStream;

  late final m.AnimationController _chartHeightController;
  late final m.Animation _chartTopAnimation;
  late final m.Animation _chartHeightAnimation;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _chartHeightController = m.AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _chartTopAnimation = m.Tween(begin: 0.5, end: 0.0).animate(
      m.CurvedAnimation(
          parent: _chartHeightController, curve: m.Curves.easeInOut),
    );

    _chartHeightAnimation = m.Tween(begin: 0.5, end: 1.0).animate(
      m.CurvedAnimation(
          parent: _chartHeightController, curve: m.Curves.easeInOut),
    )..addListener(
        () {
          setState(
            () {},
          );
        },
      );

    _chartMaximized.addListener(
      () {
        if (_chartMaximized.value) {
          _chartHeightController.forward(
              from: _chartHeightAnimation.value);
        } else {
          _chartHeightController.reverse(
              from: _chartHeightAnimation.value);
        }
      },
    );

    nowStream = client.client.nowStream();
    upTimeStream = client.client.upTimeStream();
  }

  @override
  void dispose() {
    _chartHeightController.dispose();
    _chartMaximized.dispose();
    super.dispose();
  }

  m.DecoratedBox frame({required m.ThemeData theme, required m.Widget child}) {
    return m.DecoratedBox(
      decoration: m.BoxDecoration(
        color: theme.highlightColor,
        borderRadius: m.BorderRadius.circular(
          _frameBorderRadius,
        ),
      ),
      child: m.Padding(
        padding: const m.EdgeInsets.all(_frameInnerPadding),
        child: child,
      ),
    );
  }

  m.Align label(label) {
    return m.Align(
      alignment: m.Alignment.centerLeft,
      child: m.Text(
        label,
        style: const m.TextStyle(
          fontSize: 20.0,
        ),
      ),
    );
  }

  @override
  m.Widget build(m.BuildContext context) {
    super.build(context);
    final theme = m.Theme.of(context);
    return m.LayoutBuilder(
      builder: (context, constraints) {
        final coresFuture = client.client.cores();
        return m.Stack(
          children: [
            m.Positioned(
              top: 0.0,
              child: m.SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight * 0.5,
                child: m.Row(
                  children: [
                    m.Expanded(
                      flex: 1,
                      child: m.Column(
                        children: [
                          m.Expanded(
                            flex: 1,
                            child: m.Padding(
                              padding: const m.EdgeInsets.fromLTRB(
                                _frameOuterPadding,
                                _frameOuterPadding,
                                _frameOuterPadding * 0.5,
                                _frameOuterPadding * 0.5,
                              ),
                              child: frame(
                                theme: theme,
                                child: m.FutureBuilder<model.System>(
                                  future: client.client.system(),
                                  builder: (context, snapshot) {
                                    final hasData = snapshot.hasData;
                                    return m.Column(
                                      children: [
                                        m.Expanded(
                                          flex: 1,
                                          child: label(
                                              'Operating System: ${hasData ? snapshot.data!.osName + ' ' + snapshot.data!.osVersion : ''}'),
                                        ),
                                        m.Expanded(
                                          flex: 1,
                                          child: label(
                                              'Distribution: ${hasData ? snapshot.data!.hrName : ''}'),
                                        ),
                                        m.Expanded(
                                          flex: 1,
                                          child: label(
                                              'Hostname: ${hasData ? snapshot.data!.hostname : ''}'),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          m.Expanded(
                            flex: 1,
                            child: m.Padding(
                              padding: const m.EdgeInsets.fromLTRB(
                                _frameOuterPadding,
                                _frameOuterPadding * 0.5,
                                _frameOuterPadding * 0.5,
                                _frameOuterPadding,
                              ),
                              child: frame(
                                theme: theme,
                                child: m.Column(
                                  children: [
                                    m.Expanded(
                                      flex: 1,
                                      child: m.FutureBuilder<model.TimeStamp<model.QuickLook>>(
                                        future: client.client.quickLook(),
                                        builder: (context, snapshot) {
                                          return label(
                                            'CPU Name: ${snapshot.hasData ? snapshot.data!.model.cpuName : ''}',
                                          );
                                        },
                                      ),
                                    ),
                                    m.Expanded(
                                      flex: 1,
                                      child: m.FutureBuilder<model.Cores>(
                                        future: coresFuture,
                                        builder: (context, snapshot) => label(
                                          'Physical Cores: ${snapshot.hasData ? snapshot.data!.physical : ''}',
                                        ),
                                      ),
                                    ),
                                    m.Expanded(
                                      flex: 1,
                                      child: m.FutureBuilder<model.Cores>(
                                        future: coresFuture,
                                        builder: (context, snapshot) => label(
                                          'Logical Cores: ${snapshot.hasData ? snapshot.data!.logical : ''}',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    m.Expanded(
                      flex: 1,
                      child: m.Column(
                        children: [
                          m.Expanded(
                            flex: 2,
                            child: m.Padding(
                              padding: const m.EdgeInsets.fromLTRB(
                                _frameOuterPadding * 0.5,
                                _frameOuterPadding,
                                _frameOuterPadding,
                                _frameOuterPadding * 0.5,
                              ),
                              child: frame(
                                theme: theme,
                                child: m.Column(
                                  children: [
                                    m.Expanded(
                                      flex: 1,
                                      child: m.StreamBuilder<model.Now>(
                                        stream: nowStream,
                                        builder: (context, snapshot) => label(
                                            'Now: ${snapshot.connectionState == m.ConnectionState.active ? snapshot.data!.now : ''}'),
                                      ),
                                    ),
                                    m.Expanded(
                                      flex: 1,
                                      child: m.StreamBuilder<model.UpTime>(
                                        stream: upTimeStream,
                                        builder: (context, snapshot) => label(
                                            'Uptime: ${snapshot.connectionState == m.ConnectionState.active ? snapshot.data!.upTime : ''}'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          m.Expanded(
                            flex: 4,
                            child: m.Padding(
                              padding: const m.EdgeInsets.fromLTRB(
                                _frameOuterPadding * 0.5,
                                _frameOuterPadding * 0.5,
                                _frameOuterPadding,
                                _frameOuterPadding,
                              ),
                              child: frame(
                                theme: theme,
                                child: m.FutureBuilder<model.InternetProtocol>(
                                  future: client.client.internetProtocol(),
                                  builder: (context, snapshot) {
                                    final hasData = snapshot.hasData;
                                    return m.Column(
                                      children: [
                                        m.Expanded(
                                          flex: 1,
                                          child: label(
                                              'Address: ${hasData ? snapshot.data!.address : ''}'),
                                        ),
                                        m.Expanded(
                                          flex: 1,
                                          child: label(
                                              'Gateway: ${hasData ? snapshot.data!.gateway : ''}'),
                                        ),
                                        m.Expanded(
                                          flex: 1,
                                          child: label(
                                              'Mask: ${hasData ? snapshot.data!.mask : ''}'),
                                        ),
                                        m.Expanded(
                                          flex: 1,
                                          child: label(
                                              'Mask CIDR: ${hasData ? snapshot.data!.maskCidr : ''}'),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            m.Positioned(
              top: constraints.maxHeight * _chartTopAnimation.value,
              child: m.SizedBox(
                width: constraints.maxWidth,
                height:
                    constraints.maxHeight * _chartHeightAnimation.value,
                child: chart.Chart(
                  valueFunc: vlmb.builder.quickLookMap,
                  maximized: _chartMaximized,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
