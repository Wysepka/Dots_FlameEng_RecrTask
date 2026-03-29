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
}