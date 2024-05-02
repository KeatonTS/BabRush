extends State
class_name Jump

func Enter():
	$"..".player.velocity.y = $"..".player.jump_height
	$"../../Motion".play("Jump")
	$"../../Sounds/Jump".play()
	
func Exit():
	pass
	
func Update(_delta):
	if $"..".player.knockout:
		state_transitioned.emit(self, "ko")

func Physics_Update(_delta):
	pass


func _on_jump_animation_finished():
	state_transitioned.emit(self, "fall")
