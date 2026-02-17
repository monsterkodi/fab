extends Node3D

var beltPieces: Dictionary[Vector2i, int]
var tempPoints: Dictionary[Vector2i, int]
var lastTemp

func _ready():
    
    Post.subscribe(self)
    
func pointerHover(pos):
    
    var dot = get_tree().root.get_node("/root/World/Pointer/Dot")
    dot.global_position.x = pos.x
    dot.global_position.z = pos.y
    
func pointerClick(pos):
    
    tempPoints.clear()
    addTempPoint(pos)
    updateTemp()
    
func addTempPoint(pos):
    
    # make sure the last point has an output in the new direction

    if lastTemp:
        var ft = tempPoints[lastTemp]
        if   lastTemp.x < pos.x: tempPoints[lastTemp] |= 0b0001_0000 
        elif lastTemp.x > pos.x: tempPoints[lastTemp] |= 0b0100_0000
        elif lastTemp.y > pos.y: tempPoints[lastTemp] |= 0b1000_0000
        elif lastTemp.y < pos.y: tempPoints[lastTemp] |= 0b0010_0000

    tempPoints[pos] = beltTypeAtPos(pos)
    lastTemp = pos
    
func beltTypeAtPos(pos):
    
    var bt = 0
    for d in Belt.DIRS:
        var np = pos + Belt.NEIGHBOR[d]
        var nt = tempPoints.get(np, 0)
        if nt:
            if nt & (1 << (((d + 2) % 4) + 4)):
                bt |= (1 << d)
            elif nt & (1 << ((d + 2) % 4)):
                bt |= (1 << d+4)
        else:        
            nt = beltPieces.get(np, 0)
            if nt:
                if nt & (1 << (((d + 2) % 4) + 4)):
                    bt |= (1 << d)
                elif nt & (1 << ((d + 2) % 4)):
                    bt |= (1 << d+4)
                
    if bt == 0:
        bt = 0b0001_0100
        
    if beltPieces.has(pos):
        bt = combineBeltTypes(beltPieces[pos], bt)
    return bt
    
func pointerShiftClick(pos):
    
    if tempPoints.is_empty(): 
        pointerClick(pos)
    else:
        pointerDrag(pos)
    
func pointerDrag(pos):
    
    pointerHover(pos)
    
    if tempPoints.is_empty(): return
    if pos == lastTemp: return
        
    while lastTemp.x - pos.x > 1: # interpolate horizontally
        addTempPoint(Vector2i(lastTemp.x-1, lastTemp.y))
        
    while lastTemp.x - pos.x < -1:
        addTempPoint(Vector2i(lastTemp.x+1, lastTemp.y))
        
    while lastTemp.y - pos.y > 1: # interpolate vertically
        addTempPoint(Vector2i(lastTemp.x, lastTemp.y-1))
        
    while lastTemp.y - pos.y < -1:
        addTempPoint(Vector2i(lastTemp.x, lastTemp.y+1))
    
    if lastTemp.x != pos.x and lastTemp.y != pos.y: # fill corner in diagonal case
        if lastTemp.x - pos.x > 0:
            addTempPoint(Vector2i(lastTemp.x-1, lastTemp.y))
        else:
            addTempPoint(Vector2i(lastTemp.x+1, lastTemp.y))
        
    addTempPoint(pos)
    updateTemp()
    
func pointerRelease(pos):
    
    appendTempPoints()    
    
func pointerCancel(pos):
    
    tempPoints.clear()
    lastTemp = null
    updateTemp()
    
func updateTemp():
    
    var mm = get_tree().root.get_node("/root/World/Level/MultiMesh")
    mm.clear("temp")
    for pos in tempPoints:
        mm.add("temp", Vector3i(pos.x, pos.y, tempPoints[pos]))
        
func updateBelt():
        
    var mm = get_tree().root.get_node("/root/World/Level/MultiMesh")
    mm.clear("belt")
    for pos in beltPieces:
        mm.add("belt", Vector3i(pos.x, pos.y, beltPieces[pos]))
        
func combineBeltTypes(old: int, new: int) -> int:
    
    # remove outputs that conflict with new inputs, and vice versa
    var inputs  = (old & 0b00001111) & ~((new >> 4) & 0b00001111)
    var outputs = (old & 0b11110000) & ~((new << 4) & 0b11110000)
    
    # merge input and outputs with new belt
    return inputs | outputs | new   
        
func appendTempPoints():

    for pos in tempPoints:
        beltPieces[pos] = tempPoints[pos]
        
    tempPoints.clear()
    lastTemp = null
    updateTemp()
    updateBelt()
