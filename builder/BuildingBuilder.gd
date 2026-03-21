extends Builder
class_name BuildingBuilder

var ghost
var delGhosts = []
var unaffordable = false

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
    
func ghostColor(type):
    
    if fab.storage.canAfford(type):
        return COLOR.GHOST_BLUE
    else:
        unaffordable = true
        return Color.RED

func setBuilding(string):
    
    var type = Mach.typeForString(string)
    ghost = fab.ghostForType(type, ghostColor(type))
    
func pointerHover(pos):
    
    clearDelGhosts()        
    if ghost and ghost.is_inside_tree():
        ghost.setPos(pos) # has to come first
        ghost.setColor(ghostColor(ghost.type))
        for gp in ghost.getOccupied():
            if fab.machines.has(gp):
                var machine = fab.machines[gp]
                if machine.isRoot():
                    ghost.setColor(Color.RED)
                elif not fab.ghostAtPos(machine.pos) or fab.ghostAtPos(machine.pos) == ghost:
                    delGhosts.push_back(fab.ghostForMachine(machine, Color.RED))
                    
func pointerClick(pos): 
    
    if fab.occupiedByRoot(ghost.getOccupied()): return
    if not fab.storage.canAfford(ghost.type): return
        
    fab.buyMachineAtPosOfType(pos, ghost.type, ghost.orientation)
    if ghost.type == Mach.Type.Humus and randf() < 0.5:
        pointerRotate()

    clearDelGhosts()
    
func pointerDrag(pos):
    
    pointerHover(pos)
    
    if ghost:
        if not fab.storage.canAfford(ghost.type): return
        for gp in ghost.getOccupied():
            if fab.machines.has(gp):
                return
        fab.buyMachineAtPosOfType(pos, ghost.type, ghost.orientation)
        if ghost.type == Mach.Type.Humus and randf() < 0.5:
            pointerRotate()

func pointerRotate():
    
    ghost.rotateCW()
    pointerHover(ghost.pos)
    
func pointerContext(pos):
    
    pointerRotate()
