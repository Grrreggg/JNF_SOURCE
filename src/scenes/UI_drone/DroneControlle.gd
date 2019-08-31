extends Node2D

export (bool) var is_left
var options_texture
var def_pos 
var top_pos
var bot_pos
var need_to_appear
var tween 

export (AudioStream) var click_sound
export (AudioStream) var jet_sound

func _ready():
	options_texture = get_node('frame/icon')
	tween = get_node('Tween')
	def_pos = position
	top_pos = Vector2(def_pos.x, def_pos.y - 1000)
	bot_pos = Vector2(def_pos.x, def_pos.y + 500)
	need_to_appear = false
	appear()

func is_left():
	return is_left

func set_option(anim, frame = 0, instant = false):
	options_texture.animation = anim
	options_texture.frame = frame
	
	if instant:
		appear()
	else:
		disappear(true)

func appear():
	position = bot_pos
	tween.remove_all()
	tween.interpolate_property(self, 'position', bot_pos, def_pos, 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)		
	tween.start()	
	tween.interpolate_callback(AudioPlayer, 0.3, 'play_sound', jet_sound)
	
func disappear(and_show = false):
	need_to_appear = and_show
	tween.remove_all()
	tween.interpolate_property(self, 'position', def_pos, top_pos, 1, Tween.TRANS_QUAD, Tween.EASE_OUT)		
	tween.start()	
	AudioPlayer.play_sound(jet_sound)
	AudioPlayer.play_sound(click_sound)

func _on_Tween_tween_all_completed():
	if need_to_appear:
		need_to_appear = false
		appear()
