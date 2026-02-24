class_name FabState
extends Node

var beltPieces:    Dictionary[Vector2i, int]
var tempPoints:    Dictionary[Vector2i, int]
var machines:      Dictionary[Vector2i, Machine]
var beltStates:    Dictionary[Vector2i, BeltState]
var buildings:     Dictionary[Vector2i, int]
var gameSpeed:     float = 1.0

func _ready():
    
    Post.subscribe(self)
        
func beltStateAtPos(pos):
    
    if beltStates.has(pos):
        return beltStates[pos]
    if beltPieces.has(pos):
        return addBeltStateAtPos(pos)
    return null
    
func addBeltStateAtPos(pos):
    
    var bs = BeltState.new()
    bs.pos = pos
    bs.type = beltPieces[pos]
    beltStates[pos] = bs
    $BeltStates.add_child(bs)
    return bs    
    
func addMachineAtPosOfType(pos, type, orientation = 0):
        
    var machine = Mach.Class[type].new()
    
    machine.setOrientation(orientation)
    machine.pos = pos
    
    for opos in machine.getOccupied():
        delMachineAtPos(opos)
        delBeltAtPos(opos)
        machines[opos] = machine
        
    $Machines.add_child(machine)
    
    return machine
    
func delMachineAtPos(pos):
    #Log.log("delMachineAtPos", pos, machines.has(pos))
    if machines.has(pos):
        if machines[pos].pos != Vector2i(0,0):
            machines[pos].free()

func delBeltStateAtPos(pos):
    
    if beltStates.has(pos):
        beltStates[pos].queue_free()
        $BeltStates.remove_child(beltStates[pos])

func addBeltAtPos(pos, type):
    
    delBeltStateAtPos(pos)
    beltPieces[pos] = type
        
func delBeltAtPos(pos):    

    delBeltStateAtPos(pos)
    beltPieces.erase(pos)
    
    for d in Belt.DIRS:
        var np = pos + Belt.NEIGHBOR[d]
        var bt = beltPieces.get(np, 0)
        if bt:
            var clean = Belt.connectNeighbors(np, beltPieces, 0)
            if Belt.isValidType(clean) and clean != bt:
                delBeltStateAtPos(np)
                beltPieces[np] = clean
                
    updateBelt()
    updateItems()
    
func delObjectAtPos(pos):
    
    if machines.has(pos):
        delMachineAtPos(pos)
    elif beltPieces.has(pos):
        delBeltAtPos(pos)
        
func isOccupied(pos):
    
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

func updateTemp():
    
    mm().clear("temp")
    for pos in tempPoints:
        mm().add("temp", Vector3i(pos.x, pos.y, tempPoints[pos]))
        
func updateBelt():
        
    mm().clear("belt")
    for pos in beltPieces:
        mm().add("belt", Vector3i(pos.x, pos.y, beltPieces[pos]))

func updateItems():

    mm().clear("item")
    for pos in beltStates:
        var bs = beltStates[pos]
        for idx in range(bs.get_child_count()):
            var item = bs.get_child(idx)
            mm().add("item", [bs.itemPositionAtIndex(idx), item.color, item.scale])
        
func mm(): return get_tree().root.get_node("/root/World/Level/MultiMesh")

func speedFaster(): 
    
    setGameSpeed(gameSpeed * 3/2)
    
func speedSlower(): 
    
    setGameSpeed(gameSpeed * 2/3)
    
func setGameSpeed(newSpeed):
    
    if newSpeed < 24 and newSpeed > 0.1:
        gameSpeed = newSpeed
        Post.gameSpeed.emit(gameSpeed)
    
func saveGame(data:Dictionary):
    
    data.FabState = {}
    data.FabState.beltPieces = beltPieces
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
    
func loadGame(data:Dictionary):

    if data.has("FabState"):
        
        beltPieces = data.FabState.beltPieces
        gameSpeed  = data.FabState.gameSpeed
        
        if data.FabState.has("machines"):
            for machine in data.FabState.machines:
                var pos = Vector2i(machine.pos.x, machine.pos.y)
                addMachineAtPosOfType(pos, machine.type, machine.orientation)
        
        if data.FabState.has("beltStates"):
            for state in data.FabState.beltStates:
                var bs = addBeltStateAtPos(Vector2i(state[0][0], state[0][1]))
                bs.restore(state)
        
        updateBelt()

func newGhost(type, pos, orientation, material):
    
    var ghost = Ghost.new()
    
    ghost.pos         = pos
    ghost.type        = type
    ghost.orientation = orientation

    $Ghosts.add_child(ghost)
    
    if material: Utils.setMaterial(ghost.building, material)
    
    return ghost
