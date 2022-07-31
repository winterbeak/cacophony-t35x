extends Node2D

signal fail

var started: bool = false
var current_beat: int = 0

onready var first_row_1 = $QueryComponent
onready var first_row_2 = $ChordComponent
onready var first_row_3 = $SequenceComponent

onready var second_row_1 = $ScaleComponent
onready var second_row_2 = $PitchComponent
onready var second_row_3 = $CountComponent
onready var second_row_4 = $NumberComponent
onready var second_row_5 = $TwoTimingComponent
onready var second_row_6 = $OneTimingComponent

onready var third_row_1 = $CadenceComponent
onready var third_row_2 = $DirectionComponent
onready var third_row_3 = $AlternateComponent
onready var third_row_4 = $MemoryComponent

onready var rows = [
	[first_row_1, first_row_2, first_row_3],
	[second_row_1, second_row_2, second_row_3, second_row_4, second_row_5, second_row_6],
	[third_row_1, third_row_2, third_row_3, third_row_4]
]
onready var components = []
onready var beat_keeper = $BeatKeeper
const BEAT_TIME: float = 2.3
const ACTIVATE_TIME: float = 4.6
onready var beat_sequence = [
	$SequenceComponent,
	$CountComponent,
	$ScaleComponent,
	$MemoryComponent,
	$AlternateComponent,
	$QueryComponent,
	$OneTimingComponent,
	$NumberComponent,
	$CadenceComponent,
	$ChordComponent,
	$DirectionComponent,
	$TwoTimingComponent,
	$VolumeComponent
]

func _ready():
	for row in rows:
		for component in row:
			components.append(component)
	
	# If any component fails, this scene emits the fail signal
	for component in components:
		component.connect_fail(self)
	
	# Row 1 position setting
	first_row_2.position.x = Constants.LIGHT_DISTANCE_HORIZ * 4
	first_row_3.position.x = Constants.LIGHT_DISTANCE_HORIZ * 6
	
	# Row 2 position setting
	for component in rows[1]:
		component.position.y = Constants.LIGHT_DISTANCE_VERT
	
	second_row_2.position.x = Constants.LIGHT_DISTANCE_HORIZ
	second_row_3.position.x = Constants.LIGHT_DISTANCE_HORIZ * 3
	second_row_4.position.x = Constants.LIGHT_DISTANCE_HORIZ * 6
	second_row_5.position.x = Constants.LIGHT_DISTANCE_HORIZ * 7
	second_row_6.position.x = Constants.LIGHT_DISTANCE_HORIZ * 9
	
	# Row 3 position setting
	for component in rows[2]:
		component.position.y = Constants.LIGHT_DISTANCE_VERT * 2
	
	third_row_2.position.x = Constants.LIGHT_DISTANCE_HORIZ * 3
	third_row_3.position.x = Constants.LIGHT_DISTANCE_HORIZ * 4
	third_row_4.position.x = Constants.LIGHT_DISTANCE_HORIZ * 7
	
	lock_components()

func _on_component_fail():
	emit_signal("fail")

func lock_components():
	for component in components:
		component.lock()
		
func unlock_components():
	for component in components:
		component.unlock()

func start():
	started = true
	beat_sequence.shuffle()
	beat_keeper.start(BEAT_TIME)
	unlock_components()

func stop():
	started = false
	beat_keeper.stop()
	lock_components()

func activate_fixed_sequence():
	beat_sequence[current_beat].activate(ACTIVATE_TIME)
	current_beat += 1
	current_beat %= len(beat_sequence)

# If you use this sequence, make sure to shuffle the bag in start()
func activate_bag_randomizer():
	beat_sequence[current_beat].activate(ACTIVATE_TIME)
	
	current_beat += 1
	if current_beat == len(beat_sequence):
		current_beat = 0
		shuffle_bag()

const SHUFFLE_NO_OVERLAP_AMOUNT: int = 5

func shuffle_bag():
	# We randomize so that the last few of the previous bag won't appear in the first few
	# of the next; this is to prevent a module from repeating too close to itself
	# (and potentially activating again while it's already activated)
	var last_of_previous_bag = []
	for i in range(len(beat_sequence) - SHUFFLE_NO_OVERLAP_AMOUNT, len(beat_sequence)):
		last_of_previous_bag.append(beat_sequence[i])
	var everything_else = []
	for i in range(len(beat_sequence) - SHUFFLE_NO_OVERLAP_AMOUNT):
		everything_else.append(beat_sequence[i])
	
	everything_else.shuffle()
	
	beat_sequence = []
	for i in range(SHUFFLE_NO_OVERLAP_AMOUNT):
		beat_sequence.append(everything_else.pop_front())
		everything_else.append(last_of_previous_bag.pop_back())
	everything_else.shuffle()
	for i in range(len(everything_else)):
		beat_sequence.append(everything_else.pop_back())

func _on_BeatKeeper_timeout():
	activate_bag_randomizer()
