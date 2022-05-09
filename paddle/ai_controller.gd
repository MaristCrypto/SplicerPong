# Very simple AI controller that only follows the current ball Y position.
extends BaseController
class_name AIController

var _ball : Node2D

func _init(_paddle: Node).(_paddle):
	var balls = _paddle.get_tree().get_nodes_in_group('ball')
	if balls.size() == 0:
		print("Could not find the ball in the scene tree, this should not happen...")
	_ball = balls[0] as Node2D

func get_desired_position_y() -> float:
	return _ball.position.y
