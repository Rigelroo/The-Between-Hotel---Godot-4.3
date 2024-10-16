# ############################################################################ #
# Copyright © 2022-2024 Piet Bronders <piet.bronders@gmail.com>
# Licensed under the MIT License.
# See LICENSE in the project root for license information.
# ############################################################################ #

@tool
extends EditorImportPlugin

var presets : Array[Dictionary] = [
	{
		"name": "ignore_invisible_layers", 
		"default_value": false
	},{
		"name": "texture_filter", 
		"default_value": CanvasItem.TEXTURE_FILTER_PARENT_NODE,
		"property_hint": PROPERTY_HINT_ENUM,
		"hint_string": ",".join(range(0, CanvasItem.TEXTURE_FILTER_MAX))
	},
]

func _get_import_options(path : String, preset : int) -> Array[Dictionary]:
	return presets

func _get_import_order() -> int:
	return 100

func _get_importer_name() -> String:
	return "godot-krita-importer"

func _get_option_visibility(path: String, option_name: StringName, options: Dictionary) -> bool:
	return true

func _get_preset_count() -> int:
	return 1

func _get_preset_name(preset : int) -> String:
	return "Default"

func _get_priority() -> float:
	return 1.0

func _get_recognized_extensions() -> PackedStringArray:
	return ["kra", "krz"]

func _get_resource_type() -> String:
	return "PackedScene"

func _get_save_extension() -> String:
	return "scn"

func _get_visible_name() -> String:
	return "Scene from Krita"

func _import(source_file: String, save_path: String, options: Dictionary, platform_variants: Array, gen_files: Array) -> int:
	var importer = KraImporter.new()
	importer.verbosity_level = KraImporter.VerbosityLevel.QUIET

	var scene := PackedScene.new()
	var node := Node2D.new()
	node.name = source_file.get_file().get_basename()

	importer.load(source_file)

	for i in range(importer.layer_count - 1, -1, -1):
		var layer_data : Dictionary = importer.get_layer_data_at(i)

		match(layer_data.get("type", -1)):
			0:
				var sprite : Sprite2D = import_paint_layer(layer_data, options)
				if sprite != null:
					node.add_child(sprite)
			1:
				var child_node : Node2D = import_group_layer(importer, layer_data, options)
				if child_node != null:
					node.add_child(child_node)

	# All the children need to have the node as its owner!
	set_owner_recursively(node, node)

	scene.pack(node)
	var error := ResourceSaver.save(scene, "%s.%s" % [save_path, _get_save_extension()])
	# The node needs to be freed to avoid memory leakage
	node.queue_free()
	return error

static func import_group_layer(importer : KraImporter, layer_data : Dictionary, options: Dictionary) -> Node2D:
	var node = Node2D.new()
	node.name = layer_data.get("name", node.name)
	node.position = layer_data.get("position", Vector2.ZERO)

	node.visible = layer_data.get("visible", true)
	if not node.visible and options.get("ignore_invisible_layers", false):
		return null
	node.modulate.a = layer_data.get("opacity", 255.0)/255.0

	var child_uuids : PackedStringArray = layer_data.get("child_uuids", PackedStringArray())
	# Needs to be in reverse order as to preserve layer ordering!
	for i in range(child_uuids.size() - 1, -1, -1):
		var uuid : String = child_uuids[i]
		var child_data : Dictionary = importer.get_layer_data_with_uuid(uuid)
		match(child_data.get("type", -1)):
			0:
				var sprite : Sprite2D = import_paint_layer(child_data, options)
				if sprite != null:
					sprite.position -= node.position
					node.add_child(sprite)
			1:
				var child_node : Node2D = import_group_layer(importer, child_data, options)
				if child_node != null:
					child_node.position -= node.position
					node.add_child(child_node)

	return node

static func import_paint_layer(layer_data : Dictionary, options: Dictionary) -> Node2D:
	var sprite = Sprite2D.new()
	sprite.name = layer_data.get("name", sprite.name)
	sprite.position = layer_data.get("position", Vector2.ZERO)
	sprite.centered = false

	sprite.visible = layer_data.get("visible", true)
	if not sprite.visible and options.get("ignore_invisible_layers", false):
		return null
	sprite.modulate.a = layer_data.get("opacity", 255.0)/255.0

	#create_from_data(width: int, height: int, use_mipmaps: bool, format: Format, data: PoolByteArray)
	var image = Image.create_from_data(layer_data.width, layer_data.height, false, layer_data.format, layer_data.data)
	var texture = ImageTexture.create_from_image(image)

	sprite.texture_filter = options.get("texture_filter", CanvasItem.TEXTURE_FILTER_PARENT_NODE)
	sprite.texture = texture

	return sprite

static func enable_bit(mask, flag):
	return mask | flag

static func disable_bit(mask, flag):
	return mask & ~flag

static func set_owner_recursively(owner : Node2D, node : Node2D):
	for child in node.get_children():
		child.owner = owner

		set_owner_recursively(owner, child)
