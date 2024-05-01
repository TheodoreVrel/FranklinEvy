extends Node2D

@onready var camera = $Camera2D
var camera_following_player : bool = true

@onready var player = $Player_Evy

func _process(_delta):
	if camera_following_player:
		camera.position = player.position


func _on_player_evy_teleporting(new_position):
	camera_following_player = false
	await get_tree().create_timer(0.2).timeout
	var tween = get_tree().create_tween()
	tween.tween_property(camera, "position", player.position, .25)
	
	await tween.finished
	camera_following_player = true
