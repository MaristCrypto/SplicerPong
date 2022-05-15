extends Control

const MAIN_MENU = 'main_menu'
const PAUSE = 'pause'
const GAME_OVER = 'game_over'

var _current_menu = MAIN_MENU

func _ready() -> void:
	Signals.connect("game_over", self, '_on_game_over')
	Signals.connect("game_start", self, '_on_game_start')
	Signals.connect("pause", self, '_on_pause')
	Signals.connect("resume", self, '_on_resume')
	change_menu(MAIN_MENU)

func change_menu(menu: String) -> void:
	_current_menu = menu
	for child in $menu_panel.get_children():
		(child as Control).visible = (child as Control).name == _current_menu + '_content'

func _on_game_over() -> void:
	visible = true
	change_menu(GAME_OVER)
	if GameManager.get_score()[0] > GameManager.get_score()[1]:
		$menu_panel/game_over_content/title.text = 'YOU WON'
	else:
		$menu_panel/game_over_content/title.text = 'YOU LOST'

func _on_game_start() -> void:
	visible = false

func _on_pause() -> void:
	visible = true
	change_menu(PAUSE)

func _on_resume() -> void:
	visible = false

# Called when start_game or restart_game buttons are pressed
func _on_start_game_pressed() -> void:
	Signals.emit_signal("game_start")

# Called when resume_game button is pressed
func _on_resume_game_pressed() -> void:
	Signals.emit_signal("resume")
