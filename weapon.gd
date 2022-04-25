extends Node2D

var BulletScene = load('res://bullet.tscn')

signal reload_started
signal reload_finished
signal weapon_fired
signal clip_updated

@export_range(1,30,1) var CLIP_SIZE = 6
@export_range(0.1, 5.0, 0.1) var reload_time = 2.0

var _bullets_in_clip = 6


func _ready() -> void:
	_bullets_in_clip = CLIP_SIZE

	$ReloadTimer.wait_time = reload_time
	$ReloadTimer.connect('timeout', self._on_reload_finished)


func attempt_reload() -> bool:
	if _bullets_in_clip >= CLIP_SIZE: return false # don't have to reload
	if is_reloading(): return false

	$ReloadTimer.wait_time = reload_time
	$ReloadTimer.start()
	reload_started.emit()
	return true


func _on_reload_finished():
	_bullets_in_clip = CLIP_SIZE
	reload_finished.emit()
	clip_updated.emit()


func attempt_fire() -> bool:
	if is_reloading():
		# can't shoot while reloading
		return false
	if _bullets_in_clip <= 0:
		# no bullets! we should reload
		self.attempt_reload()
		return false

	# create and place bullet, set up collision detection
	var crosshair_pos := get_global_mouse_position()
	var new_bullet : CharacterBody2D = BulletScene.instantiate()
	new_bullet.global_position = global_position
	new_bullet.direction = (crosshair_pos - global_position).normalized()
	new_bullet.originator = find_parent('Player')

	get_tree().root.add_child(new_bullet)
	self._bullets_in_clip -= 1
	weapon_fired.emit()
	clip_updated.emit()
	return true


func get_bullet_count() -> int:
	return _bullets_in_clip


func get_clip_size() -> int:
	return CLIP_SIZE


func get_reload_time() -> float:
	return reload_time


func get_reload_progress() -> float:
	return $ReloadTimer.wait_time - $ReloadTimer.time_left


func is_reloading() -> bool:
	return $ReloadTimer.is_stopped() == false
