extends CharacterBody2D

var drag_delta: Vector2 = Vector2(0.0, 0.0)
var is_jumping: bool = false
var is_high_jumping: bool = false
var last_direction: float = 0.0
var swipe_delta: Vector2 = Vector2(0.0, 0.0)
var swipe_start: Vector2 = Vector2(0.0, 0.0)
var swipe_threshold: float = 50.0
var tap_duration: float = 0.0
var tap_time_threshold: float = 0.3
var tap_start_time: float = 0.0
var timer_jump: float = 0.0


# Note: `@export` variables are available for editing in the property editor.
@export var high_jump_velocity = -300.0
@export var jump_velocity = -240.0
@export var speed = 100.0


## Called when the node leaves the scene tree.
func _exit_tree() -> void:

	# [DEBUG] Message
	if Globals.debug_mode: print(Globals.time_stamp, " [DEBUG] '", get_script().resource_path.get_file().get_basename(), "' scene unloaded.")


## Called when there is an input event. The input event propagates up through the node tree until a node consumes it.
func _input(event: InputEvent) -> void:

	# Check if the input is a Touch event
	if event is InputEventScreenTouch:

		# [touch] screen just _pressed_
		if event.is_pressed():

			# Record initial touch position
			swipe_start = event.position

			# Record initial touch time
			tap_start_time = Time.get_ticks_msec() / 1000.0

		# [touch] screen just _released_
		else:

			# Reset drag delta
			drag_delta = Vector2(0.0, 0.0)

			# Record final touch position
			var swipe_end = event.position

			# Calculate the differece from start and end positions
			swipe_delta = swipe_end - swipe_start

			# Calculate the difference from start and end times
			tap_duration = Time.get_ticks_msec() / 1000.0 - tap_start_time

	# Check if the input is a Drag event
	if event is InputEventScreenDrag:

		# Only proceed if the touch started on the left half of the screen
		if swipe_start.x < get_viewport().get_visible_rect().size.x / 2:

			# Record drag direction based on the relative movement
			drag_delta = event.relative


## Called when the node enters the scene tree for the first time.
func _ready() -> void:

	# [DEBUG] Message
	if Globals.debug_mode: print(Globals.time_stamp, " [DEBUG] '", get_script().resource_path.get_file().get_basename(), "' scene loaded.")

	# Define the initial control configuration
	setup_controls()


## Called each physics frame with the time since the last physics frame as argument (delta, in seconds).
## Use _physics_process(delta) if the input needs to be checked continuously in sync with the physics engine, like for smooth movement or jump control.
func _physics_process(delta: float) -> void:

	# If the game is not paused...
	if !Globals.game_paused:

		# Set animation and velocity based on player action and position
		mangage_state()

		# Handle player movement
		update_velocity(delta)

		# Move player
		move_and_slide()


## Called every frame. '_delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:

	# Check if the game is paused
	if Globals.game_paused:

		# Get the size of the window
		var screen_size = DisplayServer.window_get_size() * .33

		# Calculate the center of the screen
		var center = screen_size * 0.5

		# Set the position of the pause menu to the center of the screen (instead of the player camera)
		$Camera2D/Pause.position.x = max($"./.." / Player2D.position.x, center.x)
		$Camera2D/Pause.position.y = center.y - ($Camera2D/Pause.size.y * 0.5)


