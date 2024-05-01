extends AttackComponent
class_name ProjectileAttackComponent

@export var projectile_packed_scene : PackedScene
@export var projectile_distance : float

func throw_projectile(projectileContainer : Node2D, projectile_attack : ProjectileAttackComponent, emitting_position : Vector2, throwing_towards : Vector2, throw_to_max_distance : bool = true):
	var new_projectile = projectile_packed_scene.instantiate()
	new_projectile.position = emitting_position
	
	if !throw_to_max_distance:
		new_projectile.distance = emitting_position.distance_to(get_global_mouse_position())
		print("throwing to ", projectile_distance, " ", new_projectile.distance)
	else:
		new_projectile.distance = projectile_distance
		
	new_projectile.direction = throwing_towards.normalized()
	new_projectile.speed = projectile_attack.weapon_speed
	print(get_parent().name)
	new_projectile.connect("picked_up", get_parent().get_parent().pick_up_throwing_knife)
	new_projectile.connect("hovered", get_parent().get_parent().dagger_hovered)
	new_projectile.connect("no_longer_hovered", get_parent().get_parent().dagger_unhovered)
	
	projectileContainer.add_child(new_projectile)


