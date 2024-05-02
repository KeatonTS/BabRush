extends StaticBody2D

@onready var speed = get_tree().get_first_node_in_group("Level").onigiri_speed
@onready var item_area = $ItemArea
@onready var motion = $Motion

signal item_collected

func _physics_process(delta):
	position.x -= speed * delta


func _on_item_area_entered(area):
	
	if area.get_parent().is_in_group("Player"):
		item_area.set_deferred("monitoring", false)
		speed = 0
		item_collected.emit()
		motion.play("collected")
		await motion.animation_finished
		queue_free()

