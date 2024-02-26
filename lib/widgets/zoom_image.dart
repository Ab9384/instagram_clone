// import 'package:flutter/material.dart';

// class ZoomImage extends StatefulWidget {
//   final Widget image;
//   const ZoomImage({super.key, required this.image});

//   @override
//   State<ZoomImage> createState() => _ZoomImageState();
// }

// class _ZoomImageState extends State<ZoomImage>
//     with SingleTickerProviderStateMixin {
//   late TransformationController transformationController;
//   late AnimationController animationController;
//   late Animation<Matrix4> animation;
//   final double minScale = 0.5;
//   final double maxScale = 4.0;
//   double scale = 1.0;
//   OverlayEntry? overlayEntry;

//   @override
//   void initState() {
//     transformationController = TransformationController();
//     animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 200),
//     )
//       ..addListener(() {
//         transformationController.value = animation.value;
//       })
//       ..addStatusListener((status) {
//         if (status == AnimationStatus.completed) {
//           overlayEntry?.remove();
//           overlayEntry = null;
//         }
//       });
//     super.initState();
//   }

//   @override
//   void dispose() {
//     transformationController.dispose();
//     animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return buildImage(context);
//   }

//   Widget buildImage(BuildContext context) {
//     return Builder(builder: (context) {
//       return InteractiveViewer(
//           panEnabled: false,
//           minScale: minScale,
//           maxScale: maxScale,
//           onInteractionEnd: (details) {
//             reset();
//           },
//           onInteractionStart: (details) {
//             if (details.pointerCount < 2) return;
//             showOverlay(context);
//           },
//           onInteractionUpdate: (details) {
//             if (overlayEntry == null) return;
//             scale = details.scale;
//             overlayEntry?.markNeedsBuild();
//           },
//           clipBehavior: Clip.none,
//           child: widget.image);
//     });
//   }

//   void reset() {
//     animation = Matrix4Tween(
//       begin: transformationController.value,
//       end: Matrix4.identity(),
//     ).animate(CurvedAnimation(
//       parent: animationController,
//       curve: Curves.easeOut,
//     ));
//     animationController.forward(from: 0.0);
//   }

//   void showOverlay(BuildContext context) {
//     final renderBox = context.findRenderObject() as RenderBox;
//     final offset = renderBox.localToGlobal(Offset.zero);
//     final size = MediaQuery.of(context).size;
//     overlayEntry = OverlayEntry(
//       builder: (context) {
//         return Positioned(
//             width: size.width,
//             left: offset.dx,
//             top: offset.dy,
//             child: buildImage(context));
//       },
//     );
//     final overlay = Overlay.of(context);
//     overlay.insert(overlayEntry!);
//   }
// }
