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

  /// Calculates bounced velocity for collision against another actor.
  ///
  /// Assumptions:
  /// - [selfPosition] and [otherPosition] are component centers
  /// - sizes are used as simple circular approximation
  /// - [velocity] is the current velocity of "self"
  /// - [otherVelocity] is optional; if omitted, other actor is treated as static
  ///
  /// The collision normal points from the other actor toward self, so the
  /// returned velocity is the bounced velocity of self.
  static Vector2 calculateBounceVelocityFromActor({
    required Vector2 selfPosition,
    required Vector2 selfSize,
    required Vector2 otherPosition,
    required Vector2 otherSize,
    required Vector2 velocity,
    Vector2? otherVelocity,
    double restitution = 1.0,
    bool onlyWhenApproaching = true,
  }) {
    final Vector2? normal = _calculateActorCollisionNormal(
      selfPosition: selfPosition,
      otherPosition: otherPosition,
    );

    if (normal == null) {
      return velocity.clone();
    }

    final Vector2 relativeVelocity =
        velocity - (otherVelocity ?? Vector2.zero());

    final double approachSpeed = relativeVelocity.dot(normal);

    // If > 0, self is already moving away from the collision surface
    // relative to the other actor, so do not bounce again.
    if (onlyWhenApproaching && approachSpeed >= 0) {
      return velocity.clone();
    }

    final Vector2 reflectedRelative = reflect(
      velocity: relativeVelocity,
      normal: normal,
      restitution: restitution,
    );

    return reflectedRelative + (otherVelocity ?? Vector2.zero());
  }

  /// Resolves overlap by pushing self outside the other actor.
  ///
  /// Uses circular approximation based on half of the larger size dimension.
  /// Useful after collision to reduce sticking / repeated collision callbacks.
  static Vector2 separateOverlappingActors({
    required Vector2 selfPosition,
    required Vector2 selfSize,
    required Vector2 otherPosition,
    required Vector2 otherSize,
    double extraSeparation = 0.0,
  }) {
    final Vector2 delta = selfPosition - otherPosition;
    final double distance = delta.length;

    final double selfRadius = _approxRadius(selfSize);
    final double otherRadius = _approxRadius(otherSize);
    final double minDistance = selfRadius + otherRadius + extraSeparation;

    Vector2 normal;
    if (distance == 0) {
      normal = Vector2(1, 0);
    } else {
      normal = delta / distance;
    }

    if (distance >= minDistance) {
      return selfPosition.clone();
    }

    return otherPosition + normal * minDistance;
  }

  /// Returns collision normal from other actor toward self actor.
  static Vector2? _calculateActorCollisionNormal({
    required Vector2 selfPosition,
    required Vector2 otherPosition,
  }) {
    final Vector2 delta = selfPosition - otherPosition;

    if (delta.length2 == 0) {
      return null;
    }

    return delta.normalized();
  }

  static double _approxRadius(Vector2 size) {
    return (size.x > size.y ? size.x : size.y) / 2;
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
  //This comment is for above
  //(0.5,0.5) - (-1,0) * (1+1) * -0.5 = (0.5 , 0.5) - (-1 , 0) * -1 = (0.5 , 0.5) - 1 = (-0.5 , -0.5)

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