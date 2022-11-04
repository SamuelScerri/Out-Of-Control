extends Camera2D

export var shakeAmount: float = 2
export var shakeDuration: float = 1

var shakeDurationCurrent = shakeDuration

var shouldShake = false

var screenCount = 1

func shake(shakeValue = 2):
	shakeAmount = shakeValue
	shouldShake = true

func _physics_process(delta):
	
	if Input.is_action_just_pressed("r"):
		get_tree().reload_current_scene()
	
	if shouldShake:
		shakeDurationCurrent -= delta
		self.set_offset(Vector2(rand_range(-1.0, 1.0) * shakeAmount,rand_range(-1.0, 1.0) * shakeAmount))

	if shakeDurationCurrent < 0:
		shouldShake = false
		shakeDurationCurrent = shakeDuration

func moveScreen():
	screenCount += 1
