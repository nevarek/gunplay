extends CharacterBody2D

# tree dependencies
var label_current_clip
var label_max_clip
var reload_bar
var current_weapon
var reload_timer

# vars
@export_range(8,1024,8) var movement_speed = 128
@export_range(8,1024,8) var roll_speed = 128
var roll_movement_bonus = 128
var radius = 32


func _ready() -> void:
	$CollisionShape2D.shape.radius = radius

	label_current_clip = $GUI/MarginContainer/HUD/Container/Control2/CurrentClip
	label_max_clip = $GUI/MarginContainer/HUD/Container/Control2/MaxClip
	reload_bar = $ReloadProgressBar
	current_weapon = $Weapon
	reload_timer = $Weapon/ReloadTimer

	current_weapon.connect('reload_started', self._on_reload)
	current_weapon.connect('reload_finished', self._on_reload_finished)
	current_weapon.connect('clip_updated', self._on_clip_updated)

	label_max_clip.text = str(current_weapon.get_clip_size())
	label_current_clip.text = str(current_weapon.get_bullet_count())


func _process(_delta: float) -> void:
	_handle_movement_input()
	_sync_gui_data()


func _physics_process(delta: float) -> void:
	var collision = move_and_collide(velocity * delta)

	if collision:
		pass


func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, Color.RED)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed('primary_attack'):
		current_weapon.attempt_fire()

	if event.is_action_pressed('reload'):
		current_weapon.attempt_reload()


func _handle_movement_input() -> void:
	var input_movement_dir := Vector2.ZERO

	if Input.is_action_pressed('move_up'):
		input_movement_dir.y += -1
	if Input.is_action_pressed('move_down'):
		input_movement_dir.y += 1
	if Input.is_action_pressed('move_left'):
		input_movement_dir.x += -1
	if Input.is_action_pressed('move_right'):
		input_movement_dir.x += 1

	input_movement_dir = input_movement_dir.normalized()

	velocity = input_movement_dir * movement_speed

	if Input.is_action_pressed('roll'):
		_execute_roll()


func _execute_roll():
	pass


func _sync_gui_data():
	# Synchronize the GUI with the player's data
	if current_weapon.is_reloading():
		reload_bar.value = current_weapon.get_reload_progress()


func _on_reload() -> void:
	reload_bar.max_value = current_weapon.get_reload_time()
	reload_bar.show()


func _on_clip_updated() -> void:
	label_current_clip.text = str(current_weapon.get_bullet_count())


func _on_reload_finished() -> void:
	reload_bar.hide()
