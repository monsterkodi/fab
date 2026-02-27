class_name FabState
extends Node

var machines:      Dictionary[Vector2i, Machine]
var beltStates:    Dictionary[Vector2i, BeltState]
var buildings:     Dictionary[Vector2i, int]
var gameSpeed:     float = 1.0

@onready var tst: TrackState    = $"../TrackState"
@onready var tmp: TrackState    = $"../TempState"
@onready var imm: ItemMultiMesh = $"../ItemMultiMesh"

func _ready():
    
    Post.subscribe(self)
    
func consumableItemAtPos(pos : Vector2i):
    
    var bs = beltStateAtPos(pos)
    if bs and bs.get_child_count():
        var item = bs.get_child(0)
        if item.advance >= 1:
            return item
    return null
    
func addItem(pos, dir, item):
    
    beltStateAtPos(pos).addItem(dir, item)
    
func delItem(item):
    
    item.queue_free()
    
func inSpace(pos : Vector2i, dir : int):
    
    var bs = beltStateAtPos(pos)
    if bs:
        return bs.inSpace(dir)
    return -666
        
func beltStateAtPos(pos : Vector2i):
    
    if beltStates.has(pos):
        return beltStates[pos]
    if beltAtPos(pos):
        return addBeltStateAtPos(pos)
    return null
    
func addBeltStateAtPos(pos : Vector2i):
    
    var bs = BeltState.new()
    bs.pos = pos
    bs.type = beltAtPos(pos)
    beltStates[pos] = bs
    $BeltStates.add_child(bs)
    return bs    
    
func addMachineAtPosOfType(pos : Vector2i, type : int, orientation : int = 0):
        
    var machine = Mach.Class[type].new()
    
    machine.setOrientation(orientation)
    machine.pos = pos
    
    for opos in machine.getOccupied():
        delMachineAtPos(opos)
        delBeltAtPos(opos)
        machines[opos] = machine
        
    $Machines.add_child(machine)
    
    return machine
    
func delMachineAtPos(pos : Vector2i):

    if machines.has(pos):
        if machines[pos].pos != Vector2i(0,0):
            machines[pos].free()

func delBeltStateAtPos(pos : Vector2i):
    
    if beltStates.has(pos):
        beltStates[pos].queue_free()
        $BeltStates.remove_child(beltStates[pos])

func addBeltAtPos(pos : Vector2i, type : int):

    delBeltStateAtPos(pos)
    tst.add(pos, type)
    
func addTempAtPos(pos : Vector2i, type : int):
    
    tmp.add(pos, type)
    
func delTempAtPos(pos : Vector2i):
    
    tmp.del(pos)
    
func numTemp():
    
    return tmp.size()
    
func tempAtPos(pos : Vector2i) -> int:
    
    var data = tmp.dataAtPos(pos)
    if data.size(): return data[1]
    return 0
    
func tempAtIndex(index : int) -> int:
    
    var data = tmp.dataAtIndex(index)
    if data.size(): return data[1]
    return 0

func tempPosAtIndex(index : int) -> Vector2i:

    var data = tmp.dataAtIndex(index)
    if data.size(): return data[0]
    return Vector2i.MIN

func beltAtPos(pos : Vector2i) -> int:
    
    var data = tst.dataAtPos(pos)
    if data.size(): return data[1]
    return 0

func beltAtIndex(index : int) -> int:
    
    var data = tst.dataAtIndex(index)
    if data.size(): return data[1]
    return 0

func beltPosAtIndex(index : int) -> Vector2i:

    var data = tst.dataAtIndex(index)
    if data.size(): return data[0]
    return Vector2i.MIN
    
func beltNeighborsAtPos(pos : Vector2i) -> Array[int]:
    
    var n : Array[int] = []
    for d in Belt.DIRS:
        n.push_back(beltAtPos(pos + Belt.NEIGHBOR[d]))
    return n

func tempNeighborsAtPos(pos : Vector2i) -> Array[int]:
    
    var n : Array[int] = []
    for d in Belt.DIRS:
        n.push_back(tempAtPos(pos + Belt.NEIGHBOR[d]))
    return n
    
