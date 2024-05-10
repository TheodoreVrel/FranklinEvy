extends CollisionComponent
class_name HurtboxComponent

@export var health_component : HealthComponent

func change_health(skill : Skill):
	if health_component:
		if skill is Attack:
			health_component.take_damage(skill.health_value)
			if skill.change_duration != null:
				change_health_over_time(1, skill.change_duration, skill.health_value_2)
		elif skill.health_value > 0:
			health_component.heal_damage(skill.health_value)

func change_health_over_time(ticks_per_second: float, seconds : float, hp_value : int, damaging : bool = true):
	var total_ticks = seconds * ticks_per_second
	var update_time = seconds / total_ticks
	var damage_per_tick = hp_value / total_ticks
	
	if damaging:
		for tick in range(total_ticks):
			await get_tree().create_timer(update_time).timeout
			health_component.take_damage(damage_per_tick)
	pass
