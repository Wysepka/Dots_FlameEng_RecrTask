import 'dart:math';
import 'package:dots_flameeng_recrtask/game/components/dot_sprite_component.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';

class PositionUtility{
  static Vector2 getCameraBoundsClampedPosition(Vector2 wantedPosition , Vector2 size , Anchor anchor , Rect cameraBounds) {
    final componentSize = size;

    // How much space this component occupies to the left/right/top/bottom
    // relative to its anchor-based position.
    final leftInset = componentSize.x * anchor.x;
    final rightInset = componentSize.x * (1.0 - anchor.x);
    final topInset = componentSize.y * anchor.y;
    final bottomInset = componentSize.y * (1.0 - anchor.y);

    final minX = cameraBounds.left + leftInset;
    final maxX = cameraBounds.right - rightInset;
    final minY = cameraBounds.top + topInset;
    final maxY = cameraBounds.bottom - bottomInset;

    return Vector2(
      wantedPosition.x.clamp(minX, maxX).toDouble(),
      wantedPosition.y.clamp(minY, maxY).toDouble(),
    );
  }

  static Vector2 mapPositionBetweenRects({
    required Vector2 currentPosition,
    required Rect fromRect,
    required Rect toRect,
  }) {
    final double fromWidth = fromRect.width == 0 ? 1.0 : fromRect.width;
    final double fromHeight = fromRect.height == 0 ? 1.0 : fromRect.height;

    final double percentX =
    ((currentPosition.x - fromRect.left) / fromWidth).clamp(0.0, 1.0);
    final double percentY =
    ((currentPosition.y - fromRect.top) / fromHeight).clamp(0.0, 1.0);

    return Vector2(
      toRect.left + toRect.width * percentX,
      toRect.top + toRect.height * percentY,
    );
  }

  static Vector2 clampToVisibleRect(Vector2 candidate, Rect rect , Vector2 size) {
    final double halfW = size.x / 2;
    final double halfH = size.y / 2;

    return Vector2(
      candidate.x.clamp(rect.left + halfW, rect.right - halfW).toDouble(),
      candidate.y.clamp(rect.top + halfH, rect.bottom - halfH).toDouble(),
    );
  }

  static final Random _random = Random();

  /// Generates a random safe CENTER position for a new dot.
  ///
  /// [spawnAreaPosition] - top-left corner of allowed spawn rectangle
  /// [spawnAreaSize]     - size of allowed spawn rectangle
  /// [newDotSize]        - size of the dot you want to spawn
  /// [existingDots]      - dots already present in the world
  /// [safeCircularPosition] - center of player safe zone
  /// [safeCircularSize]     - diameter of player safe zone circle
  ///
  /// Returns center position for the new dot.
  static Vector2 calculateRandomSafePosition({
    required Vector2 spawnAreaPosition,
    required Vector2 spawnAreaSize,
    required Vector2 newDotSize,
    required List<DotTransform> existingDots,
    required Vector2 safeCircularPosition,
    required double safeCircularSize,
    int maxAttempts = 300,
    double extraPadding = 0.0,
  }) {
    final double newDotRadius = newDotSize.x * 0.5;
    final double playerSafeRadius = safeCircularSize * 0.5;

    final double minX = spawnAreaPosition.x + newDotRadius;
    final double maxX = spawnAreaPosition.x + spawnAreaSize.x - newDotRadius;
    final double minY = spawnAreaPosition.y + newDotRadius;
    final double maxY = spawnAreaPosition.y + spawnAreaSize.y - newDotRadius;

    if (minX > maxX || minY > maxY) {
      throw StateError(
        'Spawn area is too small for dot of size $newDotSize.',
      );
    }

    for (int i = 0; i < maxAttempts; i++) {
      final Vector2 candidate = Vector2(
        minX + _random.nextDouble() * (maxX - minX),
        minY + _random.nextDouble() * (maxY - minY),
      );

      if (_isInsidePlayerSafeZone(
        candidate: candidate,
        candidateRadius: newDotRadius,
        playerCenter: safeCircularPosition,
        playerSafeRadius: playerSafeRadius,
        extraPadding: extraPadding,
      )) {
        continue;
      }

      if (_overlapsExistingDots(
        candidate: candidate,
        candidateRadius: newDotRadius,
        existingDots: existingDots,
        extraPadding: extraPadding,
      )) {
        continue;
      }

      return candidate;
    }

    throw StateError(
      'Could not find safe random position after $maxAttempts attempts.',
    );
  }

  static bool _isInsidePlayerSafeZone({
    required Vector2 candidate,
    required double candidateRadius,
    required Vector2 playerCenter,
    required double playerSafeRadius,
    required double extraPadding,
  }) {
    final double minDistance =
        candidateRadius + playerSafeRadius + extraPadding;

    return candidate.distanceTo(playerCenter) < minDistance;
  }

  static bool _overlapsExistingDots({
    required Vector2 candidate,
    required double candidateRadius,
    required List<DotTransform> existingDots,
    required double extraPadding,
  }) {
    for (final dot in existingDots) {
      final double minDistance =
          candidateRadius + dot.radius + extraPadding;

      if (candidate.distanceTo(dot.position) < minDistance) {
        return true;
      }
    }

    return false;
  }
}