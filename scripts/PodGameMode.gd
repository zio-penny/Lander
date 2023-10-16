class_name PodGameMode extends Node2D
## Owns all nodes used in pod exploration scenes
## and manages the mode's global settings

## Global gravity direction. Down = (0,1)
@export var GravityVector:Vector2 = Vector2.DOWN
## Global gravity scale. Earth = 1000.0, Moon = 100.0
@export var GravityScale:float = 100.0
 
@onready var spaceRID:RID = get_viewport().find_world_2d().space 

func _ready():
	updateGravityScale(GravityScale)
	updateGravityVector(GravityVector)
	
## Takes in a float and updates the PhysicsServer
func updateGravityScale(scale) -> void:
	PhysicsServer2D.area_set_param(spaceRID, PhysicsServer2D.AREA_PARAM_GRAVITY, scale)
	print("Gravity Scale Updated: ", PhysicsServer2D.area_get_param(spaceRID, PhysicsServer2D.AREA_PARAM_GRAVITY))

func updateGravityVector(vector:Vector2) -> void:
	PhysicsServer2D.area_set_param(spaceRID, PhysicsServer2D.AREA_PARAM_GRAVITY_VECTOR, vector)
	print("Gravity Vector Updated: ", PhysicsServer2D.area_get_param(spaceRID, PhysicsServer2D.AREA_PARAM_GRAVITY_VECTOR))
