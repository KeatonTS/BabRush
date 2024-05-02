extends Control


var time: float = 0.0
var minutes: int = 0
var seconds: int = 0
var current_time = ""

func _process(delta) -> void:
	if not $"../..".game_over:
		time += delta
		seconds = fmod(time, 60)
		minutes = fmod(time, 3600) / 60
		$Minute.text = "%02d:" % minutes
		$Second.text = "%02d" % seconds
		current_time = str($Minute.text + $Second.text)
