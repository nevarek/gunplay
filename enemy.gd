extends CharacterBody2D

var radius = 16
var default_color = Color.BLUE

var color : Color


func _ready() -> void:
	$CollisionShape2D.shape.radius = radius
	color = default_color


func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, color)


func hit_by(what : Node2D):
	_take_damage(what)


func _take_damage(from_what):
	$AnimationPlayer.stop()
	$AnimationPlayer.play('hit')
	print(from_what)
