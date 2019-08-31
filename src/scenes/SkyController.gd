extends Node2D

var min_y
var max_y
var tween

var layers = []
var def_layers_positions = []
var sky
var stars
var def_stars_position

func _ready():
	tween = get_node('Tween')
	min_y = -500
	max_y = 1200
	sky = get_node('Sky')
	layers = [
		get_node("layer_1"),
		get_node("layer_0"),
		get_node("sun"),
	]
	stars = get_node('stars')
	def_stars_position = stars.position
	for layer in layers:
		def_layers_positions.append(layer.position)
		
func reset(time = 0.3):
	var current_pos = sky.position
	var new_pos = current_pos
	new_pos.y = min_y
	tween.remove_all()
	tween.interpolate_property(sky, 'position', current_pos, new_pos, time, Tween.TRANS_QUAD, Tween.EASE_OUT)	
	tween.interpolate_property(stars, 'position', stars.position, def_stars_position, time, Tween.TRANS_QUAD, Tween.EASE_OUT)	
	for i in layers.size():
		tween.interpolate_property(layers[i], 'position', layers[i].position, def_layers_positions[i], time, Tween.TRANS_QUAD, Tween.EASE_OUT)			
	tween.start()
	
func move():
	if sky.position.y < max_y:
		sky.position.y += 1
		stars.position.y += 1
		for i in layers.size():
			layers[i].position.y += 1.5 / (i + 1)
		