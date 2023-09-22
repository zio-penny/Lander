class_name Lander
extends RigidBody2D

@export var MainThrustPower: float = 3072
@export var StrafeThrustPower: float = 512
@export var RotationThrustMultiplier: float = 16

var _throttle:float
var _strafe:float
var _yaw
	
func _unhandled_input(event):
	if event.is_action_pressed("Throttle") || event.is_action_released("Throttle"):
		_throttle = event.get_action_strength("Throttle")
	
	if event.is_action_pressed("StrafeLeft") || event.is_action_released("StrafeLeft"):
		_strafe = -event.get_action_strength("StrafeLeft")
	if event.is_action_pressed("StrafeRight") || event.is_action_released("StrafeRight"):
		_strafe += event.get_action_strength("StrafeRight")

func _integrate_forces(state):
	if _throttle > 0 : apply_central_force(Vector2.UP.rotated(rotation) * MainThrustPower * _throttle)
	if _strafe != 0: apply_central_force(Vector2.RIGHT.rotated(rotation) * StrafeThrustPower * _strafe)
	if abs(rotation) > 0.001: apply_torque(-(rotation/PI) * (MainThrustPower + StrafeThrustPower) * RotationThrustMultiplier)
	
