extends Node2D

var previousMoney = 100
var currentMoney = 100

# How to handle nutrients
var minNutrients = 0
var maxNutrients = 300
var nutrientLevels = 0
var nutrientsChange = 0
var lowerOptimalNutrients = 110
var upperOptimalNutrients = 230
var tooNutrient = 250

# Insects!
var maxInsects = 0
var insectScene = preload("res://Scenes/insect.tscn")

func _ready():
	updateMoney()

func _process(delta):
	changeNutrientLevel(nutrientsChange * delta)
	nutrientsChange = 0
	maxInsects = clamp(maxInsects, 0, 30)
	
	if currentMoney != previousMoney:
		updateMoney()

func updateMoney():
	$GUI.get_node("Screen/TopBar/HBoxContainer/Money/Label").text = "$" + str(currentMoney)
	if currentMoney - previousMoney > 0:
		$GUI/MoneyAddParticles.process_material.radial_accel = -1000
	elif currentMoney - previousMoney < 0:
		$GUI/MoneyAddParticles.process_material.radial_accel = 1000
	$GUI/MoneyAddTimer.start()
	$GUI/MoneyAddParticles.emitting = true
	previousMoney = ceil(currentMoney)

func changeNutrientLevel(amount) -> void:
	nutrientLevels += amount
	

func _on_Timer_timeout():
	if $Insects.get_child_count() < maxInsects:
		var spawnInsectCheck = randi() % 2
		if spawnInsectCheck:
			var insectInstance = insectScene.instance()
			insectInstance.position = Vector2(randf() * 1278, randf() * 318)
			$Insects.call_deferred("add_child", insectInstance)
	if $Insects.get_child_count() > maxInsects:
		var insectList = $Insects.get_children()
		var doomedInsect = insectList[0]
		doomedInsect.call_deferred("queue_free")

func _on_MoneyAddTimer_timeout():
	$GUI/MoneyAddParticles.emitting = false
