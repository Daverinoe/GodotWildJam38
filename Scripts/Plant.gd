extends Sprite

# Sell stuff
export(int, 0, 100, 1) var value = 5
var sellDialogue = preload("res://Scenes/selldialogue.tscn")

# Nutrient uptake
var nutrientsTaken = 0.75

func _process(_delta):
	get_tree().root.get_node("Game").nutrientsChange -= nutrientsTaken

func _ready():
	material.set_shader_param("offset", randf() * 2.0 - 1.0)
	
	changeMaxInsects(2)
	
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
		changeMaxInsects(-ceil(2 * nutrientsTaken))


func _on_Grow1_timeout():
	value = 15
	frame += 1
	nutrientsTaken *= 2
	changeMaxInsects(2)
	$Grow2.start()
	$Grow1.stop()


func _on_Grow2_timeout():
	value = 40
	frame += 1
	nutrientsTaken *= 2
	changeMaxInsects(2)
	$Grow2.stop()

func changeMaxInsects(x):
	get_tree().root.get_node("Game").maxInsects = clamp(get_tree().root.get_node("Game").maxInsects + x, 0, 30)
