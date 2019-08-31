extends Node2D

export (NodePath) var player_node
var player

export (NodePath) var blood_node
var blood

export (NodePath) var sky_node
var sky

export (NodePath) var ui_node
var ui

export (NodePath) var animator_node
var animator

export (NodePath) var camera_mover_node
var camera_mover

var speed

var speed_time
var speed_timer

var speed_state
var dt

var speedup_steps
var speedup_mult

var counter

var game_state

export (AudioStream) var main_music

func _ready():
	game_state = CONSTANTS.GAME_STATES.MENU
	load_data()
	AudioPlayer.mute_music(!CONSTANTS.SAVE_DATA.sound)
	player = get_node(player_node)
	blood = get_node(blood_node)
	sky = get_node(sky_node)
	ui = get_node(ui_node)
	animator = get_node(animator_node)
	camera_mover = get_node(camera_mover_node)
	set_default_speed()
	speed_timer = 0
	speed_time = 2
	speed_state = CONSTANTS.SPED_STATES.IDLE
	speedup_steps = 0
	speedup_mult = 1
	counter = 0
	
	animator.play('intro')
	player.show()
	
	AudioPlayer.play_sound(main_music, true, true)
	
	ui.set_best(CONSTANTS.SAVE_DATA.scores)
	ui.show_best()
	
func virtual_button_pressed(btn):
	if player.is_blocked():
		return
		
	match btn:
		2:
			player.go(CONSTANTS.DIRECTIONS.RIGHT)
		1:
			player.go(CONSTANTS.DIRECTIONS.LEFT)
	
func _physics_process(delta):
	if !player.is_blocked():
		if Input.is_action_pressed("ui_right"):
			player.go(CONSTANTS.DIRECTIONS.RIGHT)
		if Input.is_action_pressed("ui_left"):
			player.go(CONSTANTS.DIRECTIONS.LEFT)
		if Input.is_action_pressed("ui_down"):
			pass
		if Input.is_action_pressed("ui_up"):
			pass
		
	speed_timer += delta
	match speed_state:
		CONSTANTS.SPED_STATES.SPEEDUP:
			if speed_timer >= speed_time:
				speed_timer = 0
				speedup()
				speedup_steps += 1
				if speedup_steps > 100:
					speedup_steps = 0
					speedup_mult *= 2
					
		CONSTANTS.SPED_STATES.SPEEDDOWN:
			if speed > CONSTANTS.SPEED:
				speed -= delta * dt
			else:
				speed_state = CONSTANTS.SPED_STATES.IDLE

func player_hit(pos):
	if game_state != CONSTANTS.GAME_STATES.GAME:
		return
	game_state = CONSTANTS.GAME_STATES.DEATH
	ui.save_scores(counter)
	slow_down()
	reset_speedup()
	speed_state = CONSTANTS.SPED_STATES.SPEEDDOWN
	blood.play(pos)
	player.block()
	animator.play('death')
	
	
func set_default_speed():
	speed = CONSTANTS.SPEED
	
func speedup():
	speed += CONSTANTS.SPEEDUP * speedup_mult
	
func get_speed():
	return speed
	
func slow_down(time = 0.5):
	dt = (speed - CONSTANTS.SPEED) / time
	sky.reset(time)
	counter = 0
	
func reset_speedup():
	speedup_steps = 0
	speedup_mult = 1
	
func count():
	if game_state == CONSTANTS.GAME_STATES.GAME:
		counter += 1
		sky.move()
	
func generate_empty():
	return game_state != CONSTANTS.GAME_STATES.GAME
	
func is_menu():
	return game_state == CONSTANTS.GAME_STATES.MENU
	
func play():
	game_state = CONSTANTS.GAME_STATES.GAME
	speed_state = CONSTANTS.SPED_STATES.SPEEDUP
	animator.play('game_started')
	ui.hide_logo()
	player.reset_pos()
	
func command(arg):
	ui.command(arg)
	
func load_data():
	var res = FS.load_game()
	
	if res == null:
		CONSTANTS.SAVE_DATA = CONSTANTS.SAVE_DEFAULT
		FS.save_game(CONSTANTS.SAVE_DATA)
	else:
		CONSTANTS.SAVE_DATA = res

func save_current_data():
	FS.save_game(CONSTANTS.SAVE_DATA)
	AudioPlayer.mute_music(!CONSTANTS.SAVE_DATA.sound)

func _on_MainAnimator_animation_finished(anim_name):
	match anim_name:
		'death':
			ui.reset_menu(true)
			#player.reset_pos()
			game_state = CONSTANTS.GAME_STATES.MENU
			speed_state = CONSTANTS.SPED_STATES.IDLE
			player.show()
			
func move_camera(direction = -1):
	var move_time = 0.7 * CONSTANTS.SPEED / get_speed()
	if move_time < 0.1: 
		move_time = 0.1
	camera_mover.move(direction, move_time)