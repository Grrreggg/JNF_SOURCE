extends Node2D

var  blood_node
var blood_particles_nodes = []
export (NodePath) var death_area_path
var death_area

func _ready():
	blood_node = get_node('blood')
	blood_particles_nodes = blood_node.get_children()
	death_area = get_node(death_area_path)
	death_area.get_parent().connect('area_entered', self, 'on_area_entered')
	
func show_blood():
	blood_node.show()
	for node in blood_particles_nodes:
		node.emitting = true
		
func hide_blood():
	blood_node.hide()
	for node in blood_particles_nodes:
		node.emitting = false
		
func show():
	death_area.disabled = false
	.show()
	
func hide():
	hide_blood()
	death_area.disabled = true
	.hide()
	
func on_area_entered(area):
	show_blood()