extends KinematicBody2D

var dropping = false
var velocity = Vector2()
onready var explosion = load("res://Object/Fire.tscn")

func _physics_process(delta):
	if dropping:
		velocity.y += delta * 25
	
	var collide = move_and_collide(velocity, false)
	
	if is_on_floor():
		velocity.y = 0
	
	if collide:
		if collide.collider.is_in_group("Enemy") || collide.collider.is_in_group("Barrel"):
			if !collide.collider.destroyed:
				get_node("/root/Node2D/Camera").shake()
				var explosion_instance = explosion.instance()
				explosion_instance.set_name("Fire")
				explosion_instance.position = global_position
				explosion_instance.playing = true
				if collide.collider.is_in_group("Barrel"):
					explosion_instance.scale = Vector2(4, 4)
					
				
				get_node('/root/Node2D').add_child(explosion_instance)
				
				collide.collider.destroy()
				
				if !collide.collider == get_node("/root/Node2D/Buddy"):
					collide.collider.queue_free()
				
				if collide.collider.is_in_group("Barrel"):
					queue_free()
				

		

func drop():
	dropping = true


func _on_Lamp_Oil_body_entered(body):
	if get_node_or_null("/root/Node2D/Rocket"):
		if body == get_node("/root/Node2D/Rocket"):
			get_node("/root/Node2D/Camera").shake()
			var explosion_instance = explosion.instance()
			explosion_instance.set_name("Fire")
			explosion_instance.position = global_position
			explosion_instance.playing = true
			explosion_instance.scale = Vector2(4, 4)
			
			get_node('/root/Node2D').add_child(explosion_instance)
			
			get_parent().get_node("Lamp Oil").queue_free()
			body.queue_free()
