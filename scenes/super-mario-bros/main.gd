extends Node2D

var game_started: bool = false
var players: int = 0
var player_1_coins: int = 0
var player_1_lives: int = 5
var player_1_progress: int = 0
var player_2_coins: int = 0
var player_2_lives: int = 5
var player_2_progress: int = 0
var swipe_start: Vector2
var swipe_threshold := 50.0
var tap_time_threshold := 0.3
var tap_start_time: float = 0.0


## Called when the node leaves the scene tree.
func _exit_tree() -> void:

	# [DEBUG] Message
	if Globals.debug_mode: print(Globals.time_stamp, " [DEBUG] '", get_script().resource_path.get_file().get_basename(), "' scene unloaded.")


## Called when the node enters the scene tree for the first time.
func _ready() -> void:

	# [DEBUG] Message
	if Globals.debug_mode: print(Globals.time_stamp, " [DEBUG] '", get_script().resource_path.get_file().get_basename(), "' scene loaded.")

	# Disable the mouse pointer and capture the motion
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	# Make sure the game is unpaused
	Globals.game_paused = false


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
			# Record final touch position
			var swipe_end = event.position
			# Calculate the differece from start and end positions
			var swipe_delta = swipe_end - swipe_start
			# Calculate the difference from start and end times
			var tap_duration = Time.get_ticks_msec() / 1000.0 - tap_start_time
			# Check if the touch events were close together
			if swipe_delta.length() < swipe_threshold and tap_duration < tap_time_threshold:
				# [tap] touch just _released_
				start()
			# TODO: Move player selection
			elif abs(swipe_delta.y) > abs(swipe_delta.x):
				if swipe_delta.y < -swipe_threshold:
					print("up")
				elif swipe_delta.y > swipe_threshold:
					print("down")
			#else:
			#	if swipe_delta.x < -swipe_threshold:
			#		print("left")
			#	elif swipe_delta.x > swipe_threshold:
			#		print("right")

	# Check if the game is no started
	if !game_started:

		# Check if the input is "start" or [Enter]
		if event is InputEventKey and event.pressed and event.keycode == KEY_ENTER:

			# Start the game
			start()


# Start the game, if not started.
func start() -> void:

	# Check if the game has not started
	if !game_started:

		# Clear title screen
		$Title.queue_free()

		# Define next scene to load
		var path = "res://scenes/super-mario-bros/w1l1.tscn"

		# Load the scene
		var scene = load(path)

		# Instantiate the scene
		var instance_current = scene.instantiate()

		# Add the instance to the current scene
		add_child(instance_current)

		# Flag the game as started
		game_started = true
