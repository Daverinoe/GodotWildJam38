extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var needleRotation = -150


# Called when the node enters the scene tree for the first time.
func _ready():
	$Needle.rotation_degrees = -150


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	checkNutrientLevel()


func _physics_process(_delta):
	$Needle.rotation_degrees = clamp(needleRotation, -150, 150)


func checkNutrientLevel():
	var gameNode = get_tree().root.get_node("Game")
	var currentNutrients = gameNode.nutrientLevels
	rotateNeedle(currentNutrients)
	
	# If nutrients are "good", sell for more $$$!
	if (currentNutrients < gameNode.upperOptimalNutrients) && (currentNutrients > gameNode.lowerOptimalNutrients):
		$goodnessIndicator.emitting = true
		$goodnessIndicator.process_material.set_color(Color(0.0, 1.0, 0.0, 1.0))
	elif (currentNutrients >= gameNode.tooNutrient): # But maybe nutrients are bad?? Then sell for less.
		$goodnessIndicator.emitting = true
		$goodnessIndicator.process_material.set_color(Color(1.0, 0.0, 0.0, 1.0))
	else:
		$goodnessIndicator.emitting = false

func rotateNeedle(nutrientLevels):
	# Renormalise nutrient value to between min and max
	needleRotation = (300) * ((nutrientLevels + 150) / (300) ) - 300
	
