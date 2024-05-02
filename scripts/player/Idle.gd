extends State
class_name  Idle

func Enter():
	$"../../Motion".play("Idle")
	
func Exit():
	pass
	
func Update(_delta):
	if $"..".player.knockout:
		state_transitioned.emit(self, "ko")
		
	if $"..".player.velocity.x != 0 and $"..".player.is_on_floor():
		state_transitioned.emit(self, "run")
		
	if $"..".player.is_on_floor() and Input.is_action_pressed("jump"):
		state_transitioned.emit(self, "jump")

func Physics_Update(_delta):
	pass
