extends Node2D

@onready var camera = $Camera2D
var camera_following_player : bool = true

@onready var player = $Player_Evy
@onready var enemies_container = $Enemies

func _ready():
	Globals.current_player = player
	for enemy in enemies_container.get_children():
		if enemy.find_child("HealthComponent"):
			enemy.find_child("HealthComponent").connect("death", kill_enemy)

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

func kill_enemy(enemy : Enemy):
	print("enemy died")
	await get_tree().create_timer(0.41).timeout
	if is_instance_valid(enemy) : enemy.queue_free()
