class_name FabState
extends Node

var machines:      Dictionary[Vector2i, Machine]
var gameSpeed:     float = 1.0

@onready var storage: ItemStorage = $ItemStorage

@onready var tst: TrackState    = $"../TrackState"
@onready var tmp: TrackState    = $"../TempState"
@onready var itm: ItemState     = $"../ItemState"
@onready var mst: MachState     = $"../MachState"

func _ready():
    
    Post.subscribe(self)
    
func newGame():
    
    storage.reset()
    
func sinkAtPosCanTakeItem(pos: Vector2i, item : Item.Inst):
    
    assert(machines.has(pos))
    var machine = machines[pos]
    var slit = machine.slitAtPos(pos)
    if slit:
        if slit.has("item"): 
            return slit.item == item.type
        if slit.has("shape"):
            return slit.shape == item.shape
        return true
    return false
    
func canAffordTemp():
    
    return storage.storage[Item.Type.CubeBlack] > tmp.size()
    
func consumableItemAtPos(pos : Vector2i, advance : float):
    
    for item in itemsAtPos(pos):
        if item.advance + advance >= 1.0:
            return item
    return null
    
func addItem(pos, dir, item):
    
    item.pos = pos
    item.dir = dir
    itm.add(Vector3i(pos.x, pos.y, dir), item)
    
func delItem(item):
    
    itm.del(item.dpos())
    
func itemsAtPos(pos : Vector2i) -> Array:
    
    return itm.itemsAtPos(pos)
    
func delItemsAtPos(pos : Vector2i):
    
    for item in itemsAtPos(pos):
        storage.addItem(item.type)
        delItem(item)
        
func inSpace(pos : Vector2i, dir : int, advance : float = 0.0):
    
    var trackData = tst.dataAtPos(pos)
    
    if trackData.is_empty(): return -666
    
    var inQueue = trackData[3]
    var inRing  = tst.typeMap[2]
    
    var items = itemsAtPos(pos)
    if items.size() == 0:
        return advance
    if items.size() >= 4:
        return -2
        
    items.sort_custom(func(a,b): return a.advance > b.advance)
        
    if inQueue.size() == 0:
        var tailSpace = items[-1].advance - Belt.HALFSIZE
        if tailSpace >= Belt.HALFSIZE:
            return minf(advance, tailSpace - Belt.HALFSIZE)
        if inRing.size() > 1:
            inQueue.push_back(dir)
        return -3
    if inQueue[0] == dir:
        var tailSpace = items[-1].advance - Belt.HALFSIZE
        if tailSpace >= Belt.HALFSIZE:
            inQueue.pop_front()
            return minf(advance, tailSpace - Belt.HALFSIZE)
    else:
        if not inQueue.has(dir):
            inQueue.push_back(dir)
            return -4 
    return -5
    
func outSpace(pos : Vector2i, dir : int, advance: float = 0.5) -> float: 

    for item in itemsAtPos(pos):
        if item.dir == dir:
            var space = item.advance - Belt.HALFSIZE
            if space - Belt.HALFSIZE >= 0.5:
                return minf(advance, space - Belt.HALFSIZE)
            else:
                return space - Belt.HALFSIZE
    return advance

func buyMachineAtPosOfType(pos : Vector2i, type : int, orientation : int = 0):
    
    var machine = Mach.Class[type].new(pos, orientation)

    if occupiedByRoot(machine.getOccupied()):
        machine.free()
        return
        
    storage.buy(type)
    machine.free()
    addMachineAtPosOfType(pos, type, orientation)
            
func addMachineAtPosOfType(pos : Vector2i, type : int, orientation : int = 0):
        
    var machine = Mach.Class[type].new(pos, orientation)
    
    for opos in machine.getOccupied():
        sellMachineAtPos(opos)
        sellBeltAtPos(opos)
        machines[opos] = machine
        
    $Machines.add_child(machine)
    
    return machine

func sellMachineAtPos(pos : Vector2i):
    
    if machines.has(pos):
        if not machines[pos].isRoot():
            storage.refund(machines[pos].type)
            machines[pos].free()
    
