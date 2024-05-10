extends CharacterBody2D

@onready var movement_component : MovementComponent = $MovementComponent
@onready var throwing_knife_attack : ProjectileAttackComponent = $Rotatable/AttackComponents/PlumeDaggerAttackComponent
@onready var sword_attack : MeleeAttackComponent = $Rotatable/AttackComponents/SwordAttackComponent
@onready var animated_player_sprite : AnimatedSprite2D = $AnimatedSprite2D



enum throw_angle{RIGHT, LEFT}
var last_throw_angle : throw_angle = throw_angle.RIGHT

var last_recorded_input = Vector2.ZERO
var last_recorded_mouse_direction = Vector2.ZERO

var input_direction
var no_input : bool = input_direction == null or input_direction == Vector2(0,0)

@onready var direction_arrow = $Rotatable/LookingThisWay

@export var projectiles : Node2D

#var tp_focused : bool = false
var hovered_dagger : ThrowingDagger
var focused_dagger : ThrowingDagger
var tp_dagger : ThrowingDagger
var dagger_hovered_for_tp_recast : ThrowingDagger
signal teleporting




func _ready():
	pass

func _physics_process(_delta):
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
		
		handle_dagger_zone(hovered_dagger)
		
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
	
	if Input.is_action_just_pressed("attack"):
		attack_sword()
		
	
	if Input.is_action_just_pressed("dash"):
		movement_component.dash(last_recorded_input)
		#print(movement_component.speed)
	
	if Input.is_action_just_pressed("alt_attack"):
		var projectile_emission_point = get_throwing_knife_emission_position()
		var throw_to_max_distance : bool = !(throwing_knife_attack.projectile_distance > projectile_emission_point.distance_to(get_global_mouse_position()))
		#print("throwing to max distance : ", throw_to_max_distance)
		attack_throwing_knife(projectile_emission_point, get_local_mouse_position(), throw_to_max_distance)
		
	if Input.is_action_just_pressed("ui_down"):
		print_daggers()
		print(" | focused dagger = ", focused_dagger, " | tp dagger = ", tp_dagger, " | hovered for tp dagger = ", dagger_hovered_for_tp_recast, "\n ________")
	#if Input.is_action_just_pressed("ui_up"):
		#reset_all_daggers()
	
	
	if Input.is_action_just_pressed("action_1"):
		#print_daggers()
		if tp_dagger and is_instance_valid(tp_dagger) and dagger_hovered_for_tp_recast == tp_dagger:
			tp_to(tp_dagger.position)
			reset_all_daggers()
		elif focused_dagger and dagger_hovered_for_tp_recast == focused_dagger:
			pass
		elif focused_dagger and hovered_dagger != focused_dagger:
			reset_all_daggers()
			focus_dagger(hovered_dagger)
			#print("uunfocusing dagger")
			
		elif hovered_dagger:
			reset_all_daggers()
			focus_dagger(hovered_dagger)
			#print("action")
		else :
			reset_all_daggers()
		

func print_daggers():
	#print("_____________\nhovered dagger : ", hovered_dagger, " \nfocused dagger : ", focused_dagger, " \ntp dagger : ", tp_dagger, " \ndagger hovered for recast : ", dagger_hovered_for_tp_recast, "\n_____________")
	pass

func reset_all_daggers():
	if focused_dagger:
		focused_dagger.tp_focus_timer.stop()
	
	#prevents the tp_dagger from still showing the highlight until hovered
	var current_tp_dagger = tp_dagger
	tp_dagger = null
	if is_instance_valid(current_tp_dagger): handle_dagger_zone(current_tp_dagger) 
	
	var current_focus_dagger = focused_dagger
	focused_dagger = null
	if is_instance_valid(current_focus_dagger): handle_dagger_zone(current_focus_dagger) 
		
	var daggers : Array = [focused_dagger, tp_dagger, dagger_hovered_for_tp_recast] + projectiles.get_children()
	#print(daggers)
	#dagger_hovered_for_tp_recast = null
	
	for dagger in daggers:
		#print("______  ", dagger)
		if dagger and is_instance_valid(dagger):
			#print("______  made null")
			handle_dagger_zone(dagger)
			dagger = null
			
		
	
	#print("unfocused")

