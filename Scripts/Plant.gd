extends AnimatedSprite

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
		animation = "Thyme"
		frame = 0
		self.offset = Vector2(-2, -2)
		$Control.rect_size = self.get_sprite_frames().get_frame("Thyme", 0).get_size()
	else:
		animation = "Basil"
		frame = 0
		self.offset.y = -2
		$Control.rect_size = self.get_sprite_frames().get_frame("Basil", 0).get_size()


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
	if animation == "Thyme":
		self.offset = Vector2(-3, -10)
		$Control.rect_size = self.get_sprite_frames().get_frame("Thyme", 1).get_size()
	else:
		self.offset = Vector2(-1, -10)
		$Control.rect_size = self.get_sprite_frames().get_frame("Basil", 1).get_size()


func _on_Grow2_timeout():
	value = 40
	frame += 1
	nutrientsTaken *= 2
	changeMaxInsects(2)
	$Grow2.stop()
	if animation == "Thyme":
		self.offset = Vector2(-6, -18)
		$Control.rect_size = self.get_sprite_frames().get_frame("Thyme", 2).get_size()
	else:
		self.offset = Vector2(0, -18)
		$Control.rect_size = self.get_sprite_frames().get_frame("Basil", 2).get_size()

func changeMaxInsects(x):
	get_tree().root.get_node("Game").maxInsects = clamp(get_tree().root.get_node("Game").maxInsects + x, 0, 30)



func _on_Control_gui_input(event):
	if event.is_action_pressed("select"):
		var gameNode = get_tree().root.get_node("Game")
		var modifier = 1
		var sellInstance = sellDialogue.instance()
		self.call_deferred("add_child", sellInstance)
		# If nutrients are "good", sell for more $$$!
		if (gameNode.nutrientLevels < gameNode.upperOptimalNutrients) && (gameNode.nutrientLevels > gameNode.lowerOptimalNutrients):
			modifier = 1.25
		elif (gameNode.nutrientLevels >= gameNode.tooNutrient): # But maybe nutrients are bad?? Then sell for less.
			modifier = 0.75
		sellInstance.get_node("SellDialogue/MarginContainer/Background/Sell").text = str(ceil(value * modifier))
		sellInstance.value = value
