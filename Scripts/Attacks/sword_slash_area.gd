extends Area2D

@onready var collision_shape_left : CollisionShape2D = $CollisionShape2D
@onready var collision_shape_right : CollisionShape2D = $CollisionShape2D2

var enemies_hit : Array #<areas>

signal enemy_hit

func _ready():
	select_swing_area(true, true)

func swing(swing_num : int):
	var tween = get_tree().create_tween()
	enemies_hit.clear()
	match swing_num:
		
		1:
			select_swing_area(false)
			tween.tween_property(self, "rotation", deg_to_rad(-190), 0.13)
		2:
			select_swing_area(true)
			tween.tween_property(self, "rotation", deg_to_rad(175), 0.13)
		3: 
			select_swing_area(false)
			tween.tween_property(self, "rotation", deg_to_rad(-220), 0.13)
		
	rotation = 0
	#print (swing_num)

func select_swing_area(swing_side_right : bool, reset : bool = false):
	collision_shape_left.visible = !swing_side_right
	collision_shape_right.visible = swing_side_right
	
	collision_shape_left.disabled = swing_side_right
	collision_shape_right.disabled = !swing_side_right
	
	if reset:
		collision_shape_left.visible = false
		collision_shape_right.visible = false
		collision_shape_left.disabled = true
		collision_shape_right.disabled = true


func _on_area_entered(area):
	if area is HurtboxComponent and area not in enemies_hit:
		enemies_hit.append(area)
		enemy_hit.emit(area)

