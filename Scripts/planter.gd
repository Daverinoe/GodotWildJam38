extends Sprite

export(PackedScene) var plant

var plant1 = false
var plant2 = false
var plant3 = false
var plant4 = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(_delta):
	for child in self.get_children():
		if child.get_child_count() == 0:
			if child.name == "Plant1":
				plant1 = false
			if child.name == "Plant2":
				plant2 = false
			if child.name == "Plant3":
				plant3 = false
			if child.name == "Plant4":
				plant4 = false

func AddPlant(position, node):
	if get_tree().root.get_node("Game").currentMoney >= 5:
		get_tree().root.get_node("Game").currentMoney -= 5
		var plantInstance = plant.instance()
		plantInstance.position = position
		node.call_deferred("add_child", plantInstance)


func _on_Control_gui_input(event):
	if event.is_action_pressed("select"):
		if !plant1:
			AddPlant(Vector2(-110, -36.5), $Plant1)
			plant1 = true


func _on_Control2_gui_input(event):
	if event.is_action_pressed("select"):
		if !plant2:
			AddPlant(Vector2(-41, -36.5), $Plant2)
			plant2 = true


func _on_Control3_gui_input(event):
	if event.is_action_pressed("select"):
		if !plant3:
			AddPlant(Vector2(29, -36.5), $Plant3)
			plant3 = true


func _on_Control4_gui_input(event):
	if event.is_action_pressed("select"):
		if !plant4:
			AddPlant(Vector2(98, -36.5), $Plant4)
			plant4 = true
