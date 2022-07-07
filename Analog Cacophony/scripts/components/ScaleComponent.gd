extends "res://scripts/components/BaseComponent.gd"

# When you activate this component, make sure that the amount of time
# given to it is at least 4 * note_time, preferably 5 * note_time

var current_note: int = 0
const FINAL_NOTE: int = 3  # Final note played without player input
export var note_time: float = 1.0
onready var note_timer: Timer = $NoteTimer

func _ready() -> void:
	lights = [$Light]

func start() -> void:
	current_note = 0
	lights[0].turn_on()
	note_timer.start(note_time)

func on_key_press(key: String) -> void:
	if key == lights[0].key:
		note_timer.stop()
		lights[0].turn_off()
		if current_note == FINAL_NOTE:
			deactivate()
		else:
			fail()

func _on_NoteTimer_timeout():
	current_note += 1
	if current_note == FINAL_NOTE:
		note_timer.stop()
