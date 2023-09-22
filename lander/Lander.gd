class_name Lander
extends RigidBody2D

@export var MainThrustPower: float = 3072
@export var StrafeThrustPower: float = 512
@export var RotationThrustMultiplier: float = 16
@export var PitchCurve: Curve
var _throttle:float
var _strafe:float
var _pitch:float # In radians
	
func _unhandled_input(event):
	if event.is_action_pressed("Throttle") || event.is_action_released("Throttle"):
		_throttle = event.get_action_strength("Throttle")
	
	if event.is_action_pressed("StrafeLeft") || event.is_action_released("StrafeLeft"):
		_strafe = -event.get_action_strength("StrafeLeft")
	if event.is_action_pressed("StrafeRight") || event.is_action_released("StrafeRight"):
		_strafe += event.get_action_strength("StrafeRight")
		
	if event.is_action_pressed("PitchLeft") || event.is_action_released("PitchLeft"):
		_pitch = -event.get_action_strength("PitchLeft")
	if event.is_action_pressed("PitchRight") || event.is_action_released("PitchRight"):
		_pitch += event.get_action_strength("PitchRight")
		
	
func _integrate_forces(state):
	for i in range(state.get_contact_count()):
		var other = state.get_contact_collider_object(i)
		if other:
			if other is LandingPad:
				print(other.name)
	
	if _throttle > 0 : apply_central_force(Vector2.UP.rotated(rotation) * MainThrustPower * _throttle)
	if _strafe != 0: apply_central_force(Vector2.RIGHT.rotated(rotation) * StrafeThrustPower * _strafe)
	
	var _targetRotation = _pitch * (PI / 2)
	var _rotationDiff = _targetRotation - rotation
	var _curveX = abs(_rotationDiff) / PI
	
	apply_torque(PitchCurve.sample(_curveX) * sign(_rotationDiff) * (MainThrustPower + StrafeThrustPower) * RotationThrustMultiplier)
	
