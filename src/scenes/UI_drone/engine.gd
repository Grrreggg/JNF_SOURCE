extends Node2D

var fire
var timer 
var time

func _ready():
	fire = get_node('fire')
	timer = 0.05
	time = 0
	
func _process(delta):
	time += delta
	if time > timer:
		time = 0
		var temp_scale = Vector2(randf()*1.2+1, randf()*1.2+1)
		fire.scale = temp_scale
		
