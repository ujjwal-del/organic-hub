import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';

class HeartbeatTeaCupAnimation extends StatefulWidget {
  const HeartbeatTeaCupAnimation({super.key});

  @override
  State<HeartbeatTeaCupAnimation> createState() => HeartbeatTeaCupAnimationState();
}

class HeartbeatTeaCupAnimationState extends State<HeartbeatTeaCupAnimation>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late Animation<double> _scale;
  late Animation<double> _opacity;

  void startFadeOut(VoidCallback onDone) {
    _scaleController.stop();
    _fadeController.reverse().whenComplete(onDone);
  }

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    )..repeat(reverse: true);

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
      value: 1,
    );

    _scale = Tween<double>(begin: .9, end: 1.08).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
    _opacity = CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: FadeTransition(
        opacity: _opacity,
        child: Stack(children: [
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.05)),
          ),
          Center(
            child: AnimatedBuilder(
              animation: _scale,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scale.value,
                  child: Image.asset(Images.teaPop, width: 160, height: 160, fit: BoxFit.contain),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}



