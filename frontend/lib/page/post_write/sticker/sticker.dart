import 'package:flutter/material.dart';

class Sticker extends StatefulWidget {
  final String adress;
  final showBlackhole;
  final hideBlackhole;
  final checkBlackhole;
  final GlobalKey iconkey;
  // final changeOrder;

  const Sticker({
    Key? key,
    required this.showBlackhole,
    required this.hideBlackhole,
    required this.checkBlackhole,
    required this.iconkey,
    required this.adress,
    // required this.changeOrder,
  }) : super(key: key);

  @override
  State<Sticker> createState() => _StickerState();
}

class _StickerState extends State<Sticker> {
  double _scale = 1.0;
  double _previousScale = 1.0;
  Offset _previousOffset = Offset.zero;
  Offset _previousFocalPoint = Offset.zero;
  Offset _offset = Offset.zero;
  bool _isPanning = false;
  double _panSpeed = 1.0;
  double _angle = 0.0;
  double _previousAngle = 0.0;
  final bool _isIconOverlapped = false;
  late Rect blackholeRect = Rect.zero;
  bool isOverlapping = false;
  bool overlappedBefore = false;
  bool canWidget = true;

  void hideWidget() {
    setState(() {
      canWidget = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: canWidget,
      child: Positioned(
        // key: widget.globalkey,
        left: 0,
        right: 0,
        top: 0,
        bottom: 0,
        child: GestureDetector(
          onScaleStart: (details) {
            _previousScale = _scale;
            _previousFocalPoint = details.focalPoint;
            _isPanning = details.pointerCount == 1;
            widget.showBlackhole();
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final RenderBox? renderBox = widget.iconkey.currentContext
                  ?.findRenderObject() as RenderBox?;
              if (renderBox != null) {
                final Rect rect =
                    renderBox.localToGlobal(Offset.zero) & renderBox.size;

                setState(() {
                  blackholeRect = rect;
                });
              }
            });
            // widget.changeOrder(widget.index);
          },
          onScaleUpdate: (details) {
            if (_isPanning) {
              // pan
              setState(() {
                final dx = details.focalPointDelta.dx;
                final dy = details.focalPointDelta.dy;
                _offset += Offset(dx * _panSpeed, dy * _panSpeed);

                final stickerRect = Rect.fromCenter(
                  center: details.focalPoint,
                  width: 1,
                  height: 1,
                );

                final intersection = blackholeRect.intersect(stickerRect);
                isOverlapping =
                    intersection.width > 0 && intersection.height > 0;
                if (isOverlapping) {
                  widget.checkBlackhole(true);
                  overlappedBefore = true;
                } else if (overlappedBefore && !isOverlapping) {
                  widget.checkBlackhole(false);
                  overlappedBefore = false;
                }
                //else {
                //   widget.checkBlackhole(false);
                // }
              });
            } else {
              setState(() {
                _angle = _previousAngle + details.rotation;
              });
              // scale
              setState(() {
                _scale = (_previousScale * details.scale).clamp(0.5, 1.5);
                _panSpeed = 1.0 / _scale;
              });

              Offset focalPointDelta = details.focalPoint - _previousFocalPoint;
              Offset translationDelta =
                  focalPointDelta * (_scale / _previousScale - 1.0);
              setState(() {
                _offset = _previousOffset + translationDelta;
              });
            }
          },
          onScaleEnd: (details) {
            widget.checkBlackhole(false);
            widget.hideBlackhole();
            _previousOffset = _offset;
            _previousAngle = _angle;
            if (isOverlapping) {
              hideWidget();
            }
          },
          child: Center(
            child: Transform.scale(
              scale: _scale,
              child: Transform.translate(
                offset: _offset,
                child: Transform.rotate(
                  angle: _angle,
                  child: Image.asset(
                    widget.adress,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
