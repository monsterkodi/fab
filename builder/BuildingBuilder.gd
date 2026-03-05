extends Builder
class_name BuildingBuilder

var ghost
var delGhosts = []
var unaffordable = false

const GHOST_MATERIAL     = preload("uid://bqhwhtt3kc30s")
const GHOST_RED_MATERIAL = preload("uid://b35kuqwv15nfr")

func _ready():
    
    cursorShape = Control.CURSOR_CAN_DROP
    
func _process(delta: float):
    
    if ghost and unaffordable:
        if fab.storage.canAfford(ghost.type):
            unaffordable = false
            pointerHover(ghost.pos)

func stop():
    
    if ghost: ghost.free()
    clearDelGhosts()
    
func clearDelGhosts():
    
    for dg in delGhosts:
        dg.free()
    delGhosts.clear()
    
func ghostMaterial(type):
    
    if fab.storage.canAfford(type):
        return GHOST_MATERIAL
    else:
        unaffordable = true
        return GHOST_RED_MATERIAL

func setBuilding(string):
    
    var type = Mach.typeForString(string)
    ghost = fab.ghostForType(type, ghostMaterial(type), ["Arrow"])
    
func pointerHover(pos):
    
    clearDelGhosts()        
    if ghost and ghost.is_inside_tree():
        ghost.setPos(pos)
        Utils.setOverrideMaterial(ghost.building, ghostMaterial(ghost.type), ["Arrow"])
        #Log.log(ghost.getOccupied())
        for gp in ghost.getOccupied():
            if fab.machines.has(gp):
                var machine = fab.machines[gp]
                if machine.isRoot():
                    handleRootOverlap()
                else:
                    delGhosts.push_back(fab.ghostForMachine(machine, GHOST_RED_MATERIAL))
                    
func handleRootOverlap():
    
    clearDelGhosts()
    Utils.setOverrideMaterial(ghost.building, GHOST_RED_MATERIAL)

func pointerClick(pos): 
    
    if fab.occupiedByRoot(ghost.getOccupied()): return
    if not fab.storage.canAfford(ghost.type): return
        
    fab.buyMachineAtPosOfType(pos, ghost.type, ghost.orientation)
    clearDelGhosts()
    
func pointerDrag(pos):
    
    pointerHover(pos)
    
    if ghost:
        if not fab.storage.canAfford(ghost.type): return
        for gp in ghost.getOccupied():
            if fab.machines.has(gp):
                return
        fab.buyMachineAtPosOfType(pos, ghost.type, ghost.orientation)

func pointerRotate():
    
    ghost.rotateCW()
    pointerHover(ghost.pos)
    
func pointerContext(pos):
    
    pointerRotate()
