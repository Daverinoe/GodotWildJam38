extends Control

var colorTrack = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$MarginContainer/MarginContainer/VBoxContainer/HBoxContainer6/Sprite/goodnessIndicator.process_material.set_color(Color(68.0/255.0, 200.0/255.0, 31.0/255.0, 1.0))
	$MarginContainer/MarginContainer/VBoxContainer/HBoxContainer6/Sprite/Sprite.rotation_degrees = 180
	for child in $MarginContainer/MarginContainer/VBoxContainer/HBoxContainer3.get_children():
		if child is Sprite:
			randomize()
			var randPhase = PI*(randf()*2.0-1.0)
			child.material.set_shader_param("phase", randPhase)
	for child in $MarginContainer/MarginContainer/VBoxContainer/HBoxContainer5.get_children():
		if child is Sprite:
			randomize()
			child.material.set_shader_param("offset", randf() * 2.0 - 1.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		pass
	else:
		self.call_deferred("queue_free")

func _input(event):
	if event is InputEventMouseMotion:
		pass
	else:
		self.call_deferred("queue_free")

func _on_Timer_timeout():
	if colorTrack == 1:
		$MarginContainer/MarginContainer/VBoxContainer/HBoxContainer6/Sprite/goodnessIndicator.process_material.set_color(Color(68.0/255.0, 200.0/255.0, 31.0/255.0, 1.0))
		$MarginContainer/MarginContainer/VBoxContainer/HBoxContainer6/Sprite/Sprite.rotation_degrees = 180
		colorTrack *= -1
	else:
		$MarginContainer/MarginContainer/VBoxContainer/HBoxContainer6/Sprite/goodnessIndicator.process_material.set_color(Color(200.0/255.0, 0.0, 0.0, 1.0))
		$MarginContainer/MarginContainer/VBoxContainer/HBoxContainer6/Sprite/Sprite.rotation_degrees = -70
		colorTrack *= -1