func buyBeltAtPos(pos : Vector2i, type : int):
    
    if not beltAtPos(pos):
        storage.buy(Mach.Type.Belt)
        
    addBeltAtPos(pos, type)

func addBeltAtPos(pos : Vector2i, type : int):

    delItemsAtPos(pos)
    tst.add(pos, type)

func addBeltDataAtPos(pos : Vector2i, data : Array):

    tst.add(pos, data[2][0], data[2][1], data[2][2])
    
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

func beltDataAtIndex(index : int) -> Array:
    
    return tst.dataAtIndex(index)

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
    
func sellBeltAtPos(pos : Vector2i): 
    
    if occupiedByRoot([pos]): return
    if not beltAtPos(pos): return

    storage.refund(Mach.Type.Belt)

    delBeltAtPos(pos)

func delBeltAtPos(pos : Vector2i):
    
    delItemsAtPos(pos)
    tst.del(pos)
    
    for d in Belt.DIRS:
        var np = pos + Belt.NEIGHBOR[d]
        var bt = beltAtPos(np)
        if bt:
            var clean = Belt.connectNeighbors(np, beltNeighborsAtPos(np), 0)
            if Belt.isValidType(clean) and clean != bt and not Belt.noInOut(clean):
                delItemsAtPos(np)
                tst.add(np, clean)
                
func sellObjectAtPos(pos : Vector2i):
    
    if machines.has(pos):
        sellMachineAtPos(pos)
    elif beltAtPos(pos):
        sellBeltAtPos(pos)
        
func isOccupied(pos : Vector2i):
    
    if machines.has(pos): return true
    return false
    
func _physics_process(delta: float):

    for machine in $Machines.get_children():
        machine.consume(delta * gameSpeed)
        
    itm.advanceItems(delta * gameSpeed)
    
    for machine in $Machines.get_children():
        machine.produce(delta * gameSpeed)
    
func clearTemp(): tmp.clear()
        
func gameSpeedFaster(): setGameSpeed(gameSpeed * 3/2)
func gameSpeedSlower(): setGameSpeed(gameSpeed * 2/3)
func gameSpeedReset():  setGameSpeed(1)
    
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
                
    data.FabState.tracks = []
    for i in range(tst.size()):
        var bd = beltDataAtIndex(i)
        data.FabState.tracks.push_back([bd[0].x, bd[0].y, bd.slice(1)])
        
    data.FabState.items = []
    for i in range(itm.size()):
        var item = itm.itemAtIndex(i)
        data.FabState.items.push_back([
            item.pos.x, 
            item.pos.y, 
            item.dir, 
            item.type, 
            item.advance, 
            item.scale])
            
    data.FabState.storage = storage.storage
    
func loadGame(data : Dictionary):

    if data.has("FabState"):
        
        gameSpeed  = data.FabState.gameSpeed
        
        if data.FabState.has("machines"):
            for machine in data.FabState.machines:
                var pos = Vector2i(machine.pos.x, machine.pos.y)
                addMachineAtPosOfType(pos, machine.type, machine.orientation)

        if data.FabState.has("tracks"):
            for track in data.FabState.tracks:
                addBeltDataAtPos(Vector2i(track[0], track[1]), track)
        
        if data.FabState.has("items"):
            for d in data.FabState.items:
                var pos = Vector2i(d[0], d[1])
                var dir = d[2]
                var item = Item.Inst.new(d[3])
                item.pos = pos
                item.dir = dir
                item.advance = d[4]
                item.scale   = d[5]
                addItem(pos, dir, item)
                
        if data.FabState.has("storage"):
            storage.storage = data.FabState.storage
                        
func occupiedByRoot(posl):
    
    for pos in posl:
        if machines.has(pos):
            if machines[pos].isRoot():
                return true
    return false
        
func ghostForMachine(machine, material, skip=[]) -> Ghost:
    
    var ghost = Ghost.new(machine.type, machine.pos, machine.orientation)
    
    ghost.proxy = machine
    
    Utils.setOverrideMaterial(machine.building, material, skip)
    
    $Ghosts.add_child(ghost)
    
    return ghost


func ghostForType(type, material, skip = []) -> Ghost:
    
    var ghost = Ghost.new(type, Vector2i.ZERO, 0)
    
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
