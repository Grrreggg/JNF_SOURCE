extends Node2D

var modules = []
var init_y
var death_y
var module_h
var calcuated_delta
var empty

var order_map = {}

export (NodePath) var main_node
var main

func _ready():
	modules = get_children()
	init_y = modules[0].position.y
	module_h = 152
	death_y = modules[-1].position.y + module_h
	empty = false
	main = get_node(main_node)
	order_map = {
		'Module_0' : [0,1,2,3,4,5],
		'Module_5' : [5,0,1,2,3,4],
		'Module_4' : [4,5,0,1,2,3],
		'Module_3' : [3,4,5,0,1,2],
		'Module_2' : [2,3,4,5,0,1],
		'Module_1' : [1,2,3,4,5,0],
	}
	
func _physics_process(delta):
	var speed = main.get_speed()
	
	for module in modules:
		module.position.y += speed * delta
			
	for module in modules:
		if module.position.y >= death_y:
			module.generate(empty or main.generate_empty())
			empty = !empty
			
			var i = 0
			for n in order_map[module.get_name()]:
				var node = get_node('Module_' + str(n))
				node.position.y = init_y + module_h * i + speed * delta
				i += 1
				
			main.count()
			return 
				
		
