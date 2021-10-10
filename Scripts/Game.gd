extends Node2D

var previousMoney = 100
var currentMoney = 100

func _ready():
	updateMoney()

func _process(_delta):
	if currentMoney != previousMoney:
		updateMoney()

func updateMoney():
	previousMoney = currentMoney
	$GUI.get_node("Screen/Top bar/HBoxContainer/Money/Label").text = "$" + str(currentMoney)
