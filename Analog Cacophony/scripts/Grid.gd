extends Node2D

signal fail

var started: bool = false
var current_beat: int = 0

onready var rows = [
	[$QueryComponent, $ChordComponent, $SequenceComponent],
	[$ScaleComponent, $VolumeComponent, $CountComponent, $NumberComponent, $TwoTimingComponent, $OnceComponent],
	[$CadenceComponent, $DirectionComponent, $AlternateComponent, $MemoryComponent]
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
	$OnceComponent,
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
	$ChordComponent.position.x = Constants.LIGHT_DISTANCE_HORIZ * 4
	$SequenceComponent.position.x = Constants.LIGHT_DISTANCE_HORIZ * 6
	
	# Row 2 position setting
	for component in rows[1]:
		component.position.y = Constants.LIGHT_DISTANCE_VERT
	
	$VolumeComponent.position.x = Constants.LIGHT_DISTANCE_HORIZ
	$CountComponent.position.x = Constants.LIGHT_DISTANCE_HORIZ * 3
	$NumberComponent.position.x = Constants.LIGHT_DISTANCE_HORIZ * 6
	$TwoTimingComponent.position.x = Constants.LIGHT_DISTANCE_HORIZ * 7
	$OnceComponent.position.x = Constants.LIGHT_DISTANCE_HORIZ * 9
	
	# Row 3 position setting
	for component in rows[2]:
		component.position.y = Constants.LIGHT_DISTANCE_VERT * 2
	
	$DirectionComponent.position.x = Constants.LIGHT_DISTANCE_HORIZ * 3
	$AlternateComponent.position.x = Constants.LIGHT_DISTANCE_HORIZ * 4
	$MemoryComponent.position.x = Constants.LIGHT_DISTANCE_HORIZ * 7

func _on_component_fail():
	emit_signal("fail")

func start():
	started = true
	beat_sequence.shuffle()
	beat_keeper.start(BEAT_TIME)

func stop():
	started = false
	beat_keeper.stop()
	for component in components:
		component.lock()

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
