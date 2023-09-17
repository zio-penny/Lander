extends RigidBody2D
class_name Pod

@export var MaxThrust: float = 1000
@export var MaxTorque: float = 100

var throttle: float = 0;
var yaw: float = 0;

func _input(event):
	throttle = event.get_action_strength("Throttle")
	yaw = -event.get_action_strength("YawLeft") + event.get_action_strength("YawRight")
	
func _integrate_forces(state):
	if throttle > 0:
		state.apply_force(Vector2.UP.rotated(rotation) * MaxThrust * throttle)
		
	if yaw != 0:
		state.apply_torque(yaw * MaxTorque)
		
	
