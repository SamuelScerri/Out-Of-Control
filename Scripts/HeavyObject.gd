extends Node2D

onready var explosion = load("res://Object/Fire.tscn")
onready var attachment1 = get_node("Heavy Object")

func _physics_process(_delta):
	if !get_node_or_null("Lamp Oil"):
		if get_node_or_null("Heavy Object"):
			attachment1.drop()
