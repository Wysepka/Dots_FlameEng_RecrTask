class GameConstants{

  //Player
  static const double playerStartSize = 30;
  //this is a variable which defines safe area in which enemy dots will not spawn
  // safe area calculates like playerDotSize * spawnPositionPlayerSafeAreaMultiplier
  static const double spawnPositionPlayerSafeAreaMultiplier = 3;
  static const int playerStartLivesCount = 3;

  //Collectible
  static const double collectibleSpawnInterval = 2;
  static const double collectibleStartSize = 30;
  static const double collectibleMovingSpeed = 50;

  //Enemy
  static const double enemyStartSize = 30;
  static const double enemyMovingSpeed = 50;
  static const double enemySpawnInterval = 2;
}