class_name CardDefinition
extends Resource

enum SUIT {Heart, Diamond, Spade, Club}

@export_category("Visuals")
@export var suit_value: SUIT
@export var face_value: int = 1
@export var texture: AtlasTexture
@export var back_texture: CompressedTexture2D
@export_color_no_alpha var color: Color = Color.WHITE

#size is basically that 2 still counts as 2 towards 21.  
#Power conts toward the power of the total
#idk what this game even is
@export_category("Stats")
#card code is suit + value (spade: s, heart: h, club: c, diamond: d)
#example 2 of spades is s2, king of diamonds is dk
@export var card_code: String
@export var power: int
@export var size: int