## Manage the player's state; setting flags and playing animations.
func mangage_state() -> void:

	# Check if player is on a floor
	if is_on_floor():

		# Reset the jumping flags
		var jump = false
		is_jumping = false
		is_high_jumping = false

		# Check if not swiping
		if swipe_delta.length() < swipe_threshold:
			# Check if the tap duration is under the threshold
			if tap_duration < tap_time_threshold:
				# Check if swipe_start is on the right half of the screen
				if swipe_start.x > get_viewport().get_visible_rect().size.x / 2:
					# Get the current time
					var time_now = Time.get_ticks_msec() / 1000.0
					# Check if the tap start is under the threshold
					if time_now < tap_start_time + tap_time_threshold:
						# Set the tap to "jump" flag
						jump = true

		# [jump] button just _pressed_
		if Input.is_action_just_pressed("jump") or jump:
			# Set the "jump timer" to the current game time
			timer_jump = Time.get_ticks_msec()
			# Flag the player as "jumping"
			is_jumping = true
			# Set the player's vertical velocity
			velocity.y = jump_velocity
			# Play "jump" sound effect
			Globals.play_audio("res://assets/sounds/smb/Jump.wav")

	# The player is not on a floor
	else:

		# [jump] button currently _pressed_ (and not already "high jumping")
		if Input.is_action_pressed("jump") and !is_high_jumping:
			# Get the current game time
			var time_now = Time.get_ticks_msec()
			# Check if _this_ button press is within 120 milliseconds
			if time_now - timer_jump > 120:
				# Flag the player as "high jumping"
				is_high_jumping = true
				# Set the player's vertical velocity
				velocity.y = high_jump_velocity

		# [jump] button released
		if Input.is_action_just_released("jump"):
			is_high_jumping = true


## Define the initial control configuration.
func setup_controls():

	# Check if [move_up] action is not in the Input Map
	if not InputMap.has_action("move_up"):

		# Add the [move_up] action to the Input Map
		InputMap.add_action("move_up")

		# Keyboard 🅆
		var key_event = InputEventKey.new()
		key_event.physical_keycode = KEY_W
		InputMap.action_add_event("move_up", key_event)

		# Controller [left-stick, up]
		var joystick_event = InputEventJoypadMotion.new()
		joystick_event.axis = JOY_AXIS_LEFT_Y
		joystick_event.axis_value = 1.0
		InputMap.action_add_event("move_up", joystick_event)

		# Controller [d-pad up]
		var joypad_button_event = InputEventJoypadButton.new()
		joypad_button_event.button_index = JOY_BUTTON_DPAD_UP
		InputMap.action_add_event("move_up", joypad_button_event)

	# Check if [move_left] action is not in the Input Map
	if not InputMap.has_action("move_left"):

		# Add the [move_left] action to the Input Map
		InputMap.add_action("move_left")

		# Keyboard 🄰
		var key_event = InputEventKey.new()
		key_event.physical_keycode = KEY_A
		InputMap.action_add_event("move_left", key_event)

		# Controller [left-stick, left]
		var joystick_event = InputEventJoypadMotion.new()
		joystick_event.axis = JOY_AXIS_LEFT_X
		joystick_event.axis_value = -1.0
		InputMap.action_add_event("move_left", joystick_event)

		# Controller [d-pad left]
		var joypad_button_event = InputEventJoypadButton.new()
		joypad_button_event.button_index = JOY_BUTTON_DPAD_LEFT
		InputMap.action_add_event("move_left", joypad_button_event)

	# Check if [move_down] action is not in the Input Map
	if not InputMap.has_action("move_down"):

		# Add the [move_down] action to the Input Map
		InputMap.add_action("move_down")

		# Keyboard 🅂
		var key_event = InputEventKey.new()
		key_event.physical_keycode = KEY_S
		InputMap.action_add_event("move_down", key_event)

		# Controller [left-stick, backward]
		var joystick_event = InputEventJoypadMotion.new()
		joystick_event.axis = JOY_AXIS_LEFT_Y
		joystick_event.axis_value = -1.0
		InputMap.action_add_event("move_down", joystick_event)

		# Controller [d-pad down]
		var joypad_button_event = InputEventJoypadButton.new()
		joypad_button_event.button_index = JOY_BUTTON_DPAD_DOWN
		InputMap.action_add_event("move_down", joypad_button_event)

	# Check if [move_right] action is not in the Input Map
	if not InputMap.has_action("move_right"):

		# Add the [move_right] action to the Input Map
		InputMap.add_action("move_right")

		# Keyboard 🄳
		var key_event = InputEventKey.new()
		key_event.physical_keycode = KEY_D
		InputMap.action_add_event("move_right", key_event)

		# Controller [left-stick, right]
		var joystick_event = InputEventJoypadMotion.new()
		joystick_event.axis = JOY_AXIS_LEFT_X
		joystick_event.axis_value = 1.0
		InputMap.action_add_event("move_right", joystick_event)

		# Controller [d-pad right]
		var joypad_button_event = InputEventJoypadButton.new()
		joypad_button_event.button_index = JOY_BUTTON_DPAD_RIGHT
		InputMap.action_add_event("move_right", joypad_button_event)

	# Check if [select] action is not in the Input Map
	if not InputMap.has_action("select"):
		
		# Add the [select] action to the Input Map
		InputMap.add_action("select")

		# Keyboard [F5]
		var key_event = InputEventKey.new()
		key_event.physical_keycode = KEY_F5
		InputMap.action_add_event("select", key_event)

		# Controller ⧉
		var joypad_button_event = InputEventJoypadButton.new()
		joypad_button_event.button_index = JOY_BUTTON_BACK
		InputMap.action_add_event("select", joypad_button_event)

	# Check if [start] action is not in the Input Map
	if not InputMap.has_action("start"):
		
		# Add the [start] action to the Input Map
		InputMap.add_action("start")

		# Keyboard [Esc]
		var key_event = InputEventKey.new()
		key_event.physical_keycode = KEY_ESCAPE
		InputMap.action_add_event("start", key_event)

		# Controller ☰
		var joypad_button_event = InputEventJoypadButton.new()
		joypad_button_event.button_index = JOY_BUTTON_START
		InputMap.action_add_event("start", joypad_button_event)

	# Ⓐ Check if [jump] action is not in the Input Map
	if not InputMap.has_action("jump"):

		# Add the [jump] action to the Input Map
		InputMap.add_action("jump")

		# Keyboard [Space]
		var key_event = InputEventKey.new()
		key_event.physical_keycode = KEY_SPACE
		InputMap.action_add_event("jump", key_event)

		# Controller Ⓐ
		var joypad_button_event = InputEventJoypadButton.new()
		joypad_button_event.button_index = JOY_BUTTON_A
		InputMap.action_add_event("jump", joypad_button_event)

	# Ⓑ Check if [sprint] action is not in the Input Map
	if not InputMap.has_action("sprint"):

		# Add the [sprint] action to the Input Map
		InputMap.add_action("sprint")

		# Keyboard [Shift]
		var key_event = InputEventKey.new()
		key_event.physical_keycode = KEY_SHIFT
		InputMap.action_add_event("sprint", key_event)

		# Controller Ⓑ
		var joypad_button_event = InputEventJoypadButton.new()
		joypad_button_event.button_index = JOY_BUTTON_B
		InputMap.action_add_event("sprint", joypad_button_event)


