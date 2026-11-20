extends CharacterBody2D
## Four-directional movement. When several direction keys are held,
## the most recently pressed one wins; releasing it falls back to the
## previous key that is still held.

const DIRECTIONS: Dictionary[StringName, Vector2] = {
	&"move_up": Vector2.UP,
	&"move_down": Vector2.DOWN,
	&"move_left": Vector2.LEFT,
	&"move_right": Vector2.RIGHT,
}

@export var speed: float = 200.0

## Held direction actions, oldest first. The last entry is the active one.
var _held: Array[StringName] = []


func _physics_process(_delta: float) -> void:	#FixedUpdate
	_update_held()
	var direction: Vector2 = Vector2.ZERO
	if not _held.is_empty():
		direction = DIRECTIONS[_held.back()]	#Returns the last item from the aarray
	velocity = direction * speed
	move_and_slide()


## Polls input each physics frame, so missed release events (e.g. when the
## window loses focus) can't leave a direction stuck.
func _update_held() -> void:
	for action: StringName in DIRECTIONS:
		if Input.is_action_pressed(action):		#True as long as any key is held
			if Input.is_action_just_pressed(action) or action not in _held:		#True only in first physics step after key goes down, or a key held is not in list
				_held.erase(action)		#Prevents duplicates in list
				_held.append(action)	#Move held key to end of list -> newest
		else:
			_held.erase(action)
