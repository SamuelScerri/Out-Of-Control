extends KinematicBody2D

export var rotationSpeed: int = 2

onready var explosion = load("res://Object/Fire.tscn")

export var ROCKET_RADIUS: int = 20
var angle = 0

export var TIMER = 7

onready var fontData = DynamicFont.new()

func _ready():
	fontData.font_data = load("res://Dev Resources/Font.ttf")
	
	get_node("AudioStreamPlayer2D").play()


func _physics_process(delta):
	var collision = move_and_collide(Vector2.RIGHT.rotated(rotation) * 100 * delta, false)
	
	TIMER -= delta
	
	if !get_node("/root/Node2D/Buddy").destroyed:
		angle = (get_global_mouse_position() - global_position).angle()
	
	global_rotation = lerp_angle(global_rotation, angle, delta * rotationSpeed)
	
	#var enemyHit = false
	
	if collision || TIMER < 0:
		var explosion_instance = explosion.instance()
		explosion_instance.set_name("Fire")
		explosion_instance.position = global_position
		explosion_instance.playing = true
		explosion_instance.scale = Vector2(4, 4)
		
		for enemy in get_tree().get_nodes_in_group("Enemy"):
			var distance = global_position.distance_to(enemy.global_position)
			
			if distance < ROCKET_RADIUS && !enemy.is_in_group("Shielded"):
				if enemy.is_in_group("Chatty"):
					if enemy.openMouthHotHotHot: enemy.destroy()
				
				else: enemy.destroy()
			
		
		for enemy in get_tree().get_nodes_in_group("Barrel"):
			var distance = global_position.distance_to(enemy.global_position)
			
			if distance < ROCKET_RADIUS:
				if enemy.is_in_group("Chatty"):
					if enemy.openMouthHotHotHot: enemy.destroy()
				
				else: enemy.destroy()
		
		
		for rope in get_tree().get_nodes_in_group("Rope"):
			var distance = global_position.distance_to(rope.global_position)
			
			if distance < ROCKET_RADIUS:
				rope.queue_free()
		
		var distance = global_position.distance_to(get_node("/root/Node2D/Buddy").position)
		
		if distance < ROCKET_RADIUS:
			get_node("/root/Node2D/Buddy").destroy()
		
		if collision:
			if collision.collider.is_in_group("Enemy") || collision.collider.is_in_group("Barrel") || collision.collider == get_node("/root/Node2D/Buddy"):
				if collision.collider.is_in_group("Shielded"): 
					if global_position.y < collision.collider.global_position.y - 1:
						collision.collider.destroy()
						#enemyHit = true
				
			
				elif collision.collider.is_in_group("Chatty"):
					if collision.collider.openMouthHotHotHot:
							collision.collider.destroy()
			
					#explosion_instance.get_node("Explosion").play()
				elif !collision.collider.is_in_group("Shielded") || !collision.collider.is_in_group("Chatty"):
					collision.collider.destroy()
				#enemyHit = true
		#if enemyHit:
			#explosion_instance.modulate.a = 0
		
		explosion_instance.scale = Vector2(ROCKET_RADIUS / 8, ROCKET_RADIUS / 8)
		get_node('/root/Node2D/Camera').shake()
		get_node('/root/Node2D').add_child(explosion_instance)
		
		queue_free()
	update()

func _draw():
	
	draw_line(Vector2(-TIMER, -10), Vector2(TIMER, -10), Color(TIMER * 10, 255, 255, 1), 2)
	#draw_circle(Vector2.ZERO, ROCKET_RADIUS, Color(1, 0, 0, .1))
