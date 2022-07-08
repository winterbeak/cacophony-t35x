extends Node2D

var timer = 0

onready var rows = [
	[$QueryComponent, $ChordComponent, $SequenceComponent],
	[$ScaleComponent, $VolumeComponent, $CountComponent, $ParityComponent, $NumberComponent, $OnceComponent],
	[$MemoryComponent, $DirectionComponent, $AlternateComponent, $CadenceComponent]
]
onready var components = []

func _ready():
	for row in rows:
		for component in row:
			components.append(component)
	
	# Row 1 position setting
	$ChordComponent.position.x = Constants.LIGHT_DISTANCE_HORIZ * 4
	$SequenceComponent.position.x = Constants.LIGHT_DISTANCE_HORIZ * 6
	
	# Row 2 position setting
	for component in rows[1]:
		component.position.y = Constants.LIGHT_DISTANCE_VERT
	
	$VolumeComponent.position.x = Constants.LIGHT_DISTANCE_HORIZ
	$CountComponent.position.x = Constants.LIGHT_DISTANCE_HORIZ * 3
	$OnceComponent.position.x = Constants.LIGHT_DISTANCE_HORIZ * 6
	$ParityComponent.position.x = Constants.LIGHT_DISTANCE_HORIZ * 7
	$NumberComponent.position.x = Constants.LIGHT_DISTANCE_HORIZ * 9
	
	# Row 3 position setting
	for component in rows[2]:
		component.position.y = Constants.LIGHT_DISTANCE_VERT * 2
	
	$DirectionComponent.position.x = Constants.LIGHT_DISTANCE_HORIZ * 3
	$AlternateComponent.position.x = Constants.LIGHT_DISTANCE_HORIZ * 4
	$CadenceComponent.position.x = Constants.LIGHT_DISTANCE_HORIZ * 7

func _process(delta):
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
