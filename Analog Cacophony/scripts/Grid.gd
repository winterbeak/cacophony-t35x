extends Node2D

signal fail

var started: bool = false
var current_beat: int = 0

onready var rows = [
	[$QueryComponent, $ChordComponent, $SequenceComponent],
	[$ScaleComponent, $VolumeComponent, $CountComponent, $NumberComponent, $ParityComponent, $OnceComponent],
	[$CadenceComponent, $DirectionComponent, $AlternateComponent, $MemoryComponent]
]
onready var components = []
onready var beat_keeper = $BeatKeeper
const BEAT_TIME: float = 1.5
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
	$ParityComponent,
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
	$ParityComponent.position.x = Constants.LIGHT_DISTANCE_HORIZ * 7
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

func activate_fixed_sequence():
	beat_sequence[current_beat].activate(5)
	current_beat += 1
	current_beat %= len(beat_sequence)

# If you use this sequence, make sure to shuffle the bag in start()
func activate_bag_randomizer():
	beat_sequence[current_beat].activate(5)
	
	current_beat += 1
	if current_beat == len(beat_sequence):
		current_beat = 0
		shuffle_bag()

func shuffle_bag():
	# We randomize so that the last three of the previous bag won't appear in the first three
	# of the next; this is to prevent a module from repeating too close to itself
	var last_three = []
	for i in range(len(beat_sequence) - 3, len(beat_sequence)):
		last_three.append(beat_sequence[i])
	var rest = []
	for i in range(len(beat_sequence) - 3):
		rest.append(beat_sequence[i])
	
	rest.shuffle()
	
	beat_sequence = []
	for i in range(3):
		beat_sequence.append(rest.pop_front())
		rest.append(last_three.pop_back())
	rest.shuffle()
	for i in range(len(rest)):
		beat_sequence.append(rest.pop_back())

func _on_BeatKeeper_timeout():
	activate_bag_randomizer()
