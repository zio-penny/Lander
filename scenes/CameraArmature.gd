class_name CameraArmature extends Node2D
## Manages camera focus target position

@export var targetPod:Pod
@export var CameraLeadingMax = 32
func _ready():
	if targetPod:
		targetPod.current_velocity.connect(updatePosition)
	else: print("NO POD")
		
func updatePosition(globalPosition:Vector2, velocity:Vector2):
	print("Update pos: ", globalPosition, " Update vel: ", velocity)
	if velocity.length() > CameraLeadingMax:
		velocity = velocity.normalized() * CameraLeadingMax
	global_position = globalPosition + velocity
