extends KinematicBody2D

# Play with to affect flocking behaviour
var SEPARATION_WEIGHT = 0.1
var ALIGNMENT_WEIGHT = 0.8
var COHESION_WEIGHT = 0.8
const MAX_AVOID_FORCE = 5.0

# How much the fish sells for
export(float, 0.0, 20.0, 0.1) var value = 10.0

# Fish growth details (Could replace with a curve)
export var SMALL_FISH_MODIFIER = 0.2
export var MEDIUM_FISH_MODIFIER = 0.6
export var LARGE_FISH_MODIFIER = 1.0
var currentModifier = SMALL_FISH_MODIFIER
var nutrientsGenerated = 1.5
var insectsEaten = 1

# Describes the velocity of the fish
export(float, 0.0, 5.0, 0.1) var speed = 2.0
var direction = Vector2();
var velocity = Vector2();
var isColliding = false
var avoidDirection = 0

# Flocking behaviour https://gamedevelopment.tutsplus.com/series/understanding-steering-behaviors--gamedev-12732
var localFlockmates = []
export(float, 0.0, 5.0, 0.1) var maxSpeed = 5.0
export(int, 0, 100, 1) var separationDistance = 40

# Sell dialogue
var sellDialogue = preload("res://Scenes/selldialogue.tscn")

func _ready():
	randomize()
	# Random initial direction for fish
	direction = Vector2(randf()*2.0-1.0, randf()*2.0-1.0).normalized()
	velocity = direction * speed
	
	# Random phase offset for shader
	var randPhase = PI*(randf()*2.0-1.0)
	$Sprite.material.set_shader_param("phase", randPhase)
	
	# Random choice of fish sprite
	var randFish = randi() % 2
	if randFish:
		$Sprite.frame = 0
	else:
		$Sprite.frame = 3

func _process(_delta):
	if get_tree().root.get_node_or_null("Game"):
		get_tree().root.get_node("Game").nutrientsChange += nutrientsGenerated

func _physics_process(delta):
	# Rotate fish to look in movement direction
	if abs(rotation - Vector2(1, 0).angle_to(direction)) > 0.2: # Add a rotation buffer to help avoid "jittering"
		rotation = Vector2(1, 0).angle_to(direction)
	
	if rotation > PI/2 || rotation < -PI/2:
		$Sprite.flip_v = true
	else:
		$Sprite.flip_v = false
	
	var collision = move_and_collide(direction * speed)
	direction = checkForCollisions(collision, delta)
	direction = flocking() # For flocking behaviour

func flocking():
	var separation = Vector2()
	var heading = direction
	var cohesion = Vector2()
	
	var numFlockmates = localFlockmates.size()
	
	for flockmate in localFlockmates:
		var flockMatePosition = flockmate.position
		# Add all directions for flockmates together to learn "overall" direction
		heading += flockmate.direction
		cohesion += flockMatePosition
		
		var distance = self.position.distance_to(flockMatePosition)
		
		if distance < separationDistance:
			separation -= (flockMatePosition - self.position).normalized() * (separationDistance / distance * speed)
	
	if numFlockmates > 0:
		heading /= numFlockmates
		cohesion /= numFlockmates
		var centerDirection = self.position.direction_to(cohesion)
		var centerSpeed = self.position.distance_to(cohesion) / $FlockDetector/CollisionShape2D.shape.radius
		cohesion = centerDirection * centerSpeed
	
	return(
		(direction
		+ separation * SEPARATION_WEIGHT
		+ heading * ALIGNMENT_WEIGHT
		+ cohesion * COHESION_WEIGHT
		).normalized())


func _on_FlockDetector_body_entered(body):
	if body == self:
		return
	
	if body.is_in_group("boid"):
		localFlockmates.push_back(body)


func _on_FlockDetector_body_exited(body):
	if body.is_in_group("boid"):
		localFlockmates.erase(body)

func checkForCollisions(collision, delta):
	
	var orthoVec = Vector2()

	if $CenterCheck.is_colliding():
		if !isColliding:
			avoidDirection = randi() % 2
			isColliding = true
		if avoidDirection:
			orthoVec = Vector2(-direction.y, direction.x)
		else:
			orthoVec = Vector2(direction.y, -direction.x)

		return direction + orthoVec * MAX_AVOID_FORCE * 10 * delta

	if isColliding:
		isColliding = false

	if collision:
		if collision.collider is StaticBody2D:
			return collision.normal
		elif collision.collider is Area2D:
			pass
		else:
			return direction
	
	return direction


func _on_Adolescence_timeout():
	$Sprite.frame += 1
	value = 30
	SEPARATION_WEIGHT = 0.6
	ALIGNMENT_WEIGHT = 0.2
	COHESION_WEIGHT = 0.1
	
	nutrientsGenerated *= 2
	insectsEaten *= 2
	
	$CollisionShape.shape.radius = 7
	$CollisionShape.shape.height = 12
	
	$Adulthood.start()


func _on_Adulthood_timeout():
	$Sprite.frame += 1
	value = 50
	SEPARATION_WEIGHT = 1.0
	ALIGNMENT_WEIGHT = 0.0
	COHESION_WEIGHT = 0.0
	
	nutrientsGenerated *= 2
	insectsEaten *= 2
	
	$CollisionShape.shape.radius = 7
	$CollisionShape.shape.height = 16


func _on_Fish_input_event(_viewport, event, _shape_idx):
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


func _on_Fish_mouse_entered():
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	
func _on_Fish_mouse_exited():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)


