import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:flutter/material.dart' as m;

import 'value_list_map.dart' as vlm;
import 'value_list_map_builder.dart' as vlmb;

part 'chart.g.dart';

abstract class Window implements Built<Window, WindowBuilder> {
  static Serializer<Window> get serializer => _$windowSerializer;

  int get index;
  int get width;

  Window._();
  factory Window([
    void Function(WindowBuilder) updates,
  ]) = _$Window;
}

abstract class PreviousNextPair<T>
    implements Built<PreviousNextPair<T>, PreviousNextPairBuilder<T>> {
  static Serializer<PreviousNextPair<Object?>> get serializer =>
      _$previousNextPairSerializer;

  T get previous;
  T get next;

  factory PreviousNextPair.push(
      {required T next, required PreviousNextPair<T> currentPair}) {
    return PreviousNextPair(
      (b) => b
        ..previous = currentPair.next
        ..next = next,
    );
  }

  PreviousNextPair._();

  factory PreviousNextPair([
    void Function(PreviousNextPairBuilder<T>) updates,
  ]) = _$PreviousNextPair<T>;
}

class Painter extends m.CustomPainter {
  @override
  void paint(m.Canvas canvas, m.Size size) {
    canvas.drawRect(
        m.Rect.fromLTRB(
          0.0,
          0.0,
          size.width,
          size.height,
        ),
        m.Paint()..color = m.Colors.red);

    canvas.drawRect(
        m.Rect.fromLTRB(
          0.0 + 1.0,
          0.0 + 1.0,
          size.width - 1.0,
          size.height - 1.0,
        ),
        m.Paint()..color = m.Colors.grey);
  }

  @override
  bool shouldRepaint(covariant m.CustomPainter oldDelegate) {
    return true;
  }

  Painter({required m.Listenable repaint}) : super(repaint: repaint);
}

enum ChartType {
  line,
  filled,
  bar,
}

class _ChartState extends m.State<Chart> with m.TickerProviderStateMixin {
  static const double _overlayWidgetInset = 8.0;

  final m.FocusNode _focusNode = m.FocusNode();

  final m.ValueNotifier<double> _painterWidth = m.ValueNotifier(0.0);
  final m.ValueNotifier<double> _painterHeight = m.ValueNotifier(0.0);

  final m.ValueNotifier<ChartType> _currentChartType =
      m.ValueNotifier(ChartType.line);

  final m.ValueNotifier<bool> _showHistory = m.ValueNotifier(false);

  m.OutlinedButton buildChartTypeButton({
    required ChartType type,
    required m.IconData icon,
    required m.ThemeData theme,
  }) {
    return m.OutlinedButton(
      onPressed: _currentChartType.value == type
          ? null
          : () {
              _currentChartType.value = type;
            },
      style: m.ButtonStyle(
        backgroundColor: m.MaterialStateProperty.resolveWith(
          (
            _states,
          ) {
            return _currentChartType.value == type
                ? theme.backgroundColor.withOpacity(0.25)
                : m.Colors.transparent;
          },
        ),
      ),
      child: m.Icon(
        icon,
      ),
    );
  }

  @override
  m.Widget build(m.BuildContext context) {
    final theme = m.Theme.of(context);
    return m.Stack(
      children: [
        m.Positioned.fill(
          child: m.RepaintBoundary(
            child: m.ClipRect(
              child: m.LayoutBuilder(
                builder: (context, constraints) {
                  _painterWidth.value = constraints.maxWidth;
                  _painterHeight.value = constraints.maxHeight;
                  return m.Listener(
                    onPointerDown: (event) {},
                    onPointerUp: (event) {},
                    onPointerMove: (event) {
                      if (!_focusNode.hasFocus) {
                        _focusNode.requestFocus();
                      }
                    },
                    child: m.RawKeyboardListener(
                      focusNode: _focusNode,
                      onKey: (event) => (event) {},
                      child: m.CustomPaint(
                        size:
                            m.Size(constraints.maxWidth, constraints.maxHeight),
                        isComplex: true,
                        painter: Painter(
                          repaint: m.Listenable.merge(
                            [
                              _painterWidth,
                              _painterHeight,
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        m.Positioned(
          top: _overlayWidgetInset,
          right: _overlayWidgetInset,
          child: m.Row(
            children: [
              if (widget._historyFunc != null)
                m.Row(
                  children: [
                    m.OutlinedButton(
                      onPressed: () {
                        _showHistory.value = !_showHistory.value;
                      },
                      style: m.ButtonStyle(
                        backgroundColor: m.MaterialStateProperty.resolveWith(
                          (_states) {
                            return _showHistory.value
                                ? theme.backgroundColor.withOpacity(0.25)
                                : m.Colors.transparent;
                          },
                        ),
                      ),
                      child: const m.Icon(
                        m.Icons.history,
                      ),
                    ),
                    const m.SizedBox(
                      width: 16.0,
                    ),
                  ],
                ),
              m.ValueListenableBuilder<ChartType>(
                valueListenable: _currentChartType,
                builder: (_context, currentChartType, _child) => m.Row(
                  children: [
                    buildChartTypeButton(
                      type: ChartType.line,
                      icon: m.Icons.stacked_line_chart,
                      theme: theme,
                    ),
                    buildChartTypeButton(
                      type: ChartType.filled,
                      icon: m.Icons.multiline_chart,
                      theme: theme,
                    ),
                    buildChartTypeButton(
                      type: ChartType.bar,
                      icon: m.Icons.bar_chart,
                      theme: theme,
                    ),
                  ],
                ),
              ),
              if (widget._maximized != null)
                m.Row(
                  children: [
                    const m.SizedBox(
                      width: 16.0,
                    ),
                    m.OutlinedButton(
                      onPressed: () {
                        widget._maximized!.value = !widget._maximized!.value;
                      },
                      style: m.ButtonStyle(
                        backgroundColor: m.MaterialStateProperty.resolveWith(
                          (_states) {
                            return widget._maximized!.value
                                ? theme.backgroundColor.withOpacity(0.25)
                                : m.Colors.transparent;
                          },
                        ),
                      ),
                      child: m.ValueListenableBuilder(
                        valueListenable: widget._maximized!,
                        builder: (_context, bool maximized, _child) {
                          return m.Icon(
                              maximized ? m.Icons.maximize : m.Icons.minimize);
                        },
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}

typedef HistoryFunc = Future<vlm.FixedLengthMapOfLists> Function(
    {required Window window, bool reset});

class Chart extends m.StatefulWidget {
  final vlmb.ListFunc<vlm.MapBase> _valueFunc;
  final m.ValueNotifier<bool>? _maximized;
  final HistoryFunc? _historyFunc;

  @override
  m.State<m.StatefulWidget> createState() => _ChartState();

  const Chart({
    m.Key? key,
    required vlmb.ListFunc<vlm.MapBase> valueFunc,
    m.ValueNotifier<bool>? maximized,
    HistoryFunc? historyFunc,
  })  : _valueFunc = valueFunc,
        _maximized = maximized,
        _historyFunc = historyFunc,
        super(key: key);
}
