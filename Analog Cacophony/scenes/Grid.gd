extends Node2D

var timer = 0

func _ready():
	# Row 1 position setting
	$ChordComponent.position.x = Constants.LIGHT_DISTANCE_HORIZ * 4
	$SequenceComponent.position.x = Constants.LIGHT_DISTANCE_HORIZ * 6
	
	# Row 2 position setting
	$ScaleComponent.position.y = Constants.LIGHT_DISTANCE_VERT
	$VolumeComponent.position.y = Constants.LIGHT_DISTANCE_VERT
	$CountComponent.position.y = Constants.LIGHT_DISTANCE_VERT
	$ParityComponent.position.y = Constants.LIGHT_DISTANCE_VERT
	$NumberComponent.position.y = Constants.LIGHT_DISTANCE_VERT
	$OnceComponent.position.y = Constants.LIGHT_DISTANCE_VERT
	
	$VolumeComponent.position.x = Constants.LIGHT_DISTANCE_HORIZ
	$CountComponent.position.x = Constants.LIGHT_DISTANCE_HORIZ * 3
	$OnceComponent.position.x = Constants.LIGHT_DISTANCE_HORIZ * 6
	$ParityComponent.position.x = Constants.LIGHT_DISTANCE_HORIZ * 7
	$NumberComponent.position.x = Constants.LIGHT_DISTANCE_HORIZ * 9
	
	# Row 3 position setting
	$MemoryComponent.position.y = Constants.LIGHT_DISTANCE_VERT * 2
	$DirectionComponent.position.y = Constants.LIGHT_DISTANCE_VERT * 2
	$AlternateComponent.position.y = Constants.LIGHT_DISTANCE_VERT * 2
	
	$DirectionComponent.position.x = Constants.LIGHT_DISTANCE_HORIZ * 3
	$AlternateComponent.position.x = Constants.LIGHT_DISTANCE_HORIZ * 4

func _process(delta):
	if timer % 600 == 0:
		$SequenceComponent.activate(3)
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
