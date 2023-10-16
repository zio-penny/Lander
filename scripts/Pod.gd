class_name Pod extends RigidBody2D
## A player controller for pod game mode
# May have to generalize for NPCs 

@export var RotationThrustPower: float = 256

var _throttle:float
var _throttleDown:float

var _strafeLeft: float
var _strafeRight: float
var _strafe: float:
	get: return _strafeRight - _strafeLeft
	
var _rollL:float
var _rollR:float
var _roll: float:
	get: return _rollR - _rollL
	
var _auxUp:float
var _auxDown:float
var _aux: float:
	get: return _auxUp - _auxDown
	
signal current_velocity(globalPosition:Vector2, velocity:Vector2)

@onready var _mainThruster:Thruster = $MainThruster
@onready var _downThruster:Thruster = $DownThruster
@onready var _leftThruster:Thruster = $LeftThruster
@onready var _rightThruster:Thruster = $RightThruster
	
func _unhandled_input(event):	
	if event.is_action_pressed("Throttle") || event.is_action_released("Throttle"):
		_throttle = event.get_action_strength("Throttle")		
	if event.is_action_pressed("ThrottleDown") || event.is_action_released("ThrottleDown"):
		_throttleDown = event.get_action_strength("ThrottleDown")
	
	if event.is_action_pressed("StrafeLeft") || event.is_action_released("StrafeLeft"):
		_strafeLeft = event.get_action_strength("StrafeLeft")		
	if event.is_action_pressed("StrafeRight") || event.is_action_released("StrafeRight"):
		_strafeRight = event.get_action_strength("StrafeRight")
	
	if event.is_action_pressed("RollLeft") || event.is_action_released("RollLeft"):
		_rollL = event.get_action_strength("RollLeft")		
	if event.is_action_pressed("RollRight") || event.is_action_released("RollRight"):
		_rollR = event.get_action_strength("RollRight")
		
	if event.is_action_pressed("AuxUp") || event.is_action_released("AuxUp"):
		_auxUp = -event.get_action_strength("AuxUp")
	if event.is_action_pressed("AuxDown") || event.is_action_released("AuxDown"):
		_auxDown = event.get_action_strength("AuxDown")
		
	if abs(_throttle) + abs(_throttleDown) + abs(_strafe) + abs(_roll) + abs(_aux) != 0: sleeping = false;
	
func _integrate_forces(state:PhysicsDirectBodyState2D):
	apply_central_force(Vector2.UP.rotated(rotation) * _mainThruster.ThrustPower * _mainThruster.GroundEffect * _throttle)	
	apply_central_force(Vector2.DOWN.rotated(rotation) * _downThruster.ThrustPower * _mainThruster.GroundEffect * _throttleDown)	
	apply_central_force(Vector2.RIGHT.rotated(rotation) * _rightThruster.ThrustPower * _rightThruster.GroundEffect * _strafeRight)
	apply_central_force(Vector2.LEFT.rotated(rotation) * _leftThruster.ThrustPower * _leftThruster.GroundEffect * _strafeLeft)
	
	current_velocity.emit(global_position, state.linear_velocity)
	
	apply_torque(_roll * PI * RotationThrustPower)
