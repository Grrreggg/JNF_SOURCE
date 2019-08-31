extends Node2D

var position_tween
var engine_tween
var CONSTANTS = preload("res://src/autoload/CONSTANTS.gd")

var state
var positions = []
var position_num
var bot_position

var collision_shapes = []

var engine_busy 
var engine_nodes = {}
var engine_angles = {}

var pipes_particles = []

var angular_controller

export (NodePath) var main_node
var main

export (AudioStream) var jet_sound
export (AudioStream) var smash_sound

func _ready():
	main = get_node(main_node)
	position_tween = get_node('PositionTween')
	engine_tween = get_node('EngineTween')
	angular_controller = get_node('AngularController')

	collision_shapes = [
		get_node('DeathArea/CollisionShape0'),
		get_node('DeathArea/CollisionShape1'),
	]
	positions = [
		Vector2(100, 550),
		Vector2(190, 550),
		Vector2(290, 550),
	]
	bot_position = positions[1] + Vector2(0, 500)
	position_num = 1
	engine_busy = false
	engine_nodes = {
		'L' : get_node('Engine_L'),
		'R' : get_node('Engine_R'),
	}
	pipes_particles = [
		get_node('PipeParticles1'),
		get_node('PipeParticles2'),
	]
	engine_angles = {
		'L' : -45,
		'C' : 0,
		'R' : 45,
	}
	
	state = CONSTANTS.PLAYER_STATES.BLOCKED

func go(direction):
	if state == CONSTANTS.PLAYER_STATES.TRANSITION:
		return
	state = CONSTANTS.PLAYER_STATES.TRANSITION
	
	var last_position_num = position_num
	var angular_direction = 1
	
	match direction:
		CONSTANTS.DIRECTIONS.LEFT:
			position_num -= 1
			angular_direction = -1
			
		CONSTANTS.DIRECTIONS.RIGHT:
			position_num += 1
			
	position_num = normalize_position_num(position_num)
	
	if position_num == last_position_num:
		state = CONSTANTS.PLAYER_STATES.IDLE
		return
		
	if position_num > last_position_num:
		main.move_camera(-1)
	else:
		main.move_camera(1)
		
	angular_controller.apply_angle(angular_direction)
	move_engine(direction)
	AudioPlayer.play_sound(jet_sound)
	launch_tween(positions[last_position_num], positions[position_num])

func move_engine(direction):
	if engine_busy:
		return
	
	var incoming_angle = 0
	var rotation_speed = 0
	
	match direction:
		CONSTANTS.ENGINE_DIRECTIONS.LEFT:
			incoming_angle = engine_angles.L
		CONSTANTS.ENGINE_DIRECTIONS.RIGHT:
			incoming_angle = engine_angles.R
		CONSTANTS.ENGINE_DIRECTIONS.CENTER:
			incoming_angle = engine_angles.C
			
	engine_busy = true
		
	if  engine_nodes.L.rotation_degrees == incoming_angle:
		engine_busy = false
		return
			
	engine_tween.remove_all()
	engine_tween.interpolate_property(engine_nodes.L, 'rotation_degrees', engine_nodes.L.rotation_degrees, incoming_angle, 0.15, Tween.TRANS_QUAD, Tween.EASE_OUT)		
	engine_tween.interpolate_property(engine_nodes.R, 'rotation_degrees', engine_nodes.R.rotation_degrees, incoming_angle, 0.15, Tween.TRANS_QUAD, Tween.EASE_OUT)	
	engine_tween.start()	
		
			
func launch_tween(from, to):
	var move_time = 0.5 * CONSTANTS.SPEED / main.get_speed()
	if move_time < 0.1: 
		move_time = 0.1
		
	position_tween.remove_all()
	position_tween.interpolate_property(self, 'global_position', from, to, move_time, Tween.TRANS_LINEAR, Tween.EASE_IN)
	position_tween.start()
	
func normalize_position_num(num):
	var max_pos = positions.size() - 1
	
	if num >= max_pos:
		return max_pos
	elif num <= 0:
		return 0
	else:
		return num

func _on_PositionTween_tween_all_completed():
	position_tween.remove_all()
	state = CONSTANTS.PLAYER_STATES.IDLE
	
	if main.is_menu():
		reset_pos()

func reset_pos():
	match position_num:
		0:
			state = CONSTANTS.PLAYER_STATES.BLOCKED
			go(CONSTANTS.DIRECTIONS.RIGHT)
		2:
			state = CONSTANTS.PLAYER_STATES.BLOCKED
			go(CONSTANTS.DIRECTIONS.LEFT)

func _on_EngineTween_tween_all_completed():
	engine_busy = false
	move_engine(CONSTANTS.ENGINE_DIRECTIONS.CENTER)

func _on_DeathArea_area_entered(area):
	if area.get_name() == 'ui':
		main.command(area.get_parent().is_left())
		return
	main.player_hit(global_position)
	
func block():
	position_tween.seek(2)
	position_tween.remove_all()
	set_collisions_disabled()
	state = CONSTANTS.PLAYER_STATES.BLOCKED
	global_position = bot_position
	position_num = 1
	for node in pipes_particles:
		node.amount = 0
	AudioPlayer.play_sound(smash_sound)

func show():
	angular_controller.reset()
	position_num = 1
	position_tween.remove_all()
	position_tween.interpolate_property(self, 'global_position', bot_position, positions[1], 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	position_tween.interpolate_callback(self, 2, "set_collisions_enabled")
	position_tween.interpolate_callback(AudioPlayer, 0.8, 'play_sound', jet_sound)
	position_tween.start()
	.show()
	for node in pipes_particles:
		node.amount = 70
	
func set_collisions_enabled():
	set_collisions_disabled(false)

func set_collisions_disabled(arg = true):
	for shape in collision_shapes:
		shape.disabled = arg
		
func is_blocked():
	return state != CONSTANTS.PLAYER_STATES.IDLE