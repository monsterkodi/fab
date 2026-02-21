class_name BeltState
extends Node

# children: Array[Item]

var type : int
var pos : Vector2i
var outIndex = 0
var outRing  = [] 
var inRing   = [] 
var inQueue  = [] 

func _ready():
    
    assert(type)
    for dir in Belt.DIRS:
        if type & Belt.OUTPUT[dir]:
            outRing.push_back(dir)
        if type & Belt.INPUT[dir]:
            inRing.push_back(dir)
           
    if outRing.is_empty():
        outRing.push_back(Belt.dirForSinkType(type)) 
    
func _exit_tree():
    
    Utils.fabState().beltStates.erase(pos)
    
func advanceForDelta(delta:float) -> float:
    
    return delta * 0.5
    
func position(): return Vector3(pos.x, 0, pos.y)
    
func itemPositionAtIndex(index) -> Vector3:
    
    var item = get_child(index)
    return position() + Belt.offsetForAdvanceAndDirection(type, item.advance, item.direction)
    
func advanceItems(delta:float):
    
    if get_child_count() == 0: return
    
    var advance = advanceForDelta(delta)
    
    for item in get_children():
        if item.advance + advance >= 1:
            var bs = Utils.fabState().beltStateAtPos(pos + Belt.NEIGHBOR[item.direction])
            if bs:
                var inDir = Belt.OPPOSITE[item.direction]
                if bs.type & Belt.INPUT[inDir]:
                    var adv = bs.inSpace(inDir, (item.advance + advance) - 1)
                    if adv >= 0:
                        remove_child(item)
                        item.advance = adv
                        bs.addItem(inDir, item)
    
    for item in get_children():
        if item.advance < 0.5 and item.advance + advance >= 0.5:
            var space = 0
            for index in range(outRing.size()):
                                
                var ringIndex = (outIndex + index) % outRing.size()
                var dir = outRing[ringIndex]
                space = outSpace(dir, item.advance + advance)
                
                if space >= 0.5:
                    item.advance = space
                    item.direction = dir
                    outIndex = (ringIndex + 1) % outRing.size()
                    break
            if space < 0.5:
                item.advance = 0.49999
        else:
            item.advance = minf(item.advance + advance, 1.0)

        if item.advance > 0.5 and Belt.isSinkType(type):
            item.scale = 1.0 - 2 * (item.advance-0.5)
        elif item.advance <= 0.5 and Belt.isSourceType(type):
            item.scale = item.advance*2

    if get_child_count() == 0 and Belt.isSimple(type):
        queue_free()
        
func outSpace(dir, advance: float = 0.5) -> float: 

    for item in get_children():
        if item.direction == dir:
            var space = item.advance - Belt.HALFSIZE
            if space - Belt.HALFSIZE > 0.5:
                return minf(advance, space - Belt.HALFSIZE)
            else:
                return space - Belt.HALFSIZE
    return advance
    
func inSpace(dir, advance: float = 0.0) -> float:

    if get_child_count() == 0:
        return advance
    if get_child_count() >= 4:
        return -2
    if inQueue.size() == 0:
        var tailSpace = get_child(-1).advance - Belt.HALFSIZE
        if tailSpace >= Belt.HALFSIZE:
            return minf(advance, tailSpace - Belt.HALFSIZE)
        if inRing.size() > 1:
            inQueue.push_back(dir)
            #Log.log("inSpace!", pos, dir, get_child(-1).advance, get_child(-1).direction, inQueue)
        return -3
    if inQueue[0] == dir:
        var tailSpace = get_child(-1).advance - Belt.HALFSIZE
        if tailSpace >= Belt.HALFSIZE:
            inQueue.pop_front()
            #Log.log("inSpace>", pos, dir, get_child(-1).advance, get_child(-1).direction, inQueue)
            return minf(advance, tailSpace - Belt.HALFSIZE)
    else:
        if not inQueue.has(dir):
            inQueue.push_back(dir)
            #Log.log("inSpace?", pos, dir, get_child(-1).advance, get_child(-1).direction, inQueue)
            return -4 
    return -5
    
func addItem(inDir, item):
    #Log.log("add_item", get_child_count(), item.advance, inDir)
    #assert(type & Belt.INPUT[inDir])
    item.direction = inDir
    add_child(item)
