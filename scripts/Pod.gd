class_name Pod extends RigidBody2D
## A player controller for pod game mode
# May have to generalize for NPCs 


@export var MainThrustPower: float = 3072
@export var ManuThrustPower: float = 512
@export var RotationThrustPower: float = 16

var _throttle:float
var _throttleDown:float

var _strafeLeft: float
var _strafeRight: float
var _strafe: float:
	get: return _strafeRight - _strafeLeft 

var _rollL:float # In radians
var _rollR:float
var _roll: float:
	get: return _rollR - _rollL
	
var _auxUp:float # In radians
var _auxDown:float
var _aux: float:
	get: return _auxUp - _auxDown

@onready var _mainThruster:Node2D = $MainThruster
@export var _mainThrusterLength:float = 32
@export var _mainThrusterGEMultiplier:float = 4

@onready var _downhruster:Node2D = $DownThruster
@onready var _leftThruster:Node2D = $LeftThruster
@onready var _rightThruster:Node2D = $RightThruster

func _physics_process(delta):
	var space_state = get_world_2d().direct_space_state
	
	var mainThrusterQuery = PhysicsRayQueryParameters2D.create(_mainThruster.global_position, _mainThruster.global_position + Vector2(0, _mainThrusterLength).rotated(rotation))
	var result = space_state.intersect_ray(mainThrusterQuery)
	
	var ratio:float = 0.0
	
	if result:
		var d:Vector2 = result.position - _mainThruster.global_position
		ratio = 1.0 - (d.length()/_mainThrusterLength)
	
func _unhandled_input(event):	
	if event.is_action_pressed("Throttle") || event.is_action_released("Throttle"):
		_throttle = event.get_action_strength("Throttle")
		print(_throttle)
		
	if event.is_action_pressed("ThrottleDown") || event.is_action_released("ThrottleDown"):
		_throttleDown = event.get_action_strength("ThrottleDown")
	
	if event.is_action_pressed("StrafeLeft") || event.is_action_released("StrafeLeft"):
		_strafeLeft = event.get_action_strength("StrafeLeft")
		
	if event.is_action_pressed("StrafeRight") || event.is_action_released("StrafeRight"):
		_strafeRight = event.get_action_strength("StrafeRight")
	
	if event.is_action_pressed("RollLeft") || event.is_action_released("RollLeft"):
		_rollL = -event.get_action_strength("RollLeft")
		
	if event.is_action_pressed("RollRight") || event.is_action_released("RollRight"):
		_rollR = event.get_action_strength("RollRight")
		
	if event.is_action_pressed("AuxUp") || event.is_action_released("AuxUp"):
		_auxUp = -event.get_action_strength("AuxUp")
	if event.is_action_pressed("AuxDown") || event.is_action_released("AuxDown"):
		_auxDown = event.get_action_strength("AuxDown")
	
func _integrate_forces(state):
#	for i in range(state.get_contact_count()):
#		var other:Object = state.get_contact_collider_object(i)
#
#		if other:
#			if other is LandingPad:
#				pass
	
	apply_central_force(Vector2.UP.rotated(rotation) * (MainThrustPower) * _throttle)	
	apply_central_force(Vector2.DOWN.rotated(rotation) * ManuThrustPower * _throttleDown)
	
	apply_central_force(Vector2.RIGHT.rotated(rotation) * ManuThrustPower * _strafe)
	
	# var targetRotation:float = _rollL * deg_to_rad(PitchRange)
	# var rotationDiff:float = targetRotation - rotation
	# var shortestAngle:float = fmod((rotationDiff + PI), (2 * PI)) - PI
	# var curveX:float = abs(rotationDiff) / PI
	
	# apply_torque(shortestAngle * ManuThrustPower * RotationThrustPower - (angular_velocity * ManuThrustPower * RotationDampingMultiplier))
	# apply_torque(shortestAngle * ManuThrustPower * 32)
	apply_torque(_roll * RotationThrustPower * 16)
	apply_torque(-(angular_velocity * ManuThrustPower * 4))
	
