extends Node2D

signal win

const WIN_TIME: float = 45.0
onready var progress_bar = $ProgressBar
onready var win_timer = $WinTimer
onready var grid = $Grid

var started: bool = false
var blind_mode: bool = false
var BLIND_MODE_START_FADE: float = 5.0
var BLIND_MODE_END_FADE: float = 15.0

# Starts the device
func start() -> void:
	started = true
	grid.start()
	win_timer.start(WIN_TIME)

func flash_grid(time: float):
	grid.flash(time)

# When a component on the grid fails, reset the win timer
func _on_Grid_fail() -> void:
	win_timer.start(WIN_TIME)

# If we last WIN_TIME amount of time without a failure, win
func _on_WinTimer_timeout() -> void:
	started = false
	progress_bar.set_fraction(1.0)
	grid.stop()
	emit_signal("win")

# Set the progress bar to be indicative of the time remaining
func _process(delta) -> void:
	if started:
		progress_bar.set_fraction(1 - win_timer.time_left/WIN_TIME)
	if blind_mode:
		var time_elapsed = WIN_TIME - win_timer.time_left
		if time_elapsed < BLIND_MODE_START_FADE:
			grid.set_light_opacity(1.0)
		elif time_elapsed > BLIND_MODE_END_FADE:
			grid.set_light_opacity(0.0)
		else:
			var opacity = 1.0 - (time_elapsed - BLIND_MODE_START_FADE) / (BLIND_MODE_END_FADE - BLIND_MODE_START_FADE)
			grid.set_light_opacity(opacity)
