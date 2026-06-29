import 'dart:math' as math;
import 'package:flutter/material.dart';

class LiveBackground extends StatefulWidget {
  final Widget child;
  final bool isDark;

  const LiveBackground({
    super.key,
    required this.child,
    this.isDark = false,
  });

  @override
  State<LiveBackground> createState() => _LiveBackgroundState();
}

class _LiveBackgroundState extends State<LiveBackground> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<_Particle> _particles = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();

    // Initialize floating gold particles
    for (int i = 0; i < 25; i++) {
      _particles.add(
        _Particle(
          x: _random.nextDouble(),
          y: _random.nextDouble(),
          size: _random.nextDouble() * 20 + 8,
          speedY: _random.nextDouble() * 0.03 + 0.01,
          speedX: (_random.nextDouble() - 0.5) * 0.02,
          opacity: _random.nextDouble() * 0.08 + 0.03,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Live animated canvas background
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            // Update particles position on each frame tick
            for (var particle in _particles) {
              particle.y -= particle.speedY * 0.01;
              particle.x += particle.speedX * 0.01;

              // Reset when floating off top or sides
              if (particle.y < -0.1) {
                particle.y = 1.1;
                particle.x = _random.nextDouble();
              }
              if (particle.x < -0.1 || particle.x > 1.1) {
                particle.x = _random.nextDouble();
              }
            }

            return CustomPaint(
              painter: _ParticlePainter(
                particles: _particles,
                isDark: widget.isDark,
              ),
              child: Container(),
            );
          },
        ),
        // Child content overlay
        widget.child,
      ],
    );
  }
}

class _Particle {
  double x;
  double y;
  final double size;
  final double speedY;
  final double speedX;
  final double opacity;

  _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speedY,
    required this.speedX,
    required this.opacity,
  });
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final bool isDark;

  _ParticlePainter({required this.particles, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // 1. Draw rich ambient background gradient
    final Paint bgPaint = Paint();
    if (isDark) {
      bgPaint.shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: const [
          Color(0xFF1E1611), // Deep rich chocolate
          Color(0xFF140F0B), // Near black
        ],
      ).createShader(rect);
    } else {
      bgPaint.shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: const [
          Color(0xFFFAF7F2), // Antique Cream
          Color(0xFFF3EDE2), // Soft Warm Cream
        ],
      ).createShader(rect);
    }
    canvas.drawRect(rect, bgPaint);

    // 2. Draw drifting golden glowing bokeh particles
    for (var particle in particles) {
      final center = Offset(particle.x * size.width, particle.y * size.height);
      final Color goldColor = isDark 
          ? const Color(0xFFE89C31).withOpacity(particle.opacity)
          : const Color(0xFFC5A880).withOpacity(particle.opacity);

      final Paint particlePaint = Paint()
        ..color = goldColor
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, particle.size * 0.4);

      canvas.drawCircle(center, particle.size, particlePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}
