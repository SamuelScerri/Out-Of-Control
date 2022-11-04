extends KinematicBody2D

export var BULLET_SPEED = 300

onready var explosion = load("res://Object//Fire.tscn")

func _ready():
	look_at(get_node("/root/Node2D/Buddy").position)
	
func _physics_process(delta):
	var collision = move_and_collide(Vector2.RIGHT.rotated(rotation) * BULLET_SPEED * delta)
	
	if collision:
		if collision.collider == get_node("/root/Node2D/Buddy") || collision.collider.is_in_group("Enemy"):
			var explosion_instance = explosion.instance()
			explosion_instance.set_name("Fire")
			explosion_instance.position = global_position
			explosion_instance.playing = true
			
			explosion_instance.scale = Vector2(2, 2)
			get_node('/root/Node2D/Camera').shake()
			get_node('/root/Node2D').add_child(explosion_instance)
			
			get_node("/root/Node2D/Buddy").destroy()
		
		queue_free()
