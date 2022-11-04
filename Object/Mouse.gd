extends AnimatedSprite

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

# Called when the node enters the scene tree for the first time.
func _process(_delta):
	global_position = get_global_mouse_position()
