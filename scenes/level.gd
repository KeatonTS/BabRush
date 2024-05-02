extends Node2D

var enemy_scene_dict = {
	"polygon": preload("res://scenes/polygon_enemy.tscn"),
	"beter": preload("res://scenes/beter_enemy.tscn"),
	"spooke": preload("res://scenes/spooke_enemy.tscn"),
	"flangr": preload("res://scenes/flangr_enemy.tscn")
}
@onready var player = $Player

var milestone_met = false
var onigiri_scene = preload("res://scenes/onigiri_item.tscn") 
var game_over = false
var current_music = null
var can_restart = false
var enemy_speed = 500
var onigiri_speed = 500
var high_score = 0


func _ready():
	$StartTimer.start()
	current_music = $Sounds/LevelMusic
	current_music.play()
	_on_onigiri_spawn_timer_timeout()
	tween_text()


func _process(_delta):

	$UI/Onigiri_UI/OnigiriCount.text = str($Player.points) 
	if $Player.points == 10 or $Player.points == 20 or $Player.points == 30 or $Player.points == 50\
	 or $Player.points == 70 or $Player.points == 100:
		if not milestone_met:
			$UI/Controls.hide()
			increase_game_speed()
	
	if player.points > high_score:
		$UI/HighScore/OnigiriCount.text = str(player.points)

	if $Player.knockout and not game_over:
		if player.points > high_score:
			high_score = player.points
		end_game()

	if game_over and can_restart and Input.is_anything_pressed():
		restart_game()

func _physics_process(_delta):

	if player.position.x <= 10:
		player.position.x = 10
	if player.position.x >= 1270:
		player.position.x = 1270

func tween_text():
	await get_tree().create_timer(0.25).timeout
	$UI/Objective/Text.position.y = $UI/Objective/StartPos.position.y
	var text_tween = create_tween().set_parallel()
	var text_opacity_tween = create_tween().set_parallel()
	text_tween.tween_property($UI/Objective/Text, "position:y", $UI/Objective/GoalPos.position.y, 0.5).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	text_opacity_tween.tween_property($UI/Objective/Text, "modulate:a", 1, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	await get_tree().create_timer(1.5).timeout
	
	text_tween = create_tween().set_parallel()
	text_opacity_tween = create_tween().set_parallel()
	text_tween.tween_property($UI/Objective/Text, "position:y", $UI/Objective/EndPos.position.y, 0.5).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	text_opacity_tween.tween_property($UI/Objective/Text, "modulate:a", 0, 0.25).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


func increase_game_speed():
	milestone_met = true
	current_music.stop()
	enemy_speed += 200
	onigiri_speed += 200
	player.speed_up()
	if $Player.points == 10:
		current_music = $Sounds/LevelMusicx2
	elif $Player.points == 20:
		current_music = $Sounds/LevelMusicx4
	elif $Player.points == 30:
		current_music = $Sounds/LevelMusicx6
		
	$Sounds/SpeedUp.play()
	clear_level()
	$UI/SpeedUp/SpeedUpMotion.play("default")
	await $Sounds/SpeedUp.finished
	if not $Player.knockout:
		current_music.play()

func restart_game():
	tween_text()
	$UI/Controls.show()
	can_restart = false
	enemy_speed = 500
	onigiri_speed = 500
	current_music = $Sounds/LevelMusic
	$StartTimer.start()
	$Player.knockout = false
	$Player.points = 0
	$EnemySpawnTimer.start()
	$OnigiriSpawnTimer.start()
	$UI/Timer.minutes = 0
	$UI/Timer.seconds = 0
	$UI/Timer.time = 0.0
	$UI/GameOver.visible = false
	$UI/Onigiri_UI.visible = true
	$UI/Timer.visible = true
	$UI/SpeedUp/SpeedUpMotion.visible = true
	current_music.play()
	game_over = false

func end_game():
	$UI/Controls.hide()
	current_music.stop()
	$Sounds/GameOver.play()
	$EnemySpawnTimer.stop()
	$OnigiriSpawnTimer.stop()
	$UI/GameOver.visible = true
	$UI/Onigiri_UI.visible = false
	$UI/Timer.visible = false
	$UI/SpeedUp/SpeedUpMotion.visible = false
	clear_level()
	game_over = true
	await get_tree().create_timer(0.5).timeout
	can_restart = true


func clear_level():
	
	for enemy in $Enemies.get_children():
		enemy.queue_free()
	for onigiri in $Onigiri.get_children():
		onigiri.queue_free()

func generate_enemy_location(enemy, choice):
	if choice == 1:
		enemy.position = $GroundSpawnPoints.get_children()[randi() % $GroundSpawnPoints.get_children().size()].position
	else:
		enemy.position = $AirSpawnPoints.get_children()[randi() % $AirSpawnPoints.get_children().size()].position


func _on_enemy_spawn_timer_timeout():
	var chosen_enemy = enemy_scene_dict.values()[randi() % enemy_scene_dict.size()].instantiate() as CharacterBody2D
	$Enemies.add_child(chosen_enemy)
	
	if chosen_enemy.is_ground_enemy:
		var rand_choice_list = [0, 1]
		generate_enemy_location(chosen_enemy, rand_choice_list[randi() % rand_choice_list.size()])
	else:
		chosen_enemy.position = $AirSpawnPoints.get_children()[randi() % $AirSpawnPoints.get_children().size()].position


func _on_start_timer_timeout():
	#$Sounds/GO.play()
	pass

func _on_onigiri_spawn_timer_timeout():
	var onigiri = onigiri_scene.instantiate() as StaticBody2D
	$Onigiri.add_child(onigiri)
	onigiri.connect("item_collected", _on_item_collected)
	onigiri.position = $OnigiriSpawnPoints.get_children()[randi() % $OnigiriSpawnPoints.get_children().size()].position


func _on_item_collected():
	$Sounds/ItemCollected.play()
	$Player.points += 2
	milestone_met = false
	$UI/Onigiri_UI/OnigiriSprite.play("Collected")
	await $UI/Onigiri_UI/OnigiriSprite.animation_finished
	$UI/Onigiri_UI/OnigiriSprite.play("Default")
	
	
