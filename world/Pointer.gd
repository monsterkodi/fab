extends Node3D

var beltPieces: Dictionary[Vector2i, int]
var tempPoints: Array

func _ready():
    
    Post.subscribe(self)
    
func pointerHover(pos):
    
    var dot = get_tree().root.get_node("/root/World/Pointer/Dot")
    dot.global_position.x = pos.x
    dot.global_position.z = pos.y
    
func pointerClick(pos):
    
    tempPoints.clear()
    tempPoints.append(pos)
    updateTemp()
    
func pointerShiftClick(pos):
    
    if tempPoints.is_empty(): 
        pointerClick(pos)
    else:
        pointerDrag(pos)
    
func pointerDrag(pos):
    
    pointerHover(pos)
    
    if tempPoints.is_empty(): return
    
    for index in range(tempPoints.size()): 
        if tempPoints[index] == pos:
            if index == tempPoints.size()-2:
                tempPoints.pop_back()
            updateTemp()
            return
    
    while tempPoints[-1].x - pos.x > 1: # interpolate horizontally
        tempPoints.append(Vector2i(tempPoints[-1].x-1, tempPoints[-1].y))
        
    while tempPoints[-1].x - pos.x < -1:
        tempPoints.append(Vector2i(tempPoints[-1].x+1, tempPoints[-1].y))
        
    while tempPoints[-1].y - pos.y > 1: # interpolate vertically
        tempPoints.append(Vector2i(tempPoints[-1].x, tempPoints[-1].y-1))
        
    while tempPoints[-1].y - pos.y < -1:
        tempPoints.append(Vector2i(tempPoints[-1].x, tempPoints[-1].y+1))
    
    if tempPoints[-1].x != pos.x and tempPoints[-1].y != pos.y: # fill corner in diagonal case
        if tempPoints[-1].x - pos.x > 0:
            tempPoints.append(Vector2i(tempPoints[-1].x-1, tempPoints[-1].y))
        else:
            tempPoints.append(Vector2i(tempPoints[-1].x+1, tempPoints[-1].y))
        
    tempPoints.append(pos)
    updateTemp()
    
func pointerRelease(pos):
    
    appendTempPoints()    
    
func pointerCancel(pos):
    
    tempPoints.clear()
    updateTemp()
    
func updateTemp():
    
    var mm = get_tree().root.get_node("/root/World/Level/MultiMesh")
    mm.clear("temp")
    for ti in range(tempPoints.size()):
        var pos = tempPoints[ti]
        mm.add("temp", Vector3i(pos.x, pos.y, inputAtTempIndex(ti) | outputAtTempIndex(ti)))
        
func updateBelt():
        
    var mm = get_tree().root.get_node("/root/World/Level/MultiMesh")
    mm.clear("belt")
    for pos in beltPieces:
        mm.add("belt", Vector3i(pos.x, pos.y, beltPieces[pos]))
        
func inputForPoints(from, to):
    
    if from.y == to.y:
        if   to.x > from.x: return Belt.I_W
        elif to.x < from.x: return Belt.I_E
        
    if from.x == to.x:
        if   to.y > from.y: return Belt.I_N
        elif to.y < from.y: return Belt.I_S

    Log.log("IDENTICAL or DIAGONAL?", from, to)
    return 0

func outputForPoints(from, to):
    
    if from.y == to.y:
        if   to.x > from.x: return Belt.O_E
        elif to.x < from.x: return Belt.O_W

    if from.x == to.x:
        if   to.y > from.y: return Belt.O_S
        elif to.y < from.y: return Belt.O_N

    Log.log("IDENTICAL or DIAGONAL?", from, to)
    return 0
        
func inputAtTempIndex(ti):
    
    if ti > 0:
        return inputForPoints(tempPoints[ti-1], tempPoints[ti])
    return 0
        
func outputAtTempIndex(ti):
    
    if ti < tempPoints.size()-1:
        return outputForPoints(tempPoints[ti], tempPoints[ti+1])
    return 0
    
func combineBeltTypes(old: int, new: int) -> int:
    
    # remove outputs that conflict with new inputs, and vice versa
    var inputs  = (old & 0b00001111) & ~((new >> 4) & 0b00001111)
    var outputs = (old & 0b11110000) & ~((new << 4) & 0b11110000)
    
    # merge input and outputs with new belt
    return inputs | outputs | new   
        
func appendTempPoints():

    for ti in range(tempPoints.size()):
        var tp = tempPoints[ti]
        var bt = beltPieces.get(tp, 0)
        var nt = combineBeltTypes(bt, inputAtTempIndex(ti) | outputAtTempIndex(ti))
        beltPieces[tp] = nt
        if Belt.isInvalidType(nt):
            Log.log("INVALID", tp, bt, Belt.stringForType(nt), Belt.isInvalidType(nt))
        
    tempPoints.clear()
    updateTemp()
    updateBelt()
