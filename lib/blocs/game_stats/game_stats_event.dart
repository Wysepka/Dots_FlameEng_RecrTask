abstract class GameStatsEvent{}

class PlayerHealthDecrementEvent extends GameStatsEvent{
  final int livesCount;

  PlayerHealthDecrementEvent({required this.livesCount});
}
class PlayerScoreUpEvent extends GameStatsEvent{
  final int scoreCount;

  PlayerScoreUpEvent({required this.scoreCount});
}
class ResetGameStatsEvent extends GameStatsEvent{}