extends AttackComponent
class_name ProjectileAttackComponent

@export var projectile_packed_scene : PackedScene
@export var projectile_distance : float



func throw_projectile(projectileContainer : Node2D, projectile_attack_component : ProjectileAttackComponent, emitting_position : Vector2, throwing_towards : Vector2, throw_to_max_distance : bool = true):
	if can_use_attack and projectile_attack_component.throwing_knives_left > 0:
		
		
		var new_projectile = projectile_packed_scene.instantiate()
		new_projectile.attack = projectile_attack_component.attack
		
		if projectile_attack_component.secondary_attack:
			new_projectile.secondary_attack = projectile_attack_component.secondary_attack
		#print(new_projectile.attack, 'yyyyyyyyyyyyyyyyyyyyy')
		new_projectile.position = emitting_position
		
		if !throw_to_max_distance:
			new_projectile.distance = emitting_position.distance_to(get_global_mouse_position())
			#print("throwing to ", projectile_distance, " ", new_projectile.distance)
		else:
			new_projectile.distance = projectile_distance
			
		new_projectile.direction = throwing_towards.normalized()
		new_projectile.speed = projectile_attack_component.weapon_speed
		#print(get_parent().name)
		var player = get_parent().get_parent().get_parent()
		new_projectile.connect("picked_up", player.pick_up_throwing_knife)
		new_projectile.connect("hovered", player.dagger_hovered)
		new_projectile.connect("tp_area_hovered", player.tp_area_hovered)
		new_projectile.connect("tp_focused", player.on_teleport_focus_timer_timeout)
		
		#if !is_instance_valid(projectileContainer): 
			#var new_projectile_container = Node2D.new()
		projectileContainer.add_child(new_projectile)
		
		
		#timer cooldown stuff
		if weapon_cooldown_timer:
			can_use_attack = false
			projectile_attack_component.throwing_knives_left -= 1
			weapon_cooldown_timer.start()


