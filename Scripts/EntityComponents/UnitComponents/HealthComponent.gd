extends Node2D
class_name HealthComponent

#Unit Health
@export var max_health : int
var _current_health : int
@export var bonus_health : int
@export var armor : int
var current_health : int

@onready var unit = get_parent()


signal health_changed
signal death

func _ready():
	_current_health = max_health
	current_health = _current_health + bonus_health

func take_damage(damage: int):
	print(damage)
	var damage_taken = (damage - armor)
	var remaining_damage = damage_taken
	bonus_health -= remaining_damage
	if bonus_health < 0:
		remaining_damage = -bonus_health
		bonus_health = 0
	_current_health -= remaining_damage
	
	health_changed.emit()
	print(current_health, " health left")
	
	
	


func heal_damage(health : int):
	_current_health += health
	if _current_health >= max_health:
		_current_health = max_health
		
		health_changed.emit()

func gain_bonus_health(health : int):
	bonus_health += health
	
	health_changed.emit()

func _on_health_changed():
	current_health = _current_health + bonus_health
	if current_health <= 0:
		print(unit, " died")
		death.emit(unit)

