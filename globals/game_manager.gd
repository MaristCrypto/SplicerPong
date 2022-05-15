extends Node

const WINNING_SCORE = 10

enum Player {
	PLAYER_LEFT = 0, 
	PLAYER_RIGHT = 1
}

enum GameState {
	GAME_OVER,
	PLAYING,
	PAUSED
}

var _score := [0, 0]
var _game_state = GameState.GAME_OVER

func _ready() -> void:
	pause_mode = Node.PAUSE_MODE_PROCESS
	get_tree().paused = true
	Signals.connect("game_start", self, '_on_game_start')
	Signals.connect("pause", self, '_on_pause')
	Signals.connect("resume", self, '_on_resume')
	Signals.connect("player_scored", self, '_on_player_scored')

func _on_game_start() -> void:
	_game_state = GameState.PLAYING
	_score = [0, 0]
	get_tree().paused = false

func _on_player_scored(player: int) -> void:
	assert(player in Player.values(), 'Invalid player identifier provided')
	_score[player] += 1
	print(_score)
	Signals.emit_signal("score_updated", _score)
	if _score[player] == WINNING_SCORE:
		game_over()

func get_score() -> Array:
	return _score

func game_over() -> void:
	_game_state = GameState.GAME_OVER
	get_tree().paused = true
	Signals.emit_signal("game_over")

func _on_pause() -> void:
	_game_state = GameState.PAUSED
	get_tree().paused = true

func _on_resume() -> void:
	_game_state = GameState.PLAYING
	get_tree().paused = false

func _unhandled_key_input(event: InputEventKey) -> void:
	if Input.is_action_just_pressed("pause"):
		match _game_state:
			GameState.PLAYING:
				Signals.emit_signal("pause")
			GameState.PAUSED:
				Signals.emit_signal("resume")
