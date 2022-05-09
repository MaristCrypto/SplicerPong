# Paddle controller following player's mouse
extends BaseController
class_name PlayerController

# Keep the reference to the viewport so that we can query mouse position
var _viewport : Viewport

func _init(_paddle: Node).(_paddle):
	_viewport = _paddle.get_viewport()

func get_desired_position_y() -> float:
	return _viewport.get_mouse_position().y
