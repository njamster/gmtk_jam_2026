extends CharacterBody2D


const MOVE_SPEED := 160


func _ready():
	set_velocity(MOVE_SPEED * Vector2(2 * randf() - 1.0, 2 * randf() - 1.0).normalized())


func _physics_process(delta):
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		velocity = velocity.bounce(collision_info.get_normal())
