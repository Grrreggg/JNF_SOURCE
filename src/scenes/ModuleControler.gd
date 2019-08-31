extends Node2D
var CONSTANTS = preload("res://src/autoload/CONSTANTS.gd")
var wall_l
var wall_r

func _ready():
	wall_l = get_node('wall_l')
	wall_r = get_node('wall_r')
	
func generate(empty):
	if empty:
		wall_l.generate(true, true)
		wall_r.generate(true, true)
		return
	
	var rand = randi()%10
	var first_wall = wall_r
	var second_wall = wall_l
	if rand > 5:
		first_wall = wall_l
		second_wall = wall_r
		
	var res = first_wall.generate()
	match res:
		CONSTANTS.WALL_TYPES.EMPTY:
			second_wall.generate()
		CONSTANTS.WALL_TYPES.FAT:
			second_wall.generate(true)
		CONSTANTS.WALL_TYPES.STAFF_ONLY:
			second_wall.generate(true)
		CONSTANTS.WALL_TYPES.STAFF_FAT:
			second_wall.generate(true, true)

