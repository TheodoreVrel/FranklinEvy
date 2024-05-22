extends CollisionComponent
class_name HurtboxComponent

@export var health_component : HealthComponent

@onready var unit = get_parent()

func change_health(skill : Skill):
	if is_instance_valid(health_component):
		if skill is Attack:
			health_component.take_damage(skill.health_value)
			if skill.change_duration != null:
				change_health_over_time(1, skill.change_duration, skill.health_value_2)
			if unit.animation_component:
				var new_rotation = get_angle_to(Globals.current_player.position) - deg_to_rad(90)
				unit.animation_component.blood_spurt_effect(new_rotation)
		elif skill.health_value > 0:
			health_component.heal_damage(skill.health_value)
		
			

func change_health_over_time(ticks_per_second: float, seconds : float, hp_value : int, damaging : bool = true):
	var total_ticks = seconds * ticks_per_second
	var update_time = seconds / total_ticks
	var damage_per_tick = hp_value / total_ticks
	
	if damaging:
		var new_rotation = get_angle_to(Globals.current_player.position) - deg_to_rad(90)
		for tick in range(total_ticks):
			await get_tree().create_timer(update_time).timeout
			if is_instance_valid(health_component): health_component.take_damage(damage_per_tick)
			
			if unit.animation_component:
				unit.animation_component.blood_spurt_effect(new_rotation)
	pass
