extends "res://src/scenes/walls/wall_generic.gd"

func _ready():
	staff_pos = Vector2(-19, 56)
	staff_pos_fat = Vector2(-95, 56)
	wall = get_node('wall')
	wall_fat = get_node('fat')
	staff = get_node('staff').get_children()
	clear()