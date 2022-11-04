extends StaticBody2D

onready var initialPosition = position

var opening = false
var shouldPlay = true

func _physics_process(delta):
	if !opening:
		shouldPlay = true
	
	if opening:
		get_node("CollisionShape2D").disabled = true
		
		position.y = lerp(position.y, initialPosition.y + 64, delta * 5)
		if shouldPlay:
			get_node("AudioStreamPlayer2D").play()
			shouldPlay = false
