extends Builder
class_name BuildingBuilder

var buildingName
var buildingType
var orientation = 0
var ghost

const GHOST_MATERIAL = preload("uid://bqhwhtt3kc30s")

func _ready():
    
    cursorShape = Control.CURSOR_CAN_DROP

func stop():
    
    ghost.free()

func setBuilding(string):
    
    buildingName = string
    buildingType = Mach.typeForString(string)
    orientation = 0
    ghost = load("res://buildings/Building%s.tscn" % buildingName).instantiate()
    Utils.setMaterial(ghost, GHOST_MATERIAL)
    Utils.level().add_child(ghost)
    
func pointerHover(pos):
    
    if ghost and ghost.is_inside_tree():
        ghost.global_position = Vector3(pos.x, 0, pos.y)

func pointerClick(pos): 
    
    Utils.fabState().addMachineAtPosOfType(pos, buildingType, orientation)

func pointerRotate():
    
    orientation = (orientation + 1) % 4
    Utils.rotateForOrientation(ghost, orientation)
