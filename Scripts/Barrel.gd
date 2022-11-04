extends StaticBody2D

var destroyed = false
onready var explosion = load("res://Object/Fire.tscn")

export var EXPLOSION_RADIUS: int = 64

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func destroy():
	var explosion_instance = explosion.instance()
	explosion_instance.set_name("Fire")
	explosion_instance.position = global_position
	explosion_instance.playing = true
		
	for enemy in get_tree().get_nodes_in_group("Enemy"):
		var distance = global_position.distance_to(enemy.global_position)
			
		if distance < EXPLOSION_RADIUS && !enemy.is_in_group("Shielded"):
			enemy.destroy()
		
	for rope in get_tree().get_nodes_in_group("Rope"):
		var distance = global_position.distance_to(rope.global_position)
			
		if distance < EXPLOSION_RADIUS:
			rope.queue_free()
		
	var distance = global_position.distance_to(get_node("/root/Node2D/Buddy").position)
		
	if distance < EXPLOSION_RADIUS:
		get_node("/root/Node2D/Buddy").destroy()
		
	explosion_instance.scale = Vector2(32 / 16, 32 / 16)
	get_node('/root/Node2D/Camera').shake()
	get_node('/root/Node2D').add_child(explosion_instance)
	
	queue_free()

func _draw():
	pass
	#draw_circle(Vector2.ZERO, EXPLOSION_RADIUS, Color(1, 0, 0, .1))
