extends Node2D

signal win

const WIN_TIME: float = 45.0
onready var progress_bar = $ProgressBar
onready var win_timer = $WinTimer
onready var grid = $Grid

var started: bool = false

# Starts the device
func start() -> void:
	started = true
	grid.start()
	win_timer.start(WIN_TIME)

# When a component on the grid fails, reset the win timer
func _on_Grid_fail() -> void:
	win_timer.start(WIN_TIME)

# If we last WIN_TIME amount of time without a failure, win
func _on_WinTimer_timeout() -> void:
	grid.stop()
	emit_signal("win")

# Set the progress bar to be indicative of the time remaining
func _process(delta) -> void:
	if started:
		progress_bar.set_fraction(1 - win_timer.time_left/WIN_TIME)
