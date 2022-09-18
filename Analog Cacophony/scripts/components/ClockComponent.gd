extends "res://scripts/components/BaseComponent.gd"

# A copy of ScaleComponent with more intuitive sounds.

var current_note: int = 0
const FINAL_NOTE: int = 6  # Final note played without player input
const MAX_VOLUME: int = 0
const FINAL_NOTE_VOLUME: int = 0
export var note_time: float = 1.0
onready var note_timer: Timer = $NoteTimer

onready var notes: Array = [$Tick1, $Tick2, $Tick1, $Tick2, $Tick1, $Tick2, $Now, $Tick1]
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
	
	notes[0].volume_db = -6
	notes[0].play()
	$Wait.play()
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
	
	# Manually overrides timer to prolong the activation time of this component
	$Timer.start(note_time * 2)
	
	if current_note == FINAL_NOTE:
		note_timer.stop()
