extends Node2D
class_name HealthComponent

#Unit Health
@export var max_health : int
@export var _current_health : int
@export var bonus_health : int
@export var armor : int
var current_health = _current_health + bonus_health

signal health_changed
signal death

func _ready():
	_current_health = max_health + bonus_health

func take_damage(attack: Attack):
	var damage_taken = (attack.health_value - armor)
	var remaining_damage = damage_taken
	bonus_health -= remaining_damage
	if bonus_health < 0:
		remaining_damage = -bonus_health
		bonus_health = 0
	_current_health -= remaining_damage
	health_changed.emit()

func heal_damage(skill : Skill):
	_current_health += skill.health_value 
	if _current_health >= max_health:
		_current_health = max_health
		
		health_changed.emit()

func gain_bonus_health(skill : Skill):
	bonus_health += skill.health_value
	
	health_changed.emit()

func _on_health_changed():
	current_health = _current_health + bonus_health
	if current_health <= 0:
		print(get_parent(), " died")
		death.emit()

