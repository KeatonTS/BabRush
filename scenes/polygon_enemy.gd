extends CharacterBody2D
var is_ground_enemy = true

var gravity = 3000
@onready var speed = get_tree().get_first_node_in_group("Level").enemy_speed


func _physics_process(delta):
	position.x -= speed * delta
	velocity.y += gravity * delta
	move_and_slide()
	
	if position.x < -100:
		queue_free()
