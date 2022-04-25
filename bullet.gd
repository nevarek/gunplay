extends CharacterBody2D

var radius = 8
var direction = Vector2.ZERO :
	set(new_dir):
		direction = new_dir.normalized()

@export_range(8,512,8) var movement_speed = 512


var originator : Node = null :
	set(new_originator):
		originator = new_originator
		add_collision_exception_with(originator)


func _ready() -> void:
	$CollisionShape2D.shape.radius = radius


func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, Color.WHITE)


func _physics_process(delta: float) -> void:
	var distance_this_frame = direction * movement_speed * delta

	var collision : KinematicCollision2D = move_and_collide(distance_this_frame)

	if collision:
		_on_bullet_collided(collision.get_collider())
		queue_free()


func _on_bullet_collided(object_hit : Node2D) -> void:
	# Do the thing that happens when a bullet hits
	# For example, it could be an explosion (and then making sub-collisions)
	if is_instance_valid(object_hit):
		if object_hit.is_in_group('enemies'):
			object_hit.hit_by(self)
		if object_hit.is_in_group('destructibles'):
			object_hit.hit_by(self)
