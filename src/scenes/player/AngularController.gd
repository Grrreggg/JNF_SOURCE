extends Node

var parts = {}

func _ready():
	parts = {
		'hair' : get_node('../Hair'),
		'arm_l' : get_node('../Arm_L'),
		'arm_r' : get_node('../Arm_R'),
	}
	
func apply_angle(direction):
	parts.hair.apply_torque_impulse(direction * 100)
	parts.arm_l.apply_torque_impulse(direction * 200)
	parts.arm_r.apply_torque_impulse(direction * 200)
	
func reset():
	parts.hair.set_applied_torque(0)
	parts.arm_l.set_applied_torque(0)
	parts.arm_r.set_applied_torque(0)