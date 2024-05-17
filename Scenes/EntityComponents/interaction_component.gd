extends Node2D
class_name InteractionComponent

enum interaction_type{NONE, DIALOGUE, ACTIVATE}
var type : interaction_type = interaction_type.DIALOGUE

@export var interaction_area : Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	if !interaction_area and find_child("Area2D"):
		interaction_area = find_child("Area2D")
	if interaction_area:
		interaction_area.connect("body_entered", _on_area_2d_body_entered)
		print("interaction component online - ", get_parent().name)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func interact_with():
	match type:
		interaction_type.DIALOGUE:
			print("dialogue")


func _on_area_2d_body_entered(body):
	print("can interact")
	pass # Replace with function body.
