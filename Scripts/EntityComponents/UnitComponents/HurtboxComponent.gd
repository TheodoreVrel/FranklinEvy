extends CollisionComponent
class_name HurtboxComponent

@export var health_component : HealthComponent

func change_health(skill : Skill):
	if health_component:
		if skill is Attack:
			health_component.take_damage(skill)
		elif skill.health_value > 0:
			health_component.heal_damage(skill)
