extends Node2D

var rect
var blood_node
var blood_particles
var flag_texture
var flag_texture_bood
var death_area

func _ready():
	rect = get_node('TextureRect')
	blood_node = get_node('Base/Blood')
	blood_particles = get_node('Base/Blood/Particles')
	
	death_area = get_node('Flag/CollisionPolygon2D')
	
	flag_texture = load('res://assets/world/flag/flag.png')
	flag_texture_bood = load('res://assets/world/flag/blood/blood_flag.png')
	
func show_blood():
	blood_node.show()
	blood_particles.emitting = true
	rect.texture = flag_texture_bood
	
func hide_blood():
	blood_node.hide()
	blood_particles.emitting = false
	rect.texture = flag_texture
	
func show():
	death_area.disabled = false
	.show()
	
func hide():
	hide_blood()
	death_area.disabled = true
	.hide()

func _on_Flag_area_entered(area):
	show_blood()
