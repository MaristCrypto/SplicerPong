extends KinematicBody2D
class_name Paddle

enum ControllerType { PLAYER, AI }

# the paddle's maximum speed
export var speed := 500
export(ControllerType) var controllerType := ControllerType.PLAYER

# tracking the desired Y position based on the mouse position
var _targetPositionY := 540.0
var _controller : BaseController
var _velocity := Vector2()

func _ready():
	# initialize the controller based on the selected controller type
	match controllerType:
		ControllerType.PLAYER:
			_controller = PlayerController.new(self)
		ControllerType.AI:
			_controller = AIController.new(self)

func _physics_process(delta: float) -> void:
	# update the desired Y position based on the current mouse position
	_targetPositionY = _controller.get_desired_position_y()
	var diff := _targetPositionY - position.y
	# if we are at our desired Y don't do anything
	if diff == 0:
		return
	var dist := abs(diff)
	var dir := diff / dist
	# distance to move - if the distance to desired Y is less than speed * delta then snap to the desired Y
	var moveDist := min(dist, speed * delta)
	# update our current velocity
	_velocity = Vector2(0, dir * moveDist)
	# move according to our velocity, the infinite_inertia=false is to prevent the paddle from kicking itself off-axis when squishing a ball against the wall
	move_and_collide(_velocity, false)

func get_paddle_velocity() -> Vector2:
	return _velocity

func get_paddle_width() -> float:
	return ($CollisionShape2D.shape as RectangleShape2D).extents.y
