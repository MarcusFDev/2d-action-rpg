class_name WeaponStats
extends Resource

enum WeaponType {MELEE, RANGED}

@export var weapon_name: String
@export var weapon_type: WeaponType
@export_range(0, 100, 1, "or_greater") var weapon_damage: float
@export_range(0, 100, 1, "or_greater", "suffix:px/s") var weapon_speed: float
