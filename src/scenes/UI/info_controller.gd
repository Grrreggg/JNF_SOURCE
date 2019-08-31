extends Node2D

var animator

func _ready():
	animator = get_node('Animator')

func _on_music_pressed():
	OS.shell_open('https://soundcloud.com/sundancemusic')

func _on_more_pressed():
	OS.shell_open('https://grrreggg.github.io/JNF_INFO/')

func show():
	animator.play('show')
	
func hide():
	animator.play('hide')