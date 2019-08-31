extends Node2D

var animator

func _ready():
	animator = get_node('Animator')
	animator.play('scale')
