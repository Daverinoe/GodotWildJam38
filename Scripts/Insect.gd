extends KinematicBody2D

var speed = 0
var direction = Vector2()
var isLanded = false
var velocity = Vector2()
var fly = true

func _ready():
	direction = Vector2(randf()*2.0 - 1.0, randf()*2.0 - 1.0)
	$DirectionChange.wait_time = randf() * 5
	$FlyTime.wait_time = randf()
	$WaitTime.wait_time = randf()
	speed = randf() * 5 + 2

func _physics_process(delta):
	velocity = direction.normalized() * speed
	var collision
	if fly:
		collision = move_and_collide(velocity)
	if collision:
		direction = collision.normal + Vector2(randf()*2.0 - 1.0, randf()*2.0 - 1.0)

func _on_DirectionChange_timeout():
	direction = Vector2(randf()*2.0 - 1.0, randf()*2.0 - 1.0)
	$DirectionChange.wait_time = randf() * 5
	var speed = randf() * 2
	$DirectionChange.start()


func _on_FlyTime_timeout():
	fly = false
	$FlyTime.wait_time = randf() * 5
	$WaitTime.start()


func _on_WaitTime_timeout():
	fly = true
	$WaitTime.wait_time = randf() * 5
	$FlyTime.start()
