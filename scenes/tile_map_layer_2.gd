extends TileMapLayer
var color_layer_data = "color_data"
var waterlayer = 1
func custom_datatest():
	var mouse : Vector2 = get_global_mouse_position()
	var tile_mouse_pos: Vector2i = self.local_to_map(mouse)
	var tile_data : TileData = self.get_cell_tile_data(tile_mouse_pos)
	if tile_data:
		var water_layer = tile_data.get_custom_data(color_layer_data)
		
		if water_layer == true:
			$Sprite2D.modulate = Color(0.98,1,0.50)
func _process(delta: float) -> void:
	custom_datatest()
