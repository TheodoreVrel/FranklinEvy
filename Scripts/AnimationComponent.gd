extends Node2D
class_name AnimationComponent

@onready var bleed_particles_packed : PackedScene = preload("res://Scenes/EntityComponents/bleeding_gpu_particles_2d.tscn")
var bleed_effect_rotation : float
@onready var particles_container = $ParticlesContainer


func blood_spurt_effect(new_rotation):
	var bleed_effect = bleed_particles_packed.instantiate()
	bleed_effect_rotation = new_rotation
	bleed_effect.rotation = bleed_effect_rotation
	#Works for one instance of dot, but doesn't work when receiving multiple, as the point never changes.
	#The ideal solution anyways would be to get the point of contact, still not sure if that's possible
	
	if particles_container:
		particles_container.add_child(bleed_effect)
		bleed_effect.emitting = true

#func reset_spurt_rotation():
	#bleed_effect_rotation = 
