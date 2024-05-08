extends DamagingObject
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
var dagger_rotation_offset : float

@onready var pick_up_zone = $PickUpIndicator

@export var max_distance_tp : int

#var marked_for_tp : bool = false
#enum dagger_state {NONE, HOVERED, FOCUSING, TP}
#var current_state : dagger_state = dagger_state.NONE
@onready var tp_focus_timer : Timer = $TeleportFocusTimer

#var tween : Tween

signal picked_up
signal hovered
signal tp_area_hovered
signal tp_focused

func _ready():
	rotation = get_global_mouse_position().angle_to_point(position) + deg_to_rad(90)
	speed *= 10
	$Control/name.text = str(self)
	$Control/name.rotation -= global_rotation
	print(attack)
	#print("New Dagger, distance = ", distance, " ---- ", origin_point.distance_to(get_global_mouse_position()))
	#dagger_traveling(direction, distance, speed)

func _process(_delta):
	if distance_traveled > distance:
		moving = false
		await get_tree().create_timer(0.1).timeout
		still_collideable = false
	

func _physics_process(delta):
	dagger_movement(origin_point, delta)

func dagger_movement(from: Vector2,  delta):
	if moving:
		position += direction.normalized() * speed * delta
		
		distance_traveled = position.distance_to(origin_point)
		#tween = get_tree().create_tween()
		#tween.tween_property(self, "position", $".".position + direction.normalized() * distance, speed)
		#moving = false
	elif !moving and dagger_marker:
		global_position = dagger_marker.global_position
		rotation =  dagger_marker.get_parent().get_parent().rotation - dagger_rotation_offset
		still_collideable = false



func _on_planting_detection_area_entered_hitbox_area(area):
	#print("collision at ", position)
	
	
	#tween.kill()
	
	var hurtbox_owner = area.get_parent()
	#Actually, I'm not sure this should just be for enemies
	if hurtbox_owner is Enemy and still_collideable:
		$Polygon2D.color = Color.BLACK
		
		
		dagger_marker = dagger_marker_packed.instantiate()
		
		var collision_point = global_position - hurtbox_owner.global_position
		collision_point = collision_point.rotated(-hurtbox_owner.global_rotation)
		
		dagger_marker.global_position =  collision_point# * hurtbox_owner.position.normalized().angle() #+ (hurtbox_owner.position * hurtbox_owner.position.angle()).normalized() 
		#print("Global Position = ", dagger_marker.global_position, " | ", area.global_position,"  and marker local position = ", position, "  ", dagger_marker.position," while local position for the area is ", area.position)
		dagger_rotation_offset = hurtbox_owner.rotation - rotation
		
		connect("picked_up", hurtbox_owner.dagger_removed)
		hurtbox_owner.find_child("DaggerMarkers").add_child(dagger_marker)
		
		if hurtbox_owner.find_child("HealthComponent"):
			pass
	
	moving = false


func _on_pick_up_area_body_entered(body):
	if !moving and body.name == "Player_Evy":
		if !is_queued_for_deletion():
			picked_up.emit(self)
		#print("freed")
		queue_free()
	#print("aaaaaaaaaa  ", moving, "      ", body.name)


#func show_focused(focused : bool = true):
	#var tween = get_tree().create_tween()
	#if focused:
		#tween.tween_property(pick_up_zone, "color", Color(Color.RED, 0.4), 1)
	#else:
		#tween.tween_property(pick_up_zone, "color", Color(Color.WHITE, 0.4), 1)
##
#var collision_pos : Vector2 = Vector2(0.0, 0.0)
#
#func _integrate_forces(state : Physics2DDirectBodyState) -> void:
	#if state.get_contact_count() > 0:
		#collision_pos = to_local(state.get_contact_local_position(0))


func _on_pick_up_area_mouse_entered():
	if !is_queued_for_deletion():
		hovered.emit(self, true)

func _on_pick_up_area_mouse_exited():
	#no_longer_hovered.emit(self)
	if !is_queued_for_deletion():
		hovered.emit(self, false)

func _on_recast_tp_area_mouse_entered():
	#if marked_for_tp:
		#tp_area_hovered.emit(self, true)
	if !is_queued_for_deletion():
		tp_area_hovered.emit(self, true)

func _on_recast_tp_area_mouse_exited():
	if !is_queued_for_deletion():
		tp_area_hovered.emit(self, false)


func _on_teleport_focus_timer_timeout():
	print("timer started for focusing on ", self)
	if !is_queued_for_deletion():
		tp_focused.emit(self)

