extends State
class_name Fall

func Enter():
	$"../../Motion".play("Fall")
	
func Exit():
	pass
	
func Update(_delta):
	if $"..".player.knockout:
		state_transitioned.emit(self, "ko")
		
	if $"..".player.is_on_floor():
		state_transitioned.emit(self, "idle")
	

func Physics_Update(_delta):
	pass
