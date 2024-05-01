extends Node2D
class_name ThrowingDagger

var moving : bool = true
var still_collideable : bool = true

@onready var origin_point : Vector2 = position
var direction : Vector2
var distance : float
var distance_traveled : float
var speed : float

var dagger_marker_packed : PackedScene = preload("res://Scenes/EntityComponents/AttackComponents/ProjectileAttackComponents/dagger_position.tscn")
var dagger_marker : Marker2D = null

@onready var pick_up_zone = $Polygon2D2

@export var max_distance_tp : int

#var tween : Tween

signal picked_up
signal hovered
signal no_longer_hovered

func _ready():
	rotation = get_global_mouse_position().angle_to_point(position) + deg_to_rad(90)
	speed *= 10
	
	#print("New Dagger, distance = ", distance, " ---- ", origin_point.distance_to(get_global_mouse_position()))
	#dagger_traveling(direction, distance, speed)

func _process(_delta):
	if distance_traveled > distance:
		moving = false
		await get_tree().create_timer(0.1).timeout
		still_collideable = false
	pass

func _physics_process(delta):
	dagger_movement(origin_point, direction, distance, speed, delta)

func dagger_movement(from: Vector2, direction: Vector2, distance: float, speed: float, delta):
	if moving:
		position += direction.normalized() * speed * delta
		
		distance_traveled = position.distance_to(origin_point)
		#tween = get_tree().create_tween()
		#tween.tween_property(self, "position", $".".position + direction.normalized() * distance, speed)
		#moving = false
	elif !moving and dagger_marker:
		global_position = dagger_marker.global_position



func _on_planting_detection_area_entered_hitbox_area(area):
	print("collision at ", position)
	
	
	#tween.kill()
	
	var hurtbox_owner = area.get_parent()
	#Actually, I'm not sure this should just be for enemies
	if hurtbox_owner is Enemy and still_collideable:
		$Polygon2D.color = Color.DARK_RED
		
		dagger_marker = dagger_marker_packed.instantiate()
		dagger_marker.position = global_position - hurtbox_owner.position
		print("Global Position = ", dagger_marker.global_position, " | ", area.global_position,"  and marker local position = ", position, "  ", dagger_marker.position," while local position for the area is ", area.position)
		
		connect("picked_up", hurtbox_owner.dagger_removed)
		hurtbox_owner.find_child("DaggerMarkers").add_child(dagger_marker)
	
	moving = false


func _on_pick_up_area_body_entered(body):
	if !moving and body.name == "Player_Evy":
		picked_up.emit(self)
		print("freed")
		queue_free()
	#print("aaaaaaaaaa  ", moving, "      ", body.name)


func show_focused(focused : bool = true):
	var tween = get_tree().create_tween()
	if focused:
		tween.tween_property(pick_up_zone, "color", Color(Color.RED, 0.4), 1)
	else:
		tween.tween_property(pick_up_zone, "color", Color(Color.WHITE, 0.4), 1)
#
#var collision_pos : Vector2 = Vector2(0.0, 0.0)
#
#func _integrate_forces(state : Physics2DDirectBodyState) -> void:
	#if state.get_contact_count() > 0:
		#collision_pos = to_local(state.get_contact_local_position(0))


func _on_pick_up_area_mouse_entered():
	
	hovered.emit(self)


func _on_pick_up_area_mouse_exited():
	no_longer_hovered.emit(self)
	hovered.emit(null)
