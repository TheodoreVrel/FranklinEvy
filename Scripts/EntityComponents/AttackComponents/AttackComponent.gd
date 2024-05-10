extends Node2D
class_name AttackComponent

@onready var attack : Attack = Attack.new()
@export var attack_name : String
@export var attack_damage : int = 1
@export var damage_duration : float

#@export_enum("melee", "projectile") var attack_type
@export var knockback_force : float = 0.0
@export var stun_time : float = 0.3

@export var weapon_speed : float = 1.0
@export var weapon_cooldown_timer : Timer 

var can_use_attack : bool = true




func _ready():
	if attack_name == "":
		attack_name = self.name
	attack.health_value = attack_damage
	attack.knockback_force = knockback_force
	print("IIIIIIII - ", attack_name, " ", attack_damage, " damage")
	
	if weapon_cooldown_timer:
		weapon_cooldown_timer.connect("timeout", _on_weapon_cooldown_timeout)
	
	more_onready_settings()


func more_onready_settings():
	pass


func _on_weapon_cooldown_timeout():
	can_use_attack = true
	#print("can use attack : ", can_use_attack)
