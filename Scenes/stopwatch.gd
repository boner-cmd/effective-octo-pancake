extends Node

var physics_timer : Timer = Timer.new()
var seconds_elapsed : int = 0

func _ready() -> void:
	physics_timer.process_callback = Timer.TIMER_PROCESS_PHYSICS
	physics_timer.wait_time = 1.0
	physics_timer.process_mode = Node.PROCESS_MODE_PAUSABLE
	add_child(physics_timer)
	physics_timer.timeout.connect(timer_ticked)


## get_time() should only be used to query the current time at specific moments
## (such as when pausing the game, or after the timer is stopped). If there is a
## scenario where you would consider calling get_time() to check the time on each
## change, a different function should instead be used that reuses more elements,
## rather than creating and destroying a new String every second.
func get_time() -> String:
	@warning_ignore_start("integer_division")
	return '%02d:%02d:%02d' % [
		seconds_elapsed / 3600, 
		(seconds_elapsed % 3600) / 60, 
		(seconds_elapsed % 3600) % 60, 
		]
	@warning_ignore_restore("integer_division")


## Only use stopwatch.get_seconds() as part of preparing save data for storage. Defining a getter to
## try to prevent doing math on or otherwise altering stopwatch.seconds_elapsed directly
func get_seconds() -> int: return seconds_elapsed


func start() -> void: physics_timer.start()


## DO NOT use stopwatch.stop() to temporarily pause the timer. Instead, pause the tree as normal.
## Stopping the timer should only occur when the timed portion of the game is complete or during a
## similarly exceptional and specific circumstance.
func stop() -> void: physics_timer.stop()


func timer_ticked() -> void: seconds_elapsed += 1
