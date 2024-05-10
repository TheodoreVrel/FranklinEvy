extends ProjectileAttackComponent


@export var total_throwing_knives : int = 3
var throwing_knives_left : int = total_throwing_knives


var secondary_attack : Attack = Attack.new()
var attack_2_name : String = "RippedDaggerBleed"
var attack_2_damage : int = 5
var attack_2_damage_2 : int = 10
var attack_2_damage_duration : float = 5
var attack_2_stun_time : float = 0.3

func more_onready_settings():
	secondary_attack.name = attack_2_name
	secondary_attack.change_duration = attack_2_damage_duration
	secondary_attack.health_value = attack_2_damage
	secondary_attack.health_value_2 = attack_2_damage_2
	secondary_attack.stun_time = attack_2_stun_time
	
