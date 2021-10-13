extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var needleRotation = -150


# Called when the node enters the scene tree for the first time.
func _ready():
	$Needle.rotation_degrees = -150


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _physics_process(_delta):
	$Needle.rotation_degrees = clamp(needleRotation, -150, 150)