## Update the player's velocity based on input and status.
func update_velocity(delta: float) -> void:

	# Create variable to hold the direction the player is moving (-1 left, 0 middle , 1 right)
	var direction: float

	# Check the direction of the drag
	if drag_delta != Vector2(0.0, 0.0):
		if abs(drag_delta.x) > abs(drag_delta.y):
			if drag_delta.x > 0:
				direction = 1
			else:
				direction = -1
		else:
			direction = 0
			#if drag_delta.y > 0:
			#	print("down")
			#else:
			#	print("up")
		# Store the last drag direction
		last_direction = direction

	# Use last direction if no new drag and touch is still pressed
	if last_direction != 0.0 and drag_delta != Vector2(0.0, 0.0):
		direction = last_direction

	# Check is the direction is not yet set
	if !direction:

		# Get the input direction and handle the movement/deceleration.
		direction = Input.get_axis("move_left", "move_right")
	
	# Check if the move direction is set
	if direction:
		velocity.x = direction * speed
		if direction < 0:
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("walk_right")
		else:
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("walk_right")
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		$AnimatedSprite2D.play("default")

	# Check if the player is not on a floor
	if !is_on_floor():
		# Add the gravity
		velocity += get_gravity() * delta
		# Play the "jump" animation
		$AnimatedSprite2D.play("jump_right")
