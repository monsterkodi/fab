extends Builder
class_name BuildingBuilder

var buildingName
var buildingType
var orientation = 0
var ghost

func _ready():
    
    cursorShape = Control.CURSOR_CAN_DROP

func stop():
    
    ghost.free()

func setBuilding(string):
    
    buildingName = string
    buildingType = Mach.typeForString(string)
    orientation = 0
    ghost = load("res://buildings/Building%s.tscn" % buildingName).instantiate()
    Utils.level().add_child(ghost)
    
func pointerHover(pos):
    
    ghost.global_position = Vector3(pos.x, 0, pos.y)

func pointerClick(pos): 
    
    Utils.fabState().addMachineAtPosOfType(pos, buildingType, orientation)

func pointerRotate():
    
    orientation = (orientation + 1) % 4
    ghost.global_transform = ghost.global_transform.rotated_local(Vector3.UP, deg_to_rad(-90))
