extends CharacterBody2D

@onready var movement_component : MovementComponent = $MovementComponent
@onready var throwing_knife_attack : ProjectileAttackComponent = $Attacks/PlumeDaggerAttack
@onready var animated_player_sprite : AnimatedSprite2D = $AnimatedSprite2D

var total_throwing_knives : int = 10
var throwing_knives_left : int = total_throwing_knives

enum throw_angle{RIGHT, LEFT}
var last_throw_angle : throw_angle = 0

var last_recorded_input = Vector2.ZERO
var last_recorded_mouse_direction = Vector2.ZERO

var input_direction
var no_input : bool = input_direction == null or input_direction == Vector2(0,0)

@onready var direction_arrow = $Rotatable/LookingThisWay

@export var tp_focus_timer : Timer
var tp_focused : bool = false
var hovered_dagger : ThrowingDagger
var focused_dagger : ThrowingDagger
signal teleporting


func _ready():
	if tp_focus_timer:
		print("timer linked")
		tp_focus_timer.connect("timeout", _on_teleport_focus_timer_timeout)

func _physics_process(delta):
	get_input()
	move_and_slide()
	
	
	$Rotatable.rotation = get_global_mouse_position().angle_to_point(position) + deg_to_rad(90)


func get_input():
	input_direction = Input.get_vector("left", "right", "up", "down")
	no_input = input_direction == null or input_direction == Vector2(0,0)
	
	last_recorded_mouse_direction = get_local_mouse_position().normalized()
	if !no_input:
		last_recorded_input = input_direction
	
		velocity = input_direction * movement_component.speed
		
	else:
		velocity.x = move_toward(velocity.x, 0, movement_component.speed)
		velocity.y = move_toward(velocity.y, 0, movement_component.speed)
	
	var mouse_direction_is_up : bool = last_recorded_mouse_direction.y <= -.5 and last_recorded_mouse_direction.x <= .5 and last_recorded_mouse_direction.x >= -.5
	var mouse_direction_is_right : bool = last_recorded_mouse_direction.x >= .5 and last_recorded_mouse_direction.y <= .5 and last_recorded_mouse_direction.y >= -.5
	var mouse_direction_is_down : bool = last_recorded_mouse_direction.y >= .5 and last_recorded_mouse_direction.x <= .5 and last_recorded_mouse_direction.x >= -.5
	var mouse_direction_is_left : bool = last_recorded_mouse_direction.x <= -.5 and last_recorded_mouse_direction.y <= .5 and last_recorded_mouse_direction.y >= -.5
	
	#print(last_recorded_mouse_direction,"    ",mouse_direction_is_down, mouse_direction_is_left, mouse_direction_is_right, mouse_direction_is_up)
	
	if mouse_direction_is_right: 
		if no_input:
			animated_player_sprite.play("Idle_right")
		else:
			animated_player_sprite.play("Running_right")
	
	elif mouse_direction_is_left:
		if no_input:
			animated_player_sprite.play("Idle_left")
		else:
			animated_player_sprite.play("Running_left")
	
	elif mouse_direction_is_down:
		if no_input:
			animated_player_sprite.play("Idle_down")
		else: 
			animated_player_sprite.play("Running_down")
	
	elif mouse_direction_is_up :
		if no_input:
			animated_player_sprite.play("Idle_up")
		else :
			animated_player_sprite.play("Running_up")
	
	#elif input_direction == null or input_direction == Vector2(0,0):
		#if  last_recorded_input.x >= 1:
			#
		#elif last_recorded_input.x <= -1:
			#
		#elif last_recorded_input.y >= 1:
			#
		#elif last_recorded_input.y <= -1:
			
	
	if Input.is_action_just_pressed("dash"):
		movement_component.dash(last_recorded_input)
		#print(movement_component.speed)
	
	if Input.is_action_just_pressed("alt_attack"):
		var projectile_emission_point = get_throwing_knife_emission_position()
		var throw_to_max_distance : bool = !(throwing_knife_attack.projectile_distance > projectile_emission_point.distance_to(get_global_mouse_position()))
		#print("throwing to max distance : ", throw_to_max_distance)
		attack_throwing_knife(projectile_emission_point, get_local_mouse_position(), throw_to_max_distance)
	
	if Input.is_action_just_pressed("action_1") and hovered_dagger:
		tp_focus_timer.start()
		focused_dagger = hovered_dagger
		focused_dagger.show_focused()
		
		print(tp_focused, "  ", tp_focus_timer.time_left)
		print("action")

	#if Input.is_action_pressed("action_1"):
#
		#print(tp_focused, "  ", tp_focus_timer.time_left)
	
	if Input.is_action_just_released("action_1"):
		
		if tp_focused and position.distance_to(focused_dagger.position) < focused_dagger.max_distance_tp:
			tp_to_dagger()
			print("focused")
		else :
			tp_focus_timer.stop()
			if focused_dagger:
				focused_dagger.show_focused(false)
				focused_dagger = null
			print("unfocused")
		print(tp_focused, "  ", tp_focus_timer.time_left)






func attack_throwing_knife(emitting_position : Vector2, throwing_towards : Vector2, throw_to_max_distance : bool):
	if throwing_knives_left > 0:
		throwing_knives_left -= 1
		
		throwing_knife_attack.throw_projectile(get_parent().find_child("Projectiles"), throwing_knife_attack, emitting_position, throwing_towards, throw_to_max_distance)

func get_throwing_knife_emission_position():
	match last_throw_angle:
		1:
			last_throw_angle = 0
		0:
			last_throw_angle = 1
	print(last_throw_angle, "      ", $Rotatable/ProjectileEmissionMarkers.get_child(last_throw_angle).position)
	return $Rotatable/ProjectileEmissionMarkers.get_child(last_throw_angle).position + position

func pick_up_throwing_knife(dagger):
	throwing_knives_left += 1
	print("picked up")

#func focus_time(pressing_button : bool):
	#

func tp_to_dagger():
	var tp_to = focused_dagger.position
	movement_component.teleport(tp_to, .1)
	teleporting.emit(tp_to)
	tp_focused = false
	focused_dagger = null
	
func _on_teleport_focus_timer_timeout():
	tp_focused = true

func dagger_hovered(dagger : ThrowingDagger):
	hovered_dagger = dagger
	if dagger:
		dagger.pick_up_zone.visible = true

func dagger_unhovered(dagger : ThrowingDagger):
	if !Input.is_action_pressed("action_1") and dagger:
		dagger.pick_up_zone.visible = false
	pass

func tp_distance_indicator(current_distance, max_distance):
	pass

func attack_sword():
	pass


