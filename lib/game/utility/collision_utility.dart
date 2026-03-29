import 'package:flame/components.dart';
import 'package:flame/extensions.dart';

class CollisionUtility{
  /// Reflects [velocity] against the screen edge normal inferred from [position]
  /// and [componentSize] inside [screenRect].
  ///
  /// [position] is assumed to be the component's center position.
  /// [componentSize] is the visual/collision size of the component.
  ///
  /// Returns the new bounced velocity.
  static Vector2 calculateBounceVelocityFromScreenHitbox({
    required Vector2 position,
    required Vector2 componentSize,
    required Vector2 velocity,
    required Rect screenRect,
    double restitution = 1.0,
  }) {
    final Vector2? normal = _calculateScreenNormal(
      position: position,
      componentSize: componentSize,
      screenRect: screenRect,
    );

    if (normal == null) {
      return velocity.clone();
    }

    return reflect(
      velocity: velocity,
      normal: normal,
      restitution: restitution,
    );
  }

  /// Standard vector reflection:
  /// R = V - (1 + e) * dot(V, N) * N
  ///
  /// where:
  /// - V is incoming velocity
  /// - N is normalized collision normal
  /// - e is restitution (1.0 = perfect bounce, 0.0 = no bounce)
  static Vector2 reflect({
    required Vector2 velocity,
    required Vector2 normal,
    double restitution = 1.0,
  }) {
    final Vector2 n = normal.normalized();
    final double dot = velocity.dot(n);

    return velocity - n * ((1 + restitution) * dot);
  }

  /// Returns wall normal for the screen edge currently penetrated/touched.
  ///
  /// Normals point inward from the wall:
  /// - left wall   => ( 1, 0)
  /// - right wall  => (-1, 0)
  /// - top wall    => ( 0, 1)
  /// - bottom wall => ( 0,-1)
  static Vector2? _calculateScreenNormal({
    required Vector2 position,
    required Vector2 componentSize,
    required Rect screenRect,
  }) {
    final double halfW = componentSize.x / 2;
    final double halfH = componentSize.y / 2;

    final double left = position.x - halfW;
    final double right = position.x + halfW;
    final double top = position.y - halfH;
    final double bottom = position.y + halfH;

    final bool hitLeft = left <= screenRect.left;
    final bool hitRight = right >= screenRect.right;
    final bool hitTop = top <= screenRect.top;
    final bool hitBottom = bottom >= screenRect.bottom;

    // Corner handling: combine normals.
    if ((hitLeft || hitRight) && (hitTop || hitBottom)) {
      final Vector2 cornerNormal = Vector2.zero();

      if (hitLeft) cornerNormal.x += 1;
      if (hitRight) cornerNormal.x -= 1;
      if (hitTop) cornerNormal.y += 1;
      if (hitBottom) cornerNormal.y -= 1;

      if (cornerNormal.length2 > 0) {
        return cornerNormal.normalized();
      }
    }

    if (hitLeft) return Vector2(1, 0);
    if (hitRight) return Vector2(-1, 0);
    if (hitTop) return Vector2(0, 1);
    if (hitBottom) return Vector2(0, -1);

    return null;
  }

  /// Optional helper to move the component fully back inside the screen bounds
  /// after collision, reducing repeated collision/sticking.
  static Vector2 clampPositionInsideScreen({
    required Vector2 position,
    required Vector2 componentSize,
    required Rect screenRect,
  }) {
    final double halfW = componentSize.x / 2;
    final double halfH = componentSize.y / 2;

    return Vector2(
      position.x.clamp(screenRect.left + halfW, screenRect.right - halfW).toDouble(),
      position.y.clamp(screenRect.top + halfH, screenRect.bottom - halfH).toDouble(),
    );
  }
}