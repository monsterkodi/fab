class_name BeltState
extends Node

# children: Array[Item]

var type : int
var pos : Vector2i
var outIndex = 0
var outRing  = [] 

func _ready():
    
    for dir in Belt.DIRS:
        if type & Belt.OUTPUT[dir]:
            outRing.push_back(dir)
    Log.log("bs", type, outRing)
    
func _exit_tree():
    
    #Log.log("exit", name)
    Utils.fabState().beltStates.erase(pos)
    
func advanceForDelta(delta:float) -> float:
    
    return delta * 0.5
    
func position(): return Vector3(pos.x, 0, pos.y)
    
func itemPositionAtIndex(index) -> Vector3:
    
    var item = get_child(index)
    return position() + Belt.offsetForAdvanceAndDirection(type, item.advance, item.direction)
    
func advanceItems(delta:float):
    
    assert(get_child_count() > 0)
    
    var advance = advanceForDelta(delta)
    
    for item in get_children():
        if item.advance + advance >= 1:
            var bs = Utils.fabState().beltStateAtPos(pos + Belt.NEIGHBOR[item.direction])
            if bs:
                var inDir = Belt.OPPOSITE[item.direction]
                var adv = bs.hasSpace(inDir)
                if adv >= 0:
                    remove_child(item)
                    item.advance = adv
                    bs.addItem(inDir, item)
    
    for item in get_children():
        if item.advance <= 0.5 and item.advance + advance > 0.5:
            var space
            for index in range(outRing.size()):
                var ringIndex = (outIndex + index) % outRing.size()
                var dir = outRing[ringIndex]
                space = outSpace(dir, item.advance + advance)
                if space > 0.5:
                    item.advance = space
                    item.direction = dir
                    outIndex = (outIndex + 1) % outRing.size()
                    break
            if space <= 0.5:
                item.advance = 0.5
        else:
            item.advance = minf(item.advance + advance, 1.0)
            
    if get_child_count() == 0:
        #Log.log("queue free", name, pos)
        queue_free()
        
func outSpace(dir, advance: float = 0.5) -> float:

    if not type & Belt.OUTPUT[dir]:
        return -2
    
    for item in get_children():
        if item.direction == dir:
            var space = item.advance - Belt.HALFSIZE
            if space - Belt.HALFSIZE > 0.5:
                return minf(advance, space - Belt.HALFSIZE)
            else:
                return space - Belt.HALFSIZE
    return advance
    
func hasSpace(dir, advance: float = 0) -> float:

    if not type & Belt.INPUT[dir]:
        return -2
    
    if get_child_count() == 0:
        return advance
    if get_child_count() > 3:
        return -1
    var tailSpace = get_child(-1).advance - Belt.HALFSIZE
    if tailSpace > Belt.HALFSIZE:
        return minf(advance, tailSpace - Belt.HALFSIZE)
    return tailSpace - Belt.HALFSIZE
    
func addItem(inDir, item):
    #Log.log("add_item", get_child_count())
    assert(type & Belt.INPUT[inDir])
    item.direction = inDir
    add_child(item)
