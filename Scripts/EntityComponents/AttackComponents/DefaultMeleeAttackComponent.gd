extends AttackComponent
class_name  MeleeAttackComponent

@export var damage_hitbox_packed : PackedScene #of an area2D
var damage_hitbox : Area2D

@export var sword_slash_reset_timer : Timer

var sword_slash_num : int = 1

func more_onready_settings():
	damage_hitbox = damage_hitbox_packed.instantiate()
	add_child(damage_hitbox)
	
	if sword_slash_reset_timer:
		sword_slash_reset_timer.connect("timeout", _on_sword_slash_cooldown_timeout)


func sword_slash():
	#attack_stats : Attack
	
	if can_use_attack:
		
		if sword_slash_num <= 3: 
			damage_hitbox.swing(sword_slash_num)
			sword_slash_num += 1
	
			#timer cooldown stuff
			
		if weapon_cooldown_timer:
			if sword_slash_num <= 3:
				#print(sword_slash_num)
				can_use_attack = false
				weapon_cooldown_timer.start()
				sword_slash_reset_timer.stop()
			if sword_slash_reset_timer.is_stopped():
				sword_slash_reset_timer.start()
		pass


func _on_sword_slash_cooldown_timeout():
	sword_slash_num = 1
	damage_hitbox.select_swing_area(true, true)
	if weapon_cooldown_timer :
		can_use_attack = false
		weapon_cooldown_timer.start()
