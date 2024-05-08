extends Node2D
class_name AttackComponent

@onready var attack : Attack = Attack.new()
@export var attack_name : String
@export var attack_damage : int = 1

#@export_enum("melee", "projectile") var attack_type
@export var knockback_force : float = 0.0
@export var stun_time : float = 0.3

@export var weapon_speed : float = 1.0
@export var weapon_cooldown : float = 0.5




func _ready():
	if attack_name == "":
		attack_name = self.name
	attack.health_value = attack_damage
	attack.knockback_force = knockback_force
	print("IIIIIIII - ", attack_name, " ", attack_damage, " damage")