func focus_dagger(dagger : ThrowingDagger):
	if dagger :
		dagger.tp_focus_timer.start()
		focused_dagger = dagger
		
		
		
		#has to be outside of handle_dagger_zone_color
		dagger.pick_up_zone.material.set_shader_parameter("color2", waiting_for_tp_color)
		var tween = get_tree().create_tween()
		tween.tween_property(dagger.pick_up_zone.material, "shader_parameter/progress", 1, dagger.tp_focus_timer.wait_time - 0.15)


func attack_throwing_knife(emitting_position : Vector2, throwing_towards : Vector2, throw_to_max_distance : bool):
	throwing_knife_attack.throw_projectile(get_parent().find_child("Projectiles"), throwing_knife_attack, emitting_position, throwing_towards, throw_to_max_distance)


func get_throwing_knife_emission_position():
	match last_throw_angle:
		throw_angle.LEFT:
			last_throw_angle = throw_angle.RIGHT
		throw_angle.RIGHT:
			last_throw_angle = throw_angle.LEFT
	#print(last_throw_angle, "      ", $Rotatable/ProjectileEmissionMarkers.get_child(last_throw_angle).position)
	return $Rotatable/ProjectileEmissionMarkers.get_child(last_throw_angle).position + position

func pick_up_throwing_knife(dagger):
	throwing_knife_attack.throwing_knives_left += 1
	if dagger == hovered_dagger:
		hovered_dagger = null
	if dagger == dagger_hovered_for_tp_recast:
		dagger_hovered_for_tp_recast = null
	if dagger == focused_dagger:
		focused_dagger = null
	if dagger == tp_dagger:
		tp_dagger = null
	
	reset_all_daggers()
	print("picked up")


func tp_area_hovered(dagger : ThrowingDagger, in_area : bool):
	if in_area and ((tp_dagger and tp_dagger != dagger) or (focused_dagger and focused_dagger != dagger)):
		#print("cannot prepare this dagger (", dagger, ") already prepared the tp/focused dagger: ", tp_dagger, focused_dagger, " = ", dagger_hovered_for_tp_recast)
		#print("1", "__________")
		#print(dagger_hovered_for_tp_recast)
		#print(in_area, dagger_hovered_for_tp_recast != null, (tp_dagger and tp_dagger != dagger), (focused_dagger and focused_dagger != dagger))
		pass
	elif in_area :#and ((tp_dagger and tp_dagger == dagger) or (focused_dagger and focused_dagger == dagger)):
		dagger_hovered_for_tp_recast = dagger
		#print("focusing this dagger: ", dagger_hovered_for_tp_recast, ". dagger == tp_dagger or focused_dagger = ", ((tp_dagger and tp_dagger == dagger) or (focused_dagger and focused_dagger == dagger)))
		#print("2", "__________")
		#print(dagger_hovered_for_tp_recast)
		#print(in_area and dagger_hovered_for_tp_recast and ((tp_dagger and tp_dagger != dagger) or (focused_dagger and focused_dagger != dagger)))
		#print(in_area, dagger_hovered_for_tp_recast != null, ((tp_dagger and tp_dagger != dagger) or (focused_dagger and focused_dagger != dagger)))
	
	else:
		#print("leaving the range of this dagger: ", tp_dagger, " = ", dagger_hovered_for_tp_recast)
		#print("3")
		dagger_hovered_for_tp_recast = null
	
	#print("tp area hovered",dagger,"   ", dagger_hovered_for_tp_recast, "   ", dagger == dagger_hovered_for_tp_recast)
	handle_dagger_zone(dagger) #this function takes care of the color

