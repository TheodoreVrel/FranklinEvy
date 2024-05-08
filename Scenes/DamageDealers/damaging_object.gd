extends Node2D
class_name DamagingObject

var attack : Attack

func _process(delta):
	print(attack)

func attack_hitbox_hit_unit_hurtbox(area):
	if area is HurtboxComponent:
		area.damage(attack)
		print("gqsnvjeqbgiebvieo")
