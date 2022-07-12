extends "res://scripts/components/BaseComponent.gd"

# When you activate this component, make sure that the amount of time
# given to it is at least 4 * note_time, preferably 5 * note_time

var current_note: int = 0
const FINAL_NOTE: int = 3  # Final note played without player input
const MAX_VOLUME: int = -8
const FINAL_NOTE_VOLUME: int = -4
export var note_time: float = 1.0
onready var note_timer: Timer = $NoteTimer

onready var notes: Array = [$C, $D, $E, $F, $Final]
var note_tweens: Array = []

func _ready() -> void:
	lights = [$Light]
	for note in notes:
		note.position.x = Constants.LIGHT_CENTER_X
		note.position.y = Constants.LIGHT_CENTER_Y
		note.volume_db = MAX_VOLUME
		
		# For quickly fading out note before next one plays
		var tween = Tween.new()
		add_child(tween)
		note_tweens.append(tween)
		
	notes[-1].volume_db = FINAL_NOTE_VOLUME

func start() -> void:
	current_note = 0
	lights[0].turn_on()
	
	play_note(0)
	note_timer.start(note_time)

func play_note(note_num: int) -> void:
	var volume
	if note_num == len(notes) - 1 or note_num == -1:
		volume = FINAL_NOTE_VOLUME
	else:
		volume = MAX_VOLUME
	note_tweens[note_num].interpolate_property(notes[note_num], "volume_db", volume, -60, 0.05)
	notes[note_num].volume_db = volume
	notes[note_num].play()

func fade_out_note(note_num: int) -> void:
	note_tweens[note_num].start()

func on_fail() -> void:
	# Fade out current note on fail
	fade_out_note(current_note)

func on_key_press(key: String) -> void:
	if key == lights[0].key:
		note_timer.stop()
		lights[0].turn_off()
		if current_note == FINAL_NOTE:
			play_note(-1)
			fade_out_note(-2)
			
			deactivate()
		else:
			fail()

func _on_NoteTimer_timeout():
	current_note += 1
	
	play_note(current_note)
	fade_out_note(current_note - 1)
	
	if current_note == FINAL_NOTE:
		note_timer.stop()
