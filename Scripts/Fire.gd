extends AnimatedSprite

func _ready():
	get_node("Hit").play()

func _on_Fire_animation_finished():
	queue_free()