func tp_to(point : Vector2):
	movement_component.teleport(point, .1)
	teleporting.emit(point)
	#tp_focused = false
	

func _on_movement_component_teleported(teleported : bool):
	if teleported:
		reset_all_daggers()
	
func on_teleport_focus_timer_timeout(dagger : ThrowingDagger):
	#dagger.marked_for_tp = true
	tp_dagger = dagger
	focused_dagger = null
	print_daggers()
	#print(dagger)
	await get_tree().create_timer(0.15).timeout
	#print(dagger)
	handle_dagger_zone(dagger)

func dagger_hovered(dagger : ThrowingDagger, hovered : bool):
	if dagger and hovered:
		hovered_dagger = dagger
		tp_area_hovered(dagger, true)
	else :
		hovered_dagger = null
		#if dagger and dagger != tp_dagger and dagger != focused_dagger:
	
	handle_dagger_zone(dagger)



var base_color : Color = Color.WHITE
var color_in_range = Color.WEB_GREEN
var color_less_in_range = Color.ORANGE
var color_out_of_range = Color.FIREBRICK
var waiting_for_tp_color = Color.DARK_ORCHID
var can_tp_color = Color.DEEP_PINK

func handle_dagger_zone(dagger: ThrowingDagger):
	handle_dagger_zone_color(dagger)
	handle_dagger_zone_visibility(dagger)

func handle_dagger_zone_visibility(dagger : ThrowingDagger):
	if dagger:
		if hovered_dagger == dagger or focused_dagger == dagger or tp_dagger == dagger:
			dagger.pick_up_zone.visible = true
		else:
			dagger.pick_up_zone.visible = false

func handle_dagger_zone_color(dagger : ThrowingDagger):
	#print("handling")
	if dagger and !dagger.is_queued_for_deletion():
		if dagger == tp_dagger:
			print_daggers()
			#await get_tree().create_timer(0.25).timeout
			if dagger == dagger_hovered_for_tp_recast:
				dagger.pick_up_zone.material.set_shader_parameter("color", can_tp_color)
				#print(dagger, " is colored for tp")
			else:
				dagger.pick_up_zone.material.set_shader_parameter("color", Color.AQUAMARINE)
				#print(dagger, " is colored for out of tp")
			dagger.pick_up_zone.material.set_shader_parameter("progress", 0.0)
			#print("progress back to 0")
			
		elif dagger == focused_dagger:
			if dagger.tp_focus_timer.is_stopped():
				pass
			#print("violet")
			
		else : # dagger == hovered_dagger:
			var current_distance = dagger.position.distance_to(position)
			var max_distance = dagger.max_distance_tp
			if current_distance < max_distance:
				var progress_value : float
				
				if current_distance/max_distance < 0.33:
					progress_value = 0
				else :
					progress_value = current_distance/max_distance
				#print(progress_value)
				dagger.pick_up_zone.material.set_shader_parameter("progress", progress_value)
				dagger.pick_up_zone.material.set_shader_parameter("color", color_in_range)
				dagger.pick_up_zone.material.set_shader_parameter("color2", color_less_in_range)
			else:
				dagger.pick_up_zone.material.set_shader_parameter("progress", 1.0)
				dagger.pick_up_zone.material.set_shader_parameter("color2", color_out_of_range)
	pass



func attack_sword():
	sword_attack.sword_slash()



#Problem:  the tp is not set correctly. Sometimes dagges light up for tp but you can't tp to them. Recheck them
#action on the dagger should light it up, making it the focused dagger. Action outside the dagger cancels everything and resets focused dagger and obviously also the tp_are_dagger
#you should set the timer for tp, and then the color turns purple on timeout. Should probably put two polygons, one for distance and one for timer

#Realizing that tp indicator should probably not show if you hover but nothing is focused



