extends HBoxContainer

var numbers_nodes = []

func _ready():
	numbers_nodes = get_children()
	reset()

func set_num(num):
	reset()
	var str_num = str(num)

	for i in str_num.length():
		numbers_nodes[i].show()
		var num_node = numbers_nodes[i].get_node('num')
		num_node.play(str_num[i])
		
func reset():
	for node in numbers_nodes:
		node.hide()