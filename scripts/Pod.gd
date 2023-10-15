class_name Pod extends RigidBody2D
## A player controller for pod game mode
# May have to generalize for NPCs 

@export var MainThrustPower: float = 2048
@export var ManuThrustPower: float = 256
@export var RotationThrustPower: float = 256
@export var RollMultiplier:int = 4
@export var GroundEffectDistance:float = 32
@export var GroundEffectMultiplier:float = 4.0
@export var EffectCurve:Curve

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

@onready var _mainThruster:Node2D = $MainThruster
@onready var _downThruster:Node2D = $DownThruster
@onready var _leftThruster:Node2D = $LeftThruster
@onready var _rightThruster:Node2D = $RightThruster
	
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
	var world_space_state:PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	# Ground Effect code will go here
	var mainQuery:PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(_mainThruster.global_position, _mainThruster.global_position + (Vector2.DOWN.rotated(rotation) * GroundEffectDistance))
	var mainResult:Dictionary = world_space_state.intersect_ray(mainQuery)	
	var currentMainGE:float = 1.0
	if mainResult:
		var d:Vector2 = mainResult.position - _mainThruster.global_position;
		var ratio:float = EffectCurve.sample((d.length() / GroundEffectDistance))
		currentMainGE = 1 + (ratio * GroundEffectMultiplier)
		
	var leftQuery:PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(_leftThruster.global_position, _leftThruster.global_position + (Vector2.LEFT.rotated(rotation) * GroundEffectDistance))
	var leftResult:Dictionary = world_space_state.intersect_ray(leftQuery)	
	var currentLeftGE:float = 1.0
	if leftResult:
		var d:Vector2 = leftResult.position - _leftThruster.global_position;
		var ratio:float = EffectCurve.sample((d.length() / GroundEffectDistance))
		currentLeftGE = 1 + (ratio * GroundEffectMultiplier)
		
	var rightQuery:PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(_rightThruster.global_position, _rightThruster.global_position + (Vector2.RIGHT.rotated(rotation) * GroundEffectDistance))
	var rightResult:Dictionary = world_space_state.intersect_ray(rightQuery)	
	var currentRightGE:float = 1.0
	if rightResult:
		var d:Vector2 = rightResult.position - _rightThruster.global_position;
		var ratio:float = EffectCurve.sample((d.length() / GroundEffectDistance))
		currentRightGE = 1 + (ratio * GroundEffectMultiplier)
		
	var downQuery:PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(_downThruster.global_position, _downThruster.global_position + (Vector2.RIGHT.rotated(rotation) * GroundEffectDistance))
	var downResult:Dictionary = world_space_state.intersect_ray(downQuery)	
	var currentDownGE:float = 1.0
	if downResult:
		var d:Vector2 = downResult.position - _downThruster.global_position;
		var ratio:float = EffectCurve.sample((d.length() / GroundEffectDistance))
		currentDownGE = 1 + (ratio * GroundEffectMultiplier)
	
	current_velocity.emit(global_position, state.linear_velocity)
	apply_central_force(Vector2.UP.rotated(rotation) * MainThrustPower * currentMainGE * _throttle)	
	apply_central_force(Vector2.DOWN.rotated(rotation) * ManuThrustPower * _throttleDown * currentDownGE)	
	apply_central_force(Vector2.RIGHT.rotated(rotation) * ManuThrustPower * _strafe * currentLeftGE * currentRightGE)
	
	apply_torque(_roll * PI * RotationThrustPower * RollMultiplier)
	apply_torque(-(angular_velocity * RotationThrustPower * 4 * RollMultiplier))
	
	
