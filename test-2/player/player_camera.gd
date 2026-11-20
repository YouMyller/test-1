extends Camera2D
## Follows the player (as its child) and sets its limits automatically
## from the level's size, so levels never need hand-typed camera limits.
##
## In each level, add the node that covers the playable area to the
## "camera_bounds" group. Supported node types:
## - Control (e.g. a ColorRect floor): uses its rectangle.
## - TileMapLayer: uses the area covered by its painted tiles.
## If no such node exists, the camera follows without limits.

const BOUNDS_GROUP: StringName = &"camera_bounds"


func _ready() -> void:
	var bounds_node: Node = get_tree().get_first_node_in_group(BOUNDS_GROUP)
	if bounds_node == null:
		push_warning("No node in group '%s'; camera has no limits." % BOUNDS_GROUP)
		return

	var rect: Rect2
	if bounds_node is Control:
		rect = (bounds_node as Control).get_global_rect()
	elif bounds_node is TileMapLayer:
		rect = _tile_map_rect(bounds_node as TileMapLayer)
	else:
		push_warning("'%s' is in group '%s' but isn't a Control or TileMapLayer." % [bounds_node.name, BOUNDS_GROUP])
		return

	limit_left = floori(rect.position.x)
	limit_top = floori(rect.position.y)
	limit_right = ceili(rect.end.x)
	limit_bottom = ceili(rect.end.y)
	# Jump straight to the correct view instead of gliding into it.
	reset_smoothing()


## Returns the area covered by the layer's painted tiles, in world coordinates.
func _tile_map_rect(layer: TileMapLayer) -> Rect2:
	var used: Rect2i = layer.get_used_rect()
	var tile_size := Vector2(layer.tile_set.tile_size)
	var local_rect := Rect2(Vector2(used.position) * tile_size, Vector2(used.size) * tile_size)
	return layer.global_transform * local_rect