func delBeltAtPos(pos : Vector2i): 
    
    if occupiedByRoot([pos]):
        return

    delBeltStateAtPos(pos)
    tst.del(pos)
    
    for d in Belt.DIRS:
        var np = pos + Belt.NEIGHBOR[d]
        var bt = beltAtPos(np)
        if bt:
            var clean = Belt.connectNeighbors(np, beltNeighborsAtPos(np), 0)
            if Belt.isValidType(clean) and clean != bt and not Belt.noInOut(clean):
                delBeltStateAtPos(np)
                tst.add(np, clean)
                
    updateItems()
    
func delObjectAtPos(pos : Vector2i):
    
    if machines.has(pos):
        delMachineAtPos(pos)
    elif beltAtPos(pos):
        delBeltAtPos(pos)
        
func isOccupied(pos : Vector2i):
    
    if machines.has(pos): return true
    return false
    
func _physics_process(delta: float):

    for machine in $Machines.get_children():
        machine.consume()
        
    for beltState in $BeltStates.get_children():
        beltState.advanceItems(delta * gameSpeed)
    
    for machine in $Machines.get_children():
        machine.produce()
    
    updateItems()
    
func clearTemp(): 
    
    tmp.clear()

func updateItems():

    imm.clear("item")
    for pos in beltStates:
        var bs = beltStates[pos]
        for idx in range(bs.get_child_count()):
            var item = bs.get_child(idx)
            imm.add("item", [bs.itemPositionAtIndex(idx), item.color, item.scale])
        
func speedFaster(): 
    
    setGameSpeed(gameSpeed * 3/2)
    
func speedSlower(): 
    
    setGameSpeed(gameSpeed * 2/3)
    
func setGameSpeed(newSpeed):
    
    if newSpeed < 24 and newSpeed > 0.1:
        gameSpeed = newSpeed
        Post.gameSpeed.emit(gameSpeed)
    
func saveGame(data : Dictionary):
    
    data.FabState = {}
    data.FabState.gameSpeed  = gameSpeed
    
    data.FabState.machines = []
    for machine in $Machines.get_children():
        var machineData = {
            "pos":         machine.pos, 
            "type":        machine.type, 
            "orientation": machine.orientation}
        data.FabState.machines.push_back(machineData)
        
    data.FabState.beltStates = []
    for bs in $BeltStates.get_children():
        data.FabState.beltStates.push_back(bs.store())
        
    data.FabState.tracks = []
    for i in range(tst.size()):
        var pos = beltPosAtIndex(i)
        data.FabState.tracks.push_back([pos.x, pos.y, beltAtIndex(i)])
    
func loadGame(data : Dictionary):

    if data.has("FabState"):
        
        gameSpeed  = data.FabState.gameSpeed
        
        if data.FabState.has("machines"):
            for machine in data.FabState.machines:
                var pos = Vector2i(machine.pos.x, machine.pos.y)
                addMachineAtPosOfType(pos, machine.type, machine.orientation)

        if data.FabState.has("tracks"):
            for track in data.FabState.tracks:
                addBeltAtPos(Vector2i(track[0], track[1]), track[2])
        
        if data.FabState.has("beltStates"):
            for state in data.FabState.beltStates:
                var bs = addBeltStateAtPos(Vector2i(state[0][0], state[0][1]))
                bs.restore(state)
                        
func occupiedByRoot(posl):
    
    for pos in posl:
        if machines.has(pos):
            if machines[pos].pos == Vector2i.ZERO:
                return true
    return false
        
func ghostForMachine(machine, material, skip=[]) -> Ghost:
    
    var ghost = Ghost.new()
    
    ghost.pos         = machine.pos
    ghost.type        = machine.type
    ghost.orientation = machine.orientation
    ghost.proxy       = machine
    
    Utils.setOverrideMaterial(machine.building, material, skip)
    
    $Ghosts.add_child(ghost)
    
    return ghost


func ghostForType(type, material, skip = []) -> Ghost:
    
    var ghost = Ghost.new()
    
    ghost.pos         = Vector2i.ZERO
    ghost.type        = type
    ghost.orientation = 0

    $Ghosts.add_child(ghost)
    
    Utils.setOverrideMaterial(ghost.building, material, skip)
    
    return ghost
    
func ghostAtPos(pos : Vector2i): 
    
    for ghost in ghosts():
        if ghost.pos == pos:
            return ghost
    return null
    
func ghosts() -> Array[Node]: return $Ghosts.get_children()

func clearGhosts():
    
    for ghost in $Ghosts.get_children():
        ghost.queue_free()
