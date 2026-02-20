class_name BeltState
extends Node

# children: Array[Item]

var type : int
var pos : Vector2i

func _ready():
    pass
    
func _exit_tree():
    
    #assert(get_child_count() == 0)
    Log.log("exit", name)
    Utils.fabState().beltStates.erase(pos)
    
func advanceForDelta(delta:float) -> float:
    
    return delta * 0.5
    
func position(): return Vector3(pos.x, 0, pos.y)
    
func itemPositionAtIndex(index) -> Vector3:
    
    var item = get_child(index)
    return position() + Belt.offsetForAdvanceAndDirection(type, item.advance, item.direction)
    
func advanceItems(delta:float):
    
    assert(get_child_count() > 0)
    
    var tailSpace = 1
    var advance = advanceForDelta(delta)
    
    var headItem = get_child(0)
    if headItem.advance + advance >= tailSpace:
        var bs = Utils.fabState().beltStateAtPos(pos + Belt.NEIGHBOR[headItem.direction])
        if bs:
            var inDir = Belt.OPPOSITE[headItem.direction]
            var adv = bs.hasSpace(inDir)
            if adv >= 0:
                remove_child(headItem)
                headItem.advance = adv
                bs.addItem(inDir, headItem)
    
    for item in get_children():
        if item != headItem:
            tailSpace -= Belt.HALFSIZE
        item.advance = minf(item.advance + advance, tailSpace)
        tailSpace = item.advance - Belt.HALFSIZE
        if item.advance > 0.5:
            item.direction = Belt.outputDirForType(type)
            
    if get_child_count() == 0:
        Log.log("queue free", name, pos)
        queue_free()
    
func hasSpace(dir, advance: float = 0) -> float:

    if not type & Belt.INPUT[dir]:
        return -2
    
    if get_child_count() == 0:
        return advance
    if get_child_count() > 2:
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
