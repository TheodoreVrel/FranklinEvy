extends Node2D
class_name DamagingObject

var attack : Attack
var secondary_attack : Attack


func attack_hitbox_hit_unit_hurtbox(area, _attack : Attack):
	if area is HurtboxComponent:
		area.change_health(_attack)
		print("000000000000000000000000000000000  ", _attack.health_value)
