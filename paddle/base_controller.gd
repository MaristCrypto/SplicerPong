# Base abstract class for the paddle controllers. Do not use this controller directly, it's meant to be
# extended by the individual implementations.

extends Reference
class_name BaseController

# The controlled paddle is passed to the controllers so that they can initialize their state.
func _init(_paddle: Node):
	pass

# Controller must decide where it wants the paddle to move. This method is called each physics update.
func get_desired_position_y() -> float:
	return 0.0
