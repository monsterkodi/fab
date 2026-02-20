class_name FabState
extends Node

var beltPieces:    Dictionary[Vector2i, int]
var tempPoints:    Dictionary[Vector2i, int]
var machines:      Dictionary[Vector2i, Machine]
var beltStates:    Dictionary[Vector2i, BeltState]
var buildings:     Dictionary[Vector2i, int]

func _ready():
    
    pass
    
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
    
func addMachineAtPosOfType(pos, type):
    
    delMachineAtPos(pos)
    var machine = Mach.Class[type].new()
    machine.pos = pos
    machines[pos] = machine
    $Machines.add_child(machine)
    
func delMachineAtPos(pos):
    
    if machines.has(pos):
        machines[pos].queue_free()
        $Machines.remove_child(machines[pos])
        #machines.erase(pos)    

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
    
func _process(delta: float):

    for machine in $Machines.get_children():
        machine.consume()
        
    for beltState in $BeltStates.get_children():
        beltState.advanceItems(delta)
    
    for machine in $Machines.get_children():
        machine.produce()
    
    updateItems()
    #Log.log("fabState.process")
    pass

func updateTemp():
    
    mm().clear("temp")
    for pos in tempPoints:
        mm().add("temp", Vector3i(pos.x, pos.y, tempPoints[pos]))
        
func updateBelt():
        
    mm().clear("belt")
    for pos in beltPieces:
        #Log.log("belt", pos, beltPieces[pos])
        mm().add("belt", Vector3i(pos.x, pos.y, beltPieces[pos]))

func updateItems():

    mm().clear("item")
    for pos in beltStates:
        var bs = beltStates[pos]
        for idx in range(bs.get_child_count()):
            var item = bs.get_child(idx)
            #Log.log("item", pos, idx, item.advance)
            mm().add("item", bs.itemPositionAtIndex(idx))
        
func mm(): return get_tree().root.get_node("/root/World/Level/MultiMesh")

    
