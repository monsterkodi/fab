extends Builder
class_name BuildingBuilder

var ghost
var delGhosts = []

const GHOST_MATERIAL     = preload("uid://bqhwhtt3kc30s")
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
    
    ghost = fab.ghostForType(Mach.typeForString(string), GHOST_MATERIAL, ["Arrow"])
    
func pointerHover(pos):
    
    clearDelGhosts()        
    if ghost and ghost.is_inside_tree():
        ghost.setPos(pos)
        Utils.setOverrideMaterial(ghost.building, GHOST_MATERIAL, ["Arrow"])
        for gp in ghost.getOccupied():
            if fab.machines.has(gp):
                var machine = fab.machines[gp]
                if machine.pos == Vector2i.ZERO:
                    handleRootOverlap()
                else:
                    delGhosts.push_back(fab.ghostForMachine(machine, GHOST_RED_MATERIAL))
                    
func handleRootOverlap():
    
    clearDelGhosts()
    Utils.setOverrideMaterial(ghost.building, GHOST_RED_MATERIAL)

func pointerClick(pos): 
    
    if fab.occupiedByRoot(ghost.getOccupied()):
        return
        
    fab.addMachineAtPosOfType(pos, ghost.type, ghost.orientation)
    clearDelGhosts()
    
func pointerDrag(pos):
    
    pointerHover(pos)
    
    if ghost:
        for gp in ghost.getOccupied():
            if fab.machines.has(gp):
                return
        fab.addMachineAtPosOfType(pos, ghost.type, ghost.orientation)

func pointerRotate():
    
    ghost.rotateCW()
    
func pointerContext(pos):
    
    pointerRotate()
