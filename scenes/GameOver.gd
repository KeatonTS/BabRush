extends Control

func _process(_delta):
	$Score.text = str($"../../Player".points)
	$Time.text = $"../Timer".current_time
