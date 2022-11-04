extends KinematicBody2D

export var PLAYER_SPEED: int = 250
export var PLAYER_MAX_SPEED: int = 250
export var PLAYER_STOP_SPEED: int = 5
export var PLAYER_RADIUS: int = 16 * 10
export var ROCKET_AMOUNT: int = 2

export var EXPLODE_ON_WALL_TOUCH: bool = true

export var GRAVITY: int = 250

var velocity = Vector2()
var storeVelocity = Vector2()

var shouldMove = true
var shouldPlay = true
var shouldFire = true
var destroyed = false

var radiusColor = Color(1, 0, 0, .1)

var enemyTarget

var fireNow = false

onready var rocketsLeft = ROCKET_AMOUNT

onready var rocket = load("res://Object/Rocket.tscn")
onready var gunPivot = get_node("Gun Pivot")
onready var soundBeep = get_node("AudioStreamPlayer2D")
onready var camera = get_node("/root/Node2D/Camera")
onready var rayCast = get_node("RayCast2D")
onready var bullet = load("res://Object/Bullet.tscn")

onready var initialPosition = global_position

var collision

var rocketTimeOut = .25
var rocketTimeOutCurrent = rocketTimeOut

func _ready():
	get_node("/root/Node2D/CanvasLayer/TextEdit").text = "ROCKETS LEFT: " + str(rocketsLeft)
	pass

func isAimed(delta):
	velocity.x = 0
	velocity.y = 0
	
	var angle = 0
	if is_instance_valid(enemyTarget):
		angle = (enemyTarget.global_position - gunPivot.global_position).angle()
		gunPivot.global_rotation = lerp_angle(gunPivot.global_rotation, angle, delta * 20)
	
	if shouldPlay:
		shouldPlay = false
		soundBeep.play()
	
	return fireNow

func resetRotation(delta):
	gunPivot.global_rotation = lerp(gunPivot.global_rotation, 0, delta *  5)

func fire():
	var rocket_instance = rocket.instance()
	rocket_instance.set_name("Rocket")
	rocket_instance.position = gunPivot.get_node("Gun").global_position
	rocket_instance.rotation = gunPivot.get_node("Gun").global_rotation
	
	get_node("/root/Node2D").add_child(rocket_instance)
	
	
func _physics_process(delta):
	if !destroyed:
		
		#var collided = move_and_collide(Vector2(10, 0), false)
	
		#if is_on_wall() && EXPLODE_ON_WALL_TOUCH:
			
			#fire()
	
		if global_position.x > camera.screenCount * 640:
			camera.moveScreen()
	
		if shouldMove:
			rocketTimeOutCurrent -= delta
			
			for enemy in get_tree().get_nodes_in_group("Enemy"):
				var distance = global_position.distance_to(enemy.global_position)
			
				if !enemy.destroyed:
					if distance < 10:
						var bullet_instance = bullet.instance()
						bullet_instance.set_name("Bullet")
						bullet_instance.position = global_position
						get_node('/root/Node2D').add_child(bullet_instance)
			for enemy in get_tree().get_nodes_in_group("Shielded"):
				var distance = global_position.distance_to(enemy.global_position)
			
				if !enemy.destroyed:
					if distance < 20:
						var bullet_instance = bullet.instance()
						bullet_instance.set_name("Bullet")
						bullet_instance.position = global_position
						get_node('/root/Node2D').add_child(bullet_instance)
			
			camera.global_position = Vector2(320, 240)
			camera.global_position.x = clamp(camera.global_position.x, 320 + (camera.screenCount - 1) * 640 - 10, 320 + (camera.screenCount - 1) * 640 + 10)
			camera.global_position.y = clamp(camera.global_position.y, 240 - 20, 240 + 20)
			camera.zoom.x = lerp(camera.zoom.x, 1, delta * 2)
			camera.zoom.y = lerp(camera.zoom.y, 1, delta * 2)
		
			if is_on_floor():
				if velocity.x < PLAYER_MAX_SPEED:
					velocity.x += delta * PLAYER_SPEED
				
				velocity.y = 0
				
				get_node("Sprite").play("Move")
				
				if rayCast.is_colliding():
					if rayCast.get_collider().is_in_group("Bouncy Plate"):
						velocity.y = -GRAVITY / 1.2
						get_node("Boom").play()
						camera.shake(.5)
				
				
			#else:velocity.x = lerp(velocity.x, PLAYER_MAX_SPEED, delta * PLAYER_STOP_SPEED)
			else:
				storeVelocity = velocity
				
				get_node("Sprite").play("Fly")
				velocity.x = clamp(velocity.x, 0, PLAYER_MAX_SPEED * .5)
				
		
			velocity.y += delta * GRAVITY
			shouldMove = checkEnemyDistance()

		else:
			#READY, AIM.... AAAAANNNNNNNNNDDDDDDD
			if shouldFire:
				
				if enemyTarget:
					if isAimed(delta):

						fireNow = false
						shouldFire = false
						fire()

					#camera.shake()
			else: resetRotation(delta)
			if get_node_or_null("/root/Node2D/Rocket"):
				camera.global_position = get_node_or_null("/root/Node2D/Rocket").global_position - Vector2(320 / 2, 240 / 2)
				camera.global_position.x = clamp(camera.global_position.x, 320 + (camera.screenCount - 1) * 640 - 75, 320 + (camera.screenCount - 1) * 640 + 75)
				camera.global_position.y = clamp(camera.global_position.y, 240 - 10, 240 + 20)
				
				camera.zoom.x = lerp(camera.zoom.x, .8, delta * 2)
				camera.zoom.y = lerp(camera.zoom.y, .8, delta * 2)

			if !shouldFire && !get_node_or_null("/root/Node2D/Rocket"):
				velocity = storeVelocity
				
				shouldFire = true
				shouldPlay = true
				shouldMove = true
				fireNow = false
				
				rocketTimeOutCurrent = rocketTimeOut


			#velocity.x = lerp(velocity.x, 0, delta * PLAYER_STOP_SPEED)
			#velocity.y = lerp(velocity.y, 0, delta * 100)
	
	else:
		velocity.x = 0
		velocity.y += delta * GRAVITY
	
		get_node("Sprite").modulate = Color.black
		get_node("Gun Pivot/Gun").visible = false
		get_node("CPUParticles2D").emitting = true
		get_node("Sprite").play("Fly")
		get_node("Sprite").stop()
	
	collision = move_and_slide(velocity, Vector2.UP, false, 4, 0.785398, false)
	

	
	update()

func checkEnemyDistance():
	var inRange = false
	
	for enemy in get_tree().get_nodes_in_group("Enemy"):
		var distance = global_position.distance_to(enemy.global_position)
		
		if distance < PLAYER_RADIUS && !enemy.destroyed:
			inRange = true
			
			radiusColor.r = 1
			radiusColor.g = 0
			
			enemyTarget = enemy
			
			if Input.is_key_pressed(KEY_SPACE) && !get_node_or_null("/root/Node2D/Rocket"):
				if rocketTimeOutCurrent < 0:
				
					if rocketsLeft > 0:
						rocketsLeft -= 1
						get_node("/root/Node2D/CanvasLayer/TextEdit").text = "ROCKETS LEFT: " + str(rocketsLeft)
						return false
	
	if !inRange:
		radiusColor.g = 1
		radiusColor.r = 0
	
	return true

func _draw():
	draw_circle(Vector2.ZERO, PLAYER_RADIUS, radiusColor)


func _on_AudioStreamPlayer2D_finished():
	fireNow = true

func destroy():
	get_node("/root/Node2D/CanvasLayer/Over").visible = true
	destroyed = true
