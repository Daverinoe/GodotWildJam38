extends Sprite

# Sell stuff
export(int, 0, 100, 1) var value = 5
var sellDialogue = preload("res://Scenes/selldialogue.tscn")


func _ready():
	material.set_shader_param("offset", randf() * 2.0 - 1.0)
	
	var randPlant = randi() % 2
	if randPlant:
		frame = 0
	else:
		frame = 3


func _on_ClickArea_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		var sellInstance = sellDialogue.instance()
		self.call_deferred("add_child", sellInstance)
		sellInstance.get_node("SellDialogue/MarginContainer/Background/Sell").text = str(round(value))
		sellInstance.value = value


func _on_Grow1_timeout():
	value = 15
	frame += 1
	$Grow2.start()
	$Grow1.stop()


func _on_Grow2_timeout():
	value = 40
	frame += 1
	$Grow2.stop()
