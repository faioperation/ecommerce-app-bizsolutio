import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// A custom widget that renders a logo with a floating (hovering) animation
/// and a soft, pulsing multi-layered halo/glow effect in the background.
class GlowingFloatingLogo extends StatefulWidget {
  final String imagePath;
  final double size;
  final Duration animationDuration;

  const GlowingFloatingLogo({
    super.key,
    required this.imagePath,
    this.size = 120.0,
    this.animationDuration = const Duration(milliseconds: 2500),
  });

  @override
  State<GlowingFloatingLogo> createState() => _GlowingFloatingLogoState();
}

class _GlowingFloatingLogoState extends State<GlowingFloatingLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  
  // Animation for the vertical bobbing / floating movement
  late final Animation<Offset> _floatAnimation;
  
  // Animations for the pulsing background glow (scale and opacity)
  late final Animation<double> _glowScaleAnimation;
  late final Animation<double> _glowOpacityAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    // Using a smooth easeInOut curve for organic, liquid floating motion
    final CurvedAnimation curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    // Float animation moves the logo 8 pixels up and down
    _floatAnimation = Tween<Offset>(
      begin: const Offset(0, -6),
      end: const Offset(0, 6),
    ).animate(curvedAnimation);

    // Pulse the halo scale between 0.85 and 1.15 times its base size
    _glowScaleAnimation = Tween<double>(
      begin: 0.85,
      end: 1.15,
    ).animate(curvedAnimation);

    // Pulse the halo opacity for a more dramatic but soft glow
    _glowOpacityAnimation = Tween<double>(
      begin: 0.40,
      end: 0.75,
    ).animate(curvedAnimation);

    // Loop the animation infinitely, reversing direction at each limit
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // The glow diameter is proportional to the logo size
    final double glowSize = widget.size * 1.8;

    return SizedBox(
      width: glowSize,
      height: glowSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. Soft Glow / Halo Layer (at the back)
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: _glowOpacityAnimation.value,
                child: Transform.scale(
                  scale: _glowScaleAnimation.value,
                  child: Container(
                    width: glowSize,
                    height: glowSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.accentPink.withValues(alpha: 0.35),
                          AppColors.primary.withValues(alpha: 0.20),
                          AppColors.liveBadge.withValues(alpha: 0.10),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.45, 0.75, 1.0],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          
          // 2. Interactive Floating Logo Layer (in the front)
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.translate(
                offset: _floatAnimation.value,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      // Subtly project a small soft shadow directly beneath the logo to ground it
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        blurRadius: 15,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Image.asset(
                    widget.imagePath,
                    height: widget.size,
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
