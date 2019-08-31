extends Node2D

var label
var animator
var numfield

func _ready():
	label = get_node('Best')
	animator = get_node('Animator')
	numfield = get_node('Numfield')
	
func set_num(num):
	numfield.set_num(num)

func show(new = false):
	var anim = 'new' if new else 'your'
	label.play(anim)
	animator.play('show')
	
func hide():
	animator.play('hide')