class_name Thruster extends Node2D
## Node that casts a ray to determine ground effect
## and 

@export var ThrustPower:float = 2048.0
@export var GroundEffectMaximum:float = 32
@export var GroundEffectMultiplier:float = 4.0
@export var EffectCurve:Curve

var GroundEffect:float = 1.0

func _physics_process(delta):
	var world_space_state:PhysicsDirectSpaceState2D = get_world_2d().direct_space_state	
	var query:PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(global_position, global_position + (Vector2.RIGHT.rotated(rotation) * GroundEffectMaximum))
	var result:Dictionary = world_space_state.intersect_ray(query)
	
	if result:
		var hitDistance:Vector2 = result.position - global_position;
		var ratio:float = EffectCurve.sample((hitDistance.length() / GroundEffectMaximum))
		GroundEffect = 1+ (ratio * GroundEffectMultiplier)
	else:
		GroundEffect = 1.0
