extends Node

# Random periods so that the sounds overlap somewhat
onready var waterPhase = (randf() * 2.0 - 1.0) * 2.0 * PI
onready var insectsPhase = (randf() * 2.0 - 1.0) * 2.0 * PI
onready var trafficPhase= (randf() * 2.0 - 1.0) * 2.0 * PI

onready var originalTrafficLevel = -40
onready var originalWaterLevel = -30
onready var originalInsectsLevel = -40

var listOfSongs = (["res://Assets/Sounds/Music/in game/anttisinstrumentals_memoryofbetterdays.mp3",
					"res://Assets/Sounds/Music/in game/anttisinstrumentals_moctailsintherain.mp3",
					"res://Assets/Sounds/Music/in game/anttisinstrumentals_YouAreOnHold.mp3"])

# Keep track of time
var time = 0

func _ready():
	playRandomSong()

func _process(delta):
	$Ambience/Traffic.volume_db = originalTrafficLevel - 10.0 * cos(1.0 / 60.0 * time + trafficPhase)
	$Ambience/Water.volume_db = originalWaterLevel - 10.0 * cos(1.0 / 20.0 * time + waterPhase)
	$Ambience/Insects.volume_db = originalInsectsLevel - 10.0 * cos(1.0 / 40.0 * time + insectsPhase)
	time += delta

func playRandomSong():
	var randSong = randi() % 3
	$Music.stream = load(listOfSongs[randSong])
	$Music.play()


func _on_Music_finished():
	$Music/SongWaitTimer.wait_time = randi() % 60
	$Music/SongWaitTimer.start()


func _on_SongWaitTimer_timeout():
	playRandomSong()
