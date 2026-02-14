extends Node3D

var beltPoints: Array
var tempPoints: Array

func _ready():
    
    Post.subscribe(self)
    
func pointerHover(pos):
    
    get_tree().root.get_node("/root/World/Pointer/Dot").global_position.x = pos.x
    get_tree().root.get_node("/root/World/Pointer/Dot").global_position.z = pos.y
    
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
        var fp = tempPoints[index]
        if fp == pos:
            tempPoints = tempPoints.slice(0, index+1)
            updateTemp()
            return
    
    var lastPos = tempPoints[-1]
    while tempPoints[-1].x - pos.x > 1:
        tempPoints.append(Vector2i(tempPoints[-1].x-1, tempPoints[-1].y))
    while tempPoints[-1].x - pos.x < -1:
        tempPoints.append(Vector2i(tempPoints[-1].x+1, tempPoints[-1].y))
    while tempPoints[-1].y - pos.y > 1:
        tempPoints.append(Vector2i(tempPoints[-1].x, tempPoints[-1].y-1))
    while tempPoints[-1].y - pos.y < -1:
        tempPoints.append(Vector2i(tempPoints[-1].x, tempPoints[-1].y+1))
    
    if tempPoints[-1].x != pos.x and tempPoints[-1].y != pos.y:
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
    
func pointerShiftRelease(pos):
    
    pass
    
func updateTemp():
    
    var mm = get_tree().root.get_node("/root/World/Level/MultiMesh")
    mm.clear("dot")
    for pos in tempPoints:
        mm.add("dot", pos)
        
func updateBelt():
        
    var mm = get_tree().root.get_node("/root/World/Level/MultiMesh")
    mm.clear("belt")
    for pos in beltPoints:
        mm.add("belt", pos)    
        
func appendTempPoints():

    var lp = null
    for tp in tempPoints:
        if not lp: 
            lp = tp
            beltPoints.append(Vector3i(tp.x, tp.y, 0))
            continue
        var direction = 0
        if   lp.x > tp.x: direction = 2
        elif lp.y > tp.y: direction = 1
        elif lp.y < tp.y: direction = 3
        beltPoints.append(Vector3i(tp.x, tp.y, direction))
        lp = tp
        
    tempPoints.clear()
    updateTemp()
    updateBelt()
