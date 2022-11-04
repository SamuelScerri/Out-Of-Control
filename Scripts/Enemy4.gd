extends KinematicBody2D

var velocity = Vector2.ZERO

export var TIME_TO_OPEN = 2


onready var timeOpenCurrent = 0
var destroyed = false
var openMouthHotHotHot = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	velocity.y += delta * 10
	move_and_collide(velocity)
	
	if !destroyed:
	
		if timeOpenCurrent > 0:
			timeOpenCurrent -= delta
		else:
			if openMouthHotHotHot:
				get_node("AnimatedSprite").play("Close")
			else:
				get_node("AnimatedSprite").play("Open")
	
		if get_node("RayCast2D").is_colliding():
			#for pressurePlate in get_node("/root/Node2D/Pressure Plate List").get_children():
			if get_node("RayCast2D").get_collider().is_in_group("Pressure Plate"):
				get_node("RayCast2D").get_collider().keepActivated()

func destroy():
	#get_node("CPUParticles2D").emitting = true
	#get_node("AnimatedSprite").modulate = Color.black
	
	#get_node("CPUParticles2D").gravity.y = -get_node("CPUParticles2D").gravity.y
	get_node("CPUParticles2D").modulate = Color.black
	get_node("CPUParticles2D").emitting = true
	get_node("AnimatedSprite").modulate = Color(.1, .1, .1 ,1)
	get_node("AnimatedSprite").stop()
	get_node("CollisionShape2D").scale = Vector2(.1, .1)
	#get_node("AnimatedSprite").play("Dead")
	get_node("RayCast2D").enabled = false
	set_collision_layer_bit(1, false)
	set_collision_mask_bit(1, false)
	
	destroyed = true


func _on_AnimatedSprite_animation_finished():
	if openMouthHotHotHot:
		openMouthHotHotHot = false
	else: openMouthHotHotHot = true
	timeOpenCurrent = TIME_TO_OPEN
