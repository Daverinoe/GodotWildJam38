extends Node2D

var game = "res://Scenes/game.tscn"
var fishScene = preload("res://Scenes/fish.tscn")
var options = preload("res://Scenes/optionsmenu.tscn")

export var numFish = 300

func _init():
	for fish in numFish:
		var willGrow = randi() % 100 + 0.1
		var fishInstance = fishScene.instance()
		fishInstance.get_node("Adolescence").wait_time = randi() % 100 + 0.1
		fishInstance.get_node("Adulthood").wait_time = randi() % 100 + 0.1
		fishInstance.position = Vector2(randf() * 1280, randf() * 720)
		self.call_deferred("add_child", fishInstance)
		if willGrow < 50:
			fishInstance.get_node("Adulthood").disconnect("timeout", fishInstance, "_on_Adulthood_timeout")
		elif willGrow < 85:
			fishInstance.get_node("Adolescence").disconnect("timeout", fishInstance, "_on_Adolescence_timeout")

func _on_Start_pressed():
	get_tree().change_scene(game)

func _on_Exit_pressed():
	get_tree().quit()


func _on_Options_pressed():
	var optionsMenu = options.instance()
	self.call_deferred("add_child", optionsMenu)
