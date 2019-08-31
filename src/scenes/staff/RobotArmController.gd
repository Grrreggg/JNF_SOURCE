extends Node2D

var animator
var animations

var blood_nodes = []
var blood_particles

var death_area

func _ready():
	animator = get_node('Animator')
	animations = animator.get_animation_list()
	launch_random_anim()
	
	blood_nodes = [
		get_node('Base/blood'),
		get_node('Base/part/blood'),
		get_node('Base/part/part/blood'),
		get_node('Base/part/part/part/blood'),
	]
	blood_particles = get_node("Base/Particles2D")
	
	death_area = get_node('Base/part/part/part/RobotArm/CollisionPolygon2D')
	
func launch_random_anim():
	randomize()
	var rand = randi()%animations.size()
	animator.play(animations[rand])

func _on_animation_finished(anim_name):
	launch_random_anim()

func show_blood():
	for node in blood_nodes:
		node.show()
	
	blood_particles.emitting = true
	
func hide_blood():
	for node in blood_nodes:
		node.hide()
	
	blood_particles.emitting = false
	
func show():
	death_area.disabled = false
	.show()
	
func hide():
	hide_blood()
	death_area.disabled = true
	.hide()

func _on_RobotArm_area_entered(area):
	show_blood()
