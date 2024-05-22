extends Node2D
class_name InteractionComponent

enum interaction_type{NONE, DIALOGUE, ACTIVATE, OPEN}
@export var type : interaction_type = interaction_type.DIALOGUE



var interactible : bool = false

# Called when the node enters the scene tree for the first time.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func interact_with():
	match type:
		interaction_type.DIALOGUE:
			print("dialogue")


