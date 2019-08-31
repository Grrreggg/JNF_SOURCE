extends Node

var fires = []
var timer 
var time

func _ready():
	fires = [
		get_node('../Engine_L/FireGroup/Fire'),
		get_node('../Engine_R/FireGroup/Fire'),
	]
	timer = 0.05
	time = 0
	
func _process(delta):
	time += delta
	if time > timer:
		time = 0
		var temp_scale = Vector2(randf()*1.2+1, randf()*1.2+1)
		for fire in fires:
			fire.scale = temp_scale
		
