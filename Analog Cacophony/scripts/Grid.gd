extends Node2D

signal fail

var timer = 0
var started: bool = false

onready var rows = [
	[$QueryComponent, $ChordComponent, $SequenceComponent],
	[$ScaleComponent, $VolumeComponent, $CountComponent, $ParityComponent, $NumberComponent, $OnceComponent],
	[$CadenceComponent, $DirectionComponent, $AlternateComponent, $MemoryComponent]
]
onready var components = []

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

func _process(delta):
	if started:
		if timer % 600 == 0:
			$SequenceComponent.activate(3)
		elif timer % 600 == 25:
			$CadenceComponent.activate(5)
		elif timer % 600 == 50:
			$CountComponent.activate(5)
		elif timer % 600 == 100:
			$ScaleComponent.activate($ScaleComponent.note_time * 5)
		elif timer % 600 == 150:
			$NumberComponent.activate(5)
		elif timer % 600 == 200:
			$QueryComponent.activate(3)
		elif timer % 600 == 250:
			$OnceComponent.activate(3)
		elif timer % 600 == 300:
			$ParityComponent.activate(3)
		elif timer % 600 == 350:
			$AlternateComponent.activate(3)
		elif timer % 600 == 400:
			$ChordComponent.activate(3)
		elif timer % 600 == 450:
			$DirectionComponent.activate(3)
		elif timer % 600 == 500:
			$VolumeComponent.activate(5)
		elif timer % 600 == 550:
			$MemoryComponent.activate(5)
		
		timer += 1
