abstract class GameLifecycleEvent{}

class MenuGameEvent extends GameLifecycleEvent{}
class StartGameEvent extends GameLifecycleEvent{}
class EndGameEvent extends GameLifecycleEvent{}
class RestartGameEvent extends GameLifecycleEvent{}