extends KinematicBody2D

# Play with to affect flocking behaviour
var SEPARATION_WEIGHT = 0.0
var ALIGNMENT_WEIGHT = 0.8
var COHESION_WEIGHT = 0.6
const MAX_AVOID_FORCE = 1.0

# How much the fish sells for
export(float, 0.0, 20.0, 0.1) var maxValue = 50.0

# Fish growth details (Could replace with a curve)
export var SMALL_FISH_MODIFIER = 0.2
export var MEDIUM_FISH_MODIFIER = 0.6
export var LARGE_FISH_MODIFIER = 1.0
var currentModifier = SMALL_FISH_MODIFIER

# Describes the velocity of the fish
export(float, 0.0, 5.0, 0.1) var speed = 2.0
var direction = Vector2();
var velocity = Vector2();

# Flocking behaviour https://gamedevelopment.tutsplus.com/series/understanding-steering-behaviors--gamedev-12732
var localFlockmates = []
var walls = []
export(float, 0.0, 5.0, 0.1) var maxSpeed = 2.0
export(int, 0, 100, 1) var separationDistance = 30

# Sell dialogue
var sellDialogue = preload("res://Scenes/SellDialogue.tscn")

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
		$Sprite.frame = 6
	else:
		$Sprite.frame = 9
	
	# Set raycasts for obstacle avoidance
	var theta = PI/2
	var parity = 1
#	for raycast in $RayCasts.get_children():
#		raycast.cast_to = Vector2(50*sin(theta) * parity, 50*cos(theta))
#		if parity == 1:
#			theta = theta + PI/8
#		parity *= -1

func _physics_process(delta):
	# Rotate fish to look in movement direction
	rotation = Vector2(1, 0).angle_to(direction)
	if rotation > PI/2 || rotation < -PI/2:
		$Sprite.flip_v = true
	else:
		$Sprite.flip_v = false
	
	velocity = (direction * speed).clamped(maxSpeed * 1 / currentModifier)
	move_and_collide(velocity)
	direction = checkForCollisions() # For flocking behaviour
	direction = flocking()

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
		var centerSpeed = maxSpeed * self.position.distance_to(cohesion) / $FlockDetector/CollisionShape2D.shape.radius
		cohesion = centerDirection * centerSpeed
		
	return(
		(direction
		+ separation * clamp(SEPARATION_WEIGHT + currentModifier, 0, 1.0)
		+ heading * clamp(ALIGNMENT_WEIGHT - currentModifier, 0, 1.0)
		+ cohesion * clamp(COHESION_WEIGHT - currentModifier, 0, 1.0)
		).normalized())


func _on_FlockDetector_body_entered(body):
	if body == self:
		return
	
	if body.is_in_group("boid"):
		localFlockmates.push_back(body)


func _on_FlockDetector_body_exited(body):
	if body.is_in_group("boid"):
		localFlockmates.erase(body)

func checkForCollisions():
	var projection = Vector2()
	
	# Raycast global variables
	var raycastGlobalOrigin = Vector2()
	var raycastGlobalEndpoint = Vector2()
	var raycastGlobalCastTo = Vector2()
	
#	projection = direction.dot(collision.normal) / direction.length() * direction
#	return (collision.normal - projection).normalized() * MAX_AVOID_FORCE
	
	for raycast in $RayCasts.get_children():
		if !raycast.is_colliding():
			raycastGlobalOrigin = raycast.to_global(position)
			raycastGlobalEndpoint = raycast.to_global(raycast.cast_to)
			raycastGlobalCastTo = raycastGlobalEndpoint - raycastGlobalOrigin
			print([raycastGlobalOrigin, raycastGlobalEndpoint, raycastGlobalCastTo.normalized()])
			return (raycast.to_local(raycastGlobalCastTo)).normalized()
	
	return direction


func _on_Adolescence_timeout():
	$Sprite.frame += 1
	currentModifier = MEDIUM_FISH_MODIFIER


func _on_Adulthood_timeout():
	$Sprite.frame += 1
	currentModifier = LARGE_FISH_MODIFIER


func _on_Fish_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		var sellInstance = sellDialogue.instance()
		self.call_deferred("add_child", sellInstance)
		sellInstance.get_node("SellDialogue/MarginContainer/Background/Sell").text = str(round(maxValue * currentModifier))
