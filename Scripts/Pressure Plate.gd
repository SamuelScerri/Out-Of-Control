extends StaticBody2D

export(NodePath) onready var doorNode = get_node(doorNode) as Node
var activated = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(_delta):
	if !activated:
		doorNode.opening = true
		get_node("AnimatedSprite").play("Disabled")
	else:
		doorNode.opening = false
		get_node("AnimatedSprite").play("Enabled")
	
	activated = false
	
func keepActivated():
	activated = true	
