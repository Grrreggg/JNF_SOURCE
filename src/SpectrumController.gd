extends Sprite

var active
var timer
var time

func _ready():
	active = true
	time = 0.05
	timer = 0
	
func activate(arg = true):
	active = arg
	
func _process(delta):
	if !active:
		return
	timer += delta
	
	if timer >= time:
		var spectrum = AudioPlayer.get_spectrum()
		modulate = Color(1, 1, 1, 1-spectrum/100)
		timer = 0