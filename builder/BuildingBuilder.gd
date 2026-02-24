extends Builder
class_name BuildingBuilder

var ghost

const GHOST_MATERIAL = preload("uid://bqhwhtt3kc30s")

func _ready():
    
    cursorShape = Control.CURSOR_CAN_DROP

func stop():
    
    ghost.free()

func setBuilding(string):
    
    ghost = Utils.fabState().newGhost(Mach.typeForString(string), Vector2i.ZERO, 0, GHOST_MATERIAL)
    
func pointerHover(pos):
    
    if ghost and ghost.is_inside_tree():
        ghost.setPos(pos)

func pointerClick(pos): 
    
    Utils.fabState().addMachineAtPosOfType(pos, ghost.type, ghost.orientation)
    
func pointerDrag(pos):
    
    if ghost:
        for gp in ghost.getOccupied():
            if Utils.fabState().machines.has(gp):
                return
        Utils.fabState().addMachineAtPosOfType(pos, ghost.type, ghost.orientation)

func pointerRotate():
    
    ghost.orientation = (ghost.orientation + 1) % 4
    Utils.rotateForOrientation(ghost.building, ghost.orientation)
