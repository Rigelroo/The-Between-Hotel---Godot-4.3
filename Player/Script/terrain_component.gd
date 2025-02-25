extends Node
class_name TerrainComponent

func _process_tiledata(body: Node2D, body_rid: RID):
	var tilemap = body
	
	var collided_tile_coords = tilemap.get_coords_for_body_rid(body_rid)
	
	var tile_data = tilemap.get_cell_tile_data(collided_tile_coords)

	var terrain_haz_data = tile_data.get_custom_data("FloorHazards")
	
	if terrain_haz_data:
		terrain_hazards(terrain_haz_data)
	
func terrain_hazards(index):
	match index:
		1:
			owner.damage_component.spikes_damage(1)

func fall_takeback():
	pass
