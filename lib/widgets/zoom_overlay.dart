import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vector_math/vector_math_64.dart';

class _TransformWidget extends StatefulWidget {
  const _TransformWidget({
    Key? key,
    required this.child,
    required this.matrix,
  }) : super(key: key);

  final Widget child;
  final Matrix4 matrix;

  @override
  _TransformWidgetState createState() => _TransformWidgetState();
}

class _TransformWidgetState extends State<_TransformWidget> {
  Matrix4? _matrix = Matrix4.identity();

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: widget.matrix * _matrix,
      child: widget.child,
    );
  }

  void setMatrix(Matrix4? matrix) {
    setState(() {
      _matrix = matrix;
    });
  }
}

class ZoomOverlay extends StatefulWidget {
  const ZoomOverlay({
    Key? key,
    this.twoTouchOnly = false,
    required this.child,
    this.minScale,
    this.maxScale,
    this.animationDuration = const Duration(milliseconds: 100),
    this.animationCurve = Curves.fastOutSlowIn,
    this.modalBarrierColor,
    this.onScaleStart,
    this.onScaleStop,
  }) : super(key: key);
  final Widget child;
  final double? minScale;
  final double? maxScale;
  final bool twoTouchOnly;
  final Duration animationDuration;
  final Curve animationCurve;
  final Color? modalBarrierColor;
  final VoidCallback? onScaleStart;
  final VoidCallback? onScaleStop;

  @override
  // ignore: library_private_types_in_public_api
  _ZoomOverlayState createState() => _ZoomOverlayState();
}

class _ZoomOverlayState extends State<ZoomOverlay>
    with TickerProviderStateMixin {
  Matrix4? _matrix = Matrix4.identity();
  late Offset _startFocalPoint;
  late Animation<Matrix4> _animationReset;
  late AnimationController _controllerReset;
  OverlayEntry? _overlayEntry;
  bool _isZooming = false;
  int _touchCount = 0;
  Matrix4 _transformMatrix = Matrix4.identity();

  final _transformWidget = GlobalKey<_TransformWidgetState>();

  @override
  void initState() {
    super.initState();
    _controllerReset = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _controllerReset
      ..addListener(() {
        _transformWidget.currentState?.setMatrix(_animationReset.value);
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) hide();
      });
  }

  @override
  void dispose() {
    _controllerReset.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _incrementEnter,
      onPointerUp: _incrementExit,
      onPointerCancel: _incrementExit,
      child: GestureDetector(
        onScaleStart: onScaleStart,
        onScaleUpdate: onScaleUpdate,
        onScaleEnd: onScaleEnd,
        child: Opacity(opacity: _isZooming ? 0 : 1, child: widget.child),
      ),
    );
  }

  void onScaleStart(ScaleStartDetails details) {
    //Dont start the effect if the image havent reset complete.
    if (_controllerReset.isAnimating) return;
    if (widget.twoTouchOnly && _touchCount < 2) return;

    // call start callback before everything else
    widget.onScaleStart?.call();
    _startFocalPoint = details.focalPoint;

    _matrix = Matrix4.identity();

    // create an matrix of where the image is on the screen for the overlay
    final renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    _transformMatrix = Matrix4.translation(
      Vector3(position.dx, position.dy, 0),
    );

    show();

    setState(() {
      _isZooming = true;
    });
  }

  void onScaleUpdate(ScaleUpdateDetails details) {
    if (!_isZooming || _controllerReset.isAnimating) return;

    final translationDelta = details.focalPoint - _startFocalPoint;

    // Calculate translation with a smoother adjustment
    final translate = Matrix4.translation(
      Vector3(translationDelta.dx, translationDelta.dy, 0),
    );

    final renderBox = context.findRenderObject() as RenderBox;
    final focalPoint = renderBox.globalToLocal(
      details.focalPoint - translationDelta,
    );

    var scaleBy = details.scale;
    if (widget.minScale != null && scaleBy < widget.minScale!) {
      scaleBy = widget.minScale ?? 0;
    }

    if (widget.maxScale != null && scaleBy > widget.maxScale!) {
      scaleBy = widget.maxScale ?? 0;
    }

    // Calculate scaling with a smoother adjustment
    final dx = (1 - scaleBy) * focalPoint.dx;
    final dy = (1 - scaleBy) * focalPoint.dy;
    final scale = Matrix4(
      scaleBy,
      0,
      0,
      0,
      0,
      scaleBy,
      0,
      0,
      0,
      0,
      1,
      0,
      dx,
      dy,
      0,
      1,
    );

    _matrix = translate * scale;

    if (_transformWidget.currentState != null) {
      _transformWidget.currentState!.setMatrix(_matrix);
    }
  }

  void onScaleEnd(ScaleEndDetails details) {
    if (!_isZooming || _controllerReset.isAnimating) return;
    _animationReset = Matrix4Tween(
      begin: _matrix,
      end: Matrix4.identity(),
    ).animate(
      CurvedAnimation(
        parent: _controllerReset,
        curve: widget.animationCurve,
      ),
    );
    _controllerReset
      ..reset()
      ..forward();

    // call end callback function when scale ends
    widget.onScaleStop?.call();
  }

  Widget _build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          ModalBarrier(
            color: widget.modalBarrierColor,
          ),
          _TransformWidget(
            key: _transformWidget,
            matrix: _transformMatrix,
            child: widget.child,
          )
        ],
      ),
    );
  }

  Future<void> show() async {
    if (!_isZooming) {
      final overlayState = Overlay.of(context);
      _overlayEntry = OverlayEntry(builder: _build);
      overlayState.insert(_overlayEntry!);
    }
  }

  Future<void> hide() async {
    setState(() {
      _isZooming = false;
    });

    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _incrementEnter(PointerEvent details) => _touchCount++;

  void _incrementExit(PointerEvent details) => _touchCount--;
}
