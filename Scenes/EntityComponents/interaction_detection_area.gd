extends Area2D


@export var interaction_detection_area : CollisionShape2D

signal interacting


func _ready():
	if !interaction_detection_area and find_child("CollisionShape2D"):
		interaction_detection_area = find_child("CollisionShape2D")
	
	var player = find_parent("Player*")
	connect("interacting", player.set_interaction_target)
	#if interaction_detection_area:
		#interaction_detection_area.connect("area_entered", _on_area_2d_area_entered)
		#interaction_detection_area.connect("area_exited", _on_area_2d_area_exited)
	print("interaction component online - ", get_parent().name)



func _on_area_entered(area):
	if area is InteractionComponent:
		area.interactible = true
		print("can interact")
		interacting.emit(area.get_parent())


func _on_area_exited(area):
	if area is InteractionComponent:
		area.interactible = false
		print("can't interact")
		interacting.emit(null)
	
