class_name Thruster extends Node2D
## Node that casts a ray to determine ground effect

@export var GroundEffectDistance:float = 32
@export var GroundEffectMultiplier:float = 4.0
@export var EffectCurve:Curve

signal groundEffect(value:float)

func _physics_process(delta):
	var world_space_state:PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	# Ground Effect code will go here
	var query:PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(global_position, global_position + (Vector2.DOWN.rotated(rotation) * GroundEffectDistance))
	var result:Dictionary = world_space_state.intersect_ray(query)
	
	# if result:
		# var d:Vector2 = result.position - global_position;
		# var ratio:float = EffectCurve.sample((d.length() / GroundEffectDistance))
		# groundEffect.emit(ratio * GroundEffectMultiplier)
	# else:
		# groundEffect.emit(0.0)
