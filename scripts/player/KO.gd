extends State
class_name KO

func Enter():
	$"..".player.position.y = 600
	$"..".player.velocity.y = 0
	$"../../Motion".play("KO")
	
func Exit():
	pass
	
func Update(_delta):
	if not $"..".player.knockout:
		state_transitioned.emit(self, "idle")

func Physics_Update(_delta):
	pass
