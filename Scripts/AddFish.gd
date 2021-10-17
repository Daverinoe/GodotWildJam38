extends Control

export(PackedScene) var fish
export(NodePath) var FishNodePath
onready var FishNode = get_node(FishNodePath)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_AddFish_gui_input(event):
	if event.is_action_pressed("select"):
		if get_parent().currentMoney >= 10:
			var fishInstance = fish.instance()
			get_parent().currentMoney -= 10
			FishNode.call_deferred("add_child", fishInstance)
