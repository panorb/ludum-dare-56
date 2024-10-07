extends HBoxContainer

@export var item_type : BaseItem.ITEM_TYPE
@export var count : int = 1

func _ready() -> void:
	$TextureRect.texture = $TextureRect.texture.duplicate()
	$TextureRect.texture.region = Rect2i(item_type * 32, 0, 32, 32)
	var type_name : String = BaseItem.ITEM_TYPE.keys()[item_type]
	$NameLabel.text = type_name.capitalize()
	$CountLabel.text = str(count)
