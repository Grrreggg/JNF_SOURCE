extends Node2D

var screen
var blink_timer 
var blink_time
var image_timer 
var image_time

var images = []

var blood_nodes = []
var blood_particles_nodes = []

var death_area

func _ready():
	blood_nodes = [
		get_node('Base/Base_bot/blood'),
		get_node('Base/Base_top/blood'),
	]
	blood_particles_nodes = [
		get_node('Base/Base_bot/blood/Particles2D'),
		get_node('Base/Base_top/blood/Particles2D'),
	]
	screen = get_node('Screen')
	images = screen.get_children()
	death_area = get_node('Billboard/CollisionShape2D')
	blink_timer = 0.07
	blink_time = 0
	image_timer = randi()%5+2
	image_time = 0
	random_image()
	
func _process(delta):
	blink_time += delta
	image_time += delta
	
	if blink_time > blink_timer:
		blink_time = 0
		var temp_modulate = Color(1,1,1,randf()*0.8+0.5)
		screen.self_modulate = temp_modulate
		
	if image_time > image_timer:
		image_time = 0
		random_image()
		
func random_image():
	for image in images:
		image.hide()
		
	var rand = randi()%images.size()
	images[rand].show()
	
func show_blood():
	for node in blood_nodes:
		node.show()
		
	for node in blood_particles_nodes:
		node.emitting = true
		
func hide_blood():
	for node in blood_nodes:
		node.hide()
	
	for node in blood_particles_nodes:
		node.emitting = false

func show():
	death_area.disabled = false
	.show()
	
func hide():
	hide_blood()
	death_area.disabled = true
	.hide()

func _on_Billboard_area_entered(area):
	show_blood()
