extends Node2D

var drone_l
var drone_r

var logo

var menu_ready = true

export (NodePath) var main_node
var main

export (NodePath) var best_node
var best

export (NodePath) var info_node
var info

var left_options = [
	'back',
	'exit',
	'sound',
	'info',
	]

var right_options = [
	'play',
	'next',
	]
	
var left_option = 0
var right_option = 0

func _ready():
	main = get_node(main_node)
	best = get_node(best_node)
	info = get_node(info_node)
	drone_l = get_node('drone_l')
	drone_r = get_node('drone_r')
	logo = get_node('LogoGroup')
	reset_menu(true)

func command(is_left):
	hide_best()
	info.hide()
	if is_left:
		if menu_ready:
			menu_ready = false
			drone_l.set_option(left_options[left_option])
			drone_r.set_option('next')
		else:
			match left_option:
				0:
					reset_menu()
				1:
					get_tree().quit()
				2:
					CONSTANTS.SAVE_DATA.sound = !CONSTANTS.SAVE_DATA.sound
					main.save_current_data()
					drone_l.set_option('sound', 1 if CONSTANTS.SAVE_DATA.sound else 0)
				3:
					logo.hide()
					info.show()
					
	if !is_left:
		if !menu_ready:
			left_option += 1
			if left_option > left_options.size() - 1:
				left_option = 0
			if left_option < 0:
				left_option = left_options.size() - 1
			set_left_options()
		else:
			main.play()
			drone_l.disappear()
			drone_r.disappear()
	
func reset_menu(instant = false):
	drone_r.set_option('play', 0, instant)
	right_option = 0
	drone_l.set_option('menu', 0, instant)
	menu_ready = true
	left_option = 0
	
func set_left_options():
	var frame = 0
	if left_option == 2 and CONSTANTS.SAVE_DATA.sound:
		frame = 1
		
	drone_l.set_option(left_options[left_option], frame)
	
func hide_logo():
	logo.hide()
	
func set_best(num):
	best.set_num(num)
	
func show_best(new = false):
	best.show(new)
	
func hide_best():
	best.hide()
	
func save_scores(scores):
	if scores > CONSTANTS.SAVE_DATA.scores:
		set_best(scores)
		show_best(true)
		CONSTANTS.SAVE_DATA.scores = scores
	
	main.save_current_data()