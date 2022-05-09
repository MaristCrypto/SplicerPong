extends KinematicBody2D

export var initialForceMagnitude := 1000.0 # magnitude of the force applied to the ball on game start
export var maxInitialAngle := 45.0 # max initial angle in degrees
export var maxPaddleBounceAngle := 65.0 # the max angle at which the ball can bounce from a paddle (in degrees)

var _rng := RandomNumberGenerator.new()
var _velocity := Vector2()
onready var _startPosition := position

# _ready is called whenever the object is added to the active scene tree
func _ready() -> void:
	# it is necessary to initialize the RandomNumberGenerator
	_rng.randomize()
	_reset_ball()

func _reset_ball() -> void:
	position = _startPosition
	# apply the initial force
	_velocity = Vector2.RIGHT.rotated(_rng.randf_range(-deg2rad(maxInitialAngle), deg2rad(maxInitialAngle)) + PI * _rng.randi_range(0, 1)) * initialForceMagnitude

# _physics_process is called each physics "frame" (not necessarily tied to the render framerate), the
# delta argument contains the time elapsed since last physics frame in milliseconds
func _physics_process(delta: float) -> void:
	# if the ball is outside the play area reset it
	if position.x < -100 or position.x > get_viewport_rect().size.x + 100:
		_reset_ball()
		return
	# move_and_collides moves the object along the provided vector. If a collision happens it stops the translation
	# and returns a collision object, otherwise null is returned
	var collision := move_and_collide(_velocity * delta, false)
	# if the ball doesn't collide with anything let's just return
	if collision == null:
		return
	var collider := collision.collider as Node
	if collider.is_in_group('wall'):
		# if ball collides with wall bounce with standard reflection angle
		# https://math.stackexchange.com/questions/13261/how-to-get-a-reflection-vector
		_velocity = _velocity - 2 * (_velocity.dot(collision.normal)) * collision.normal
	elif collider.is_in_group('paddle'):
		var paddle := collider as Paddle
		# number between -1 (ball hits top of the paddle) to 1 (ball hits bottom of the paddle)
		var hitPositionRelative := (collision.position.y - paddle.global_position.y) / paddle.get_paddle_width()
		# a direction vector towards the opponent
		var opponentDir = Vector2(get_viewport_rect().size.x / 2 - position.x, 0).normalized()
		# shoot the ball against the opponent at an angle between -maxPaddleBounceAngle, +maxPaddleBounceAngle
		_velocity = opponentDir.rotated(hitPositionRelative * deg2rad(maxPaddleBounceAngle) * opponentDir.x) * _velocity.length()
		
