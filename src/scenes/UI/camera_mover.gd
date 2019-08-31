extends Node

var tween
var game

var amp
var last_time

func _ready():
	tween = get_node('Tween')
	game = get_parent()
	amp = 10
	
func move(direction = -1, time = 1, reset = false):
	time = time / 2
	last_time = time
	tween.remove_all()
	
	var pos_from = game.position
	var temp_amp = amp if is_finished() else amp / 2
	
	var pos_to = Vector2(temp_amp * direction, 0) if !reset else Vector2(0, 0)
	var style = Tween.EASE_IN if !reset else Tween.EASE_OUT
	tween.interpolate_property(game, 'position', pos_from, pos_to, time, Tween.TRANS_LINEAR, style)
	tween.start()

func _on_Tween_tween_all_completed():
	move(1, last_time, true)

func is_finished():
	return game.position == Vector2(0, 0)
