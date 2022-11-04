extends KinematicBody2D

var velocity = Vector2.ZERO
export var INTERVAL_SHOOT: float = 1

onready var bullet = load("res://Object/Bullet.tscn")
onready var explosion = load("res://Object/Fire.tscn")

export var DISTANCE_SHOOT: float = 150

var destroyed = false
onready var intervalShootCurrent = INTERVAL_SHOOT
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if intervalShootCurrent > 0:
		intervalShootCurrent -= delta
	
	if intervalShootCurrent < 0:
		
		if !destroyed:
			var bullet_instance = bullet.instance()
			bullet_instance.set_name("Bullet")
			bullet_instance.position = global_position
			var distance = global_position.distance_to(get_node("/root/Node2D/Buddy").position)
			if distance < DISTANCE_SHOOT:
				get_node('/root/Node2D').add_child(bullet_instance)
		
		intervalShootCurrent = INTERVAL_SHOOT
	
	if destroyed:
		velocity.y += delta * 10
		move_and_collide(velocity)

func destroy():
	#get_node("CPUParticles2D").emitting = true
	#get_node("AnimatedSprite").modulate = Color.black
	
	get_node("CPUParticles2D").modulate = Color.black
	get_node("CPUParticles2D").emitting = true
	get_node("AnimatedSprite").modulate = Color(.1, .1, .1 ,1)
	get_node("CollisionShape2D").scale = Vector2(.1, .1)
	get_node("AnimatedSprite").stop()
	
	set_collision_layer_bit(1, false)
	set_collision_mask_bit(1, false)
	
	destroyed = true
