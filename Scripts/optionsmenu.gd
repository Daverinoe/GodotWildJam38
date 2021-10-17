extends MarginContainer

var masterLevel = 0
var ambienceLevel = 0
var musicLevel = 0
var effectLevel = 0

export(NodePath) var MainMenuPath
export(NodePath) var separator

func _ready() -> void:
	masterLevel = db2linear(AudioServer.get_bus_volume_db(0))
	musicLevel = db2linear(AudioServer.get_bus_volume_db(1))
	ambienceLevel = db2linear(AudioServer.get_bus_volume_db(2))
	effectLevel = db2linear(AudioServer.get_bus_volume_db(3))
	
	$Background/MarginContainer/VBoxContainer/Audio/Master/Master.value = masterLevel
	$Background/MarginContainer/VBoxContainer/Audio/Ambience/Ambience.value = ambienceLevel
	$Background/MarginContainer/VBoxContainer/Audio/Effects/Effects.value = effectLevel
	$Background/MarginContainer/VBoxContainer/Audio/Music/Music.value = musicLevel
	
	var parent = get_parent().name
	if parent == "MainMenu":
		get_node(MainMenuPath).visible = false
		get_node(separator).visible = false
	



func _on_Master_value_changed(value):
	AudioServer.set_bus_volume_db(0, linear2db(value))


func _on_Ambience_value_changed(value):
	AudioServer.set_bus_volume_db(2, linear2db(value))


func _on_Effects_value_changed(value):
	AudioServer.set_bus_volume_db(3, linear2db(value))


func _on_Music_value_changed(value):
	AudioServer.set_bus_volume_db(1, linear2db(value))


func _on_Button_pressed():
	self.call_deferred("queue_free")


func _on_MainMenuButton_pressed():
	get_tree().change_scene("res://Scenes/mainmenu.tscn")
