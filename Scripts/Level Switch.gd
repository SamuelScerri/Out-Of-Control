extends Area2D

export(PackedScene) var level

var switchTime = false
var opacity = 1

onready var buddy = get_node("/root/Node2D/Buddy")

func _ready():
	get_node("Sprite").visible = false

func _process(delta):
	
	
	if !switchTime:
		if opacity > 0:
			opacity -= delta
	
	else:
		
		#buddy.camera.global_position.x = 320 + (buddy.camera.screenCount - 2) * 640 - 10
		#buddy.camera.smoothing_enabled = false
		
		if opacity < 1:
			opacity += delta * 5
	
	if opacity > 1:
		get_tree().change_scene(level.get_path())
	update()
	

func _on_Level_Switch_body_entered(body):
	if body == get_node("/root/Node2D/Buddy"):
		switchTime = true
		
	

func _draw():
	draw_rect(Rect2(-9999, -9999, 99999, 99999), Color(0, 0, 0, opacity))
	
