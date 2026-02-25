extends Builder
class_name BuildingBuilder

var ghost
var delGhosts = []

const GHOST_MATERIAL = preload("uid://bqhwhtt3kc30s")
const GHOST_RED_MATERIAL = preload("uid://b35kuqwv15nfr")

func _ready():
    
    cursorShape = Control.CURSOR_CAN_DROP

func stop():
    
    if ghost: ghost.free()
    clearDelGhosts()
    
func clearDelGhosts():
    
    for dg in delGhosts:
        dg.free()
    delGhosts.clear()

func setBuilding(string):
    
    ghost = Utils.fabState().ghostForType(Mach.typeForString(string), GHOST_MATERIAL, ["Arrow"])
    
func pointerHover(pos):
    
    clearDelGhosts()        
    if ghost and ghost.is_inside_tree():
        ghost.setPos(pos)
        Utils.setOverrideMaterial(ghost.building, GHOST_MATERIAL)
        for gp in ghost.getOccupied():
            if Utils.fabState().machines.has(gp):
                var machine = Utils.fabState().machines[gp]
                if machine.pos == Vector2i.ZERO:
                    handleRootOverlap()
                else:
                    delGhosts.push_back(Utils.fabState().ghostForMachine(machine, GHOST_RED_MATERIAL))
                    
func handleRootOverlap():
    
    clearDelGhosts()
    Utils.setOverrideMaterial(ghost.building, GHOST_RED_MATERIAL)

func pointerClick(pos): 
    
    if Utils.fabState().occupiedByRoot(ghost.getOccupied()):
        return
        
    Utils.fabState().addMachineAtPosOfType(pos, ghost.type, ghost.orientation)
    clearDelGhosts()
    
func pointerDrag(pos):
    
    pointerHover(pos)
    
    if ghost:
        for gp in ghost.getOccupied():
            if Utils.fabState().machines.has(gp):
                return
        Utils.fabState().addMachineAtPosOfType(pos, ghost.type, ghost.orientation)

func pointerRotate():
    
    ghost.rotateCW()
