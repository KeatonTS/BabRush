extends CharacterBody2D

var gravity = 3000
var speed = 400
var jump_height = -1400
var knockout = false
var points = 0
	
func _physics_process(delta):
	if not knockout:
		var direction = Input.get_axis("left", "right")

		if direction == 1:
			$Motion.flip_h = false
		elif direction == -1:
			$Motion.flip_h = true
	
		velocity.y += gravity * delta
		velocity.x = direction * speed
		move_and_slide()
	else:
		pass


func _on_player_area_body_entered(body):
	if body.is_in_group("Enemy"):
		knockout = true


func speed_up():
	speed += 50

func reset_speed():
	speed = 400
