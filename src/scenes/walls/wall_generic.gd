extends Node2D

var CONSTANTS = preload("res://src/autoload/CONSTANTS.gd")

var staff_pos = Vector2()
var staff_pos_fat = Vector2()

var staff = []
var wall
var wall_fat
var billboard_id

func _ready():
	staff_pos = Vector2(19, 56)
	staff_pos_fat = Vector2(95, 56)
	wall = get_node('wall')
	wall_fat = get_node('fat')
	staff = get_node('staff').get_children()
	billboard_id = 0
	clear()
	
func clear():
	wall.show()
	wall_fat.hide()
	for node in staff:
		node.hide()

func generate(s_or_f = false, empty = false):
	clear()
	if empty:
		return CONSTANTS.WALL_TYPES.EMPTY
	var fat = false
	var staff = false
	
	fat = try_fat()
	if fat and s_or_f:
		return CONSTANTS.WALL_TYPES.FAT
	
	staff = try_staff(fat)
	#FAT STAFF
	var temp_ret = {
		true  : {
			true  : CONSTANTS.WALL_TYPES.STAFF_FAT,
			false : CONSTANTS.WALL_TYPES.FAT
		},
		false : {
			true  : CONSTANTS.WALL_TYPES.STAFF_ONLY,
			false : CONSTANTS.WALL_TYPES.EMPTY
		}
	}

	return temp_ret[fat][staff]

		
func try_fat():
	var rand = randi()%10
	var min_value = 3
	if rand > min_value:
		wall.hide()
		wall_fat.show()
	return rand > min_value
	
		
func try_staff(fat):
	var temp_pos = staff_pos_fat if fat else staff_pos
	var rand = randi()%(staff.size() + 1)
	if rand >= staff.size():
		return false
	if fat and rand == billboard_id:
		rand += 1
	staff[rand].position = temp_pos
	staff[rand].show()
	return true