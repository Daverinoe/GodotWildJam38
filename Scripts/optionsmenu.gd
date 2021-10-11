extends MarginContainer

onready var masterBus := AudioServer.get_bus_index("Master")
onready var musicBus := AudioServer.get_bus_index("Music")
onready var ambienceBus := AudioServer.get_bus_index("Ambience")
onready var effectBus := AudioServer.get_bus_index("Effects")

var masterLevel = 0
var ambienceLevel = 0
var musicLevel = 0
var effectLevel = 0

func _ready() -> void:
	masterLevel = db2linear(AudioServer.get_bus_volume_db(masterBus))
	ambienceLevel = db2linear(AudioServer.get_bus_volume_db(musicBus))
	musicLevel = db2linear(AudioServer.get_bus_volume_db(ambienceBus))
	effectLevel = db2linear(AudioServer.get_bus_volume_db(effectBus))
	
	$Background/MarginContainer/VBoxContainer/Audio/Master/Master.value = masterLevel
	$Background/MarginContainer/VBoxContainer/Audio/Ambience/Ambience.value = ambienceLevel
	$Background/MarginContainer/VBoxContainer/Audio/Effects/Effects.value = effectLevel
	$Background/MarginContainer/VBoxContainer/Audio/Music/Music.value = musicLevel



func _on_Master_value_changed(value):
	AudioServer.set_bus_volume_db(masterLevel, linear2db(value))


func _on_Ambience_value_changed(value):
	AudioServer.set_bus_volume_db(ambienceLevel, linear2db(value))


func _on_Effects_value_changed(value):
	AudioServer.set_bus_volume_db(effectLevel, linear2db(value))


func _on_Music_value_changed(value):
	AudioServer.set_bus_volume_db(musicLevel, linear2db(value))


func _on_Button_pressed():
	self.call_deferred("queue_free")
