extends AttackComponent
class_name ProjectileAttackComponent

@export var projectile_packed_scene : PackedScene
@export var projectile_distance : float

func throw_projectile(projectileContainer : Node2D, projectile_attack : ProjectileAttackComponent, emitting_position : Vector2, throwing_towards : Vector2, throw_to_max_distance : bool = true):
	var new_projectile = projectile_packed_scene.instantiate()
	new_projectile.attack = projectile_attack
	print(projectile_attack, new_projectile. attack, 'ezogaibunaboenaeorvbnnazrozmbvamribvaerimuvbaeiuvbaziubvmaezuir')
	new_projectile.position = emitting_position
	
	if !throw_to_max_distance:
		new_projectile.distance = emitting_position.distance_to(get_global_mouse_position())
		print("throwing to ", projectile_distance, " ", new_projectile.distance)
	else:
		new_projectile.distance = projectile_distance
		
	new_projectile.direction = throwing_towards.normalized()
	new_projectile.speed = projectile_attack.weapon_speed
	print(get_parent().name)
	var player = get_parent().get_parent()
	new_projectile.connect("picked_up", player.pick_up_throwing_knife)
	new_projectile.connect("hovered", player.dagger_hovered)
	new_projectile.connect("tp_area_hovered", player.tp_area_hovered)
	new_projectile.connect("tp_focused", player.on_teleport_focus_timer_timeout)
	
	projectileContainer.add_child(new_projectile)


