extends Node2D

var value = 0

func _init():
	self.global_rotation = 0.0

func _physics_process(_delta):
	self.global_rotation = 0.0

func _unhandled_input(event):
	if event.is_action_pressed("select"):
		self.call_deferred("queue_free")


func _on_MarginContainer_gui_input(event):
	if event.is_action_pressed("select"):
		var gameNode = get_tree().root.get_node("Game")
		var currentNutrients = gameNode.nutrientLevels
		
		# If nutrients are "good", sell for more $$$!
		if (currentNutrients < gameNode.upperOptimalNutrients) && (currentNutrients > gameNode.lowerOptimalNutrients):
			value *= 1.25
		elif (currentNutrients >= gameNode.tooNutrient): # But maybe nutrients are bad?? Then sell for less.
			value *= 0.75
		gameNode.currentMoney += value
		
		# Remove this node and also the object this is attached to
		get_parent().call_deferred("queue_free")
