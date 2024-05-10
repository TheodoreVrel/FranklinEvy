extends Node2D
class_name MovementComponent

#Unit Speed
@export var initial_speed : float = 300.0
@export var speed_multiplier : float = 1
@onready var speed : float = initial_speed * speed_multiplier

@export var direction = Vector2(0, 1)

@export var dash_length : float
@export var dash_time : float

@export var dash_cooldown : Timer
@export var tp_cooldown : Timer

var can_tp : bool = true
var can_dash : bool = true

signal teleported


func _ready():
	if dash_cooldown:
		dash_cooldown.connect("timeout", _on_dash_cooldown_timeout)
	if tp_cooldown:
		tp_cooldown.connect("timeout", _on_teleport_cooldown_timeout)
	

func dash(dash_direction : Vector2):
	#print(can_dash)
	if can_dash:
		var arrival_point =  get_parent().position + dash_length * dash_direction.normalized()
		var tween = get_tree().create_tween()
		tween.tween_property(get_parent(), "position", arrival_point, dash_time)
		
		can_dash = false
		dash_cooldown.start()

func teleport(new_position : Vector2, delay : float):
	teleported.emit(can_tp)
	if can_tp:
		await get_tree().create_timer(delay).timeout
		get_parent().position = new_position
		
		can_tp = false
		tp_cooldown.start()
	


func _on_teleport_cooldown_timeout():
	can_tp = true
	print("end cooldown")
func _on_dash_cooldown_timeout():
	can_dash = true
	



