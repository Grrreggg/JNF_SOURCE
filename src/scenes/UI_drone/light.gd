extends Sprite

var pos_timer
var pos_time
var mod_timer
var mod_time
var def_pos
# Called when the node enters the scene tree for the first time.
func _ready():
	pos_time = 0.3
	pos_timer = 0
	mod_time = 0.025
	mod_timer = 0

	def_pos = position

func _process(delta):
	pos_timer += delta
	mod_timer += delta
	if pos_timer >= pos_time:
		pos_timer = 0
		move()
	if mod_timer >= mod_time:
		mod_timer = 0
		blink()
			
func blink():
	modulate = Color(1, 1, 1, randf()*1 + 0.7)
				
func move():
	position = def_pos + Vector2(pow(-1, randi()%4), pow(-1, randi()%4))