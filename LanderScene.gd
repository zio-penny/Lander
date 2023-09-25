class_name LanderScene extends Node2D

@export var GravityVector:Vector2 = Vector2(0, 1)
@export var GravityScale:float = 32.0

func _ready():
	PhysicsServer2D.area_set_param(get_viewport().find_world_2d().space, PhysicsServer2D.AREA_PARAM_GRAVITY_VECTOR, GravityVector)
	PhysicsServer2D.area_set_param(get_viewport().find_world_2d().space, PhysicsServer2D.AREA_PARAM_GRAVITY, GravityScale)
