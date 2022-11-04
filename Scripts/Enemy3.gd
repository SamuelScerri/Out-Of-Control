extends KinematicBody2D

var velocity = Vector2.ZERO

var destroyed = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	velocity.y += delta * 10
	move_and_collide(velocity)
	
	if get_node_or_null("/root/Node2D/Rocket"):
		if get_node("/root/Node2D/Rocket").global_position > global_position:
			get_node("AnimatedSprite").flip_h = true
		else: get_node("AnimatedSprite").flip_h = false
	
	if get_node("RayCast2D").is_colliding():
		#for pressurePlate in get_node("/root/Node2D/Pressure Plate List").get_children():
		if get_node("RayCast2D").get_collider().is_in_group("Pressure Plate"):
			get_node("RayCast2D").get_collider().keepActivated()

func destroy():
	#get_node("CPUParticles2D").emitting = true
	#get_node("AnimatedSprite").modulate = Color.black
	
	get_node("CPUParticles2D").modulate = Color.black
	get_node("CPUParticles2D").emitting = true
	get_node("AnimatedSprite").modulate = Color(.1, .1, .1 ,1)
	get_node("CollisionShape2D").scale = Vector2(.1, .1)
	get_node("AnimatedSprite").stop()
	get_node("RayCast2D").enabled = false
	set_collision_layer_bit(1, false)
	set_collision_mask_bit(1, false)
	
	destroyed = true
