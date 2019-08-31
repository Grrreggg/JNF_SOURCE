extends Node2D

var rotonda
var animator
var tween
var drops = []
var dots = []

export (NodePath) var main_node
var main

func _ready():
	main = get_node(main_node)
	rotonda = get_node('rotation')
	animator = get_node('Animator')
	tween = get_node('Tween')
	for node in rotonda.get_children():
		drops.append(node.get_node('texture'))
	dots = get_node('dots').get_children()
	
func _physics_process(delta):
	if animator.is_playing():
		position.y += main.get_speed() * delta	
		
func play(pos):
	if animator.is_playing():
		return
	position = pos
	
	set_dots()
	rotonda.rotation_degrees = randi()%360
	for drop in drops:
		drop.frame = randi()%drop.frames.get_frame_count('default')
		
	animator.play('explode')

	
func set_dots():
	for dot in dots:
		dot.frame = randi()%dot.frames.get_frame_count('default')
		var pos = Vector2(pow(-1, randi()%4) * (randi()%20+5), pow(-1, randi()%4) * (randi()%20+5))
		dot.position = pos