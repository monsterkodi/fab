class_name RectSelect
extends Builder

var startPos
var endPos
var corners

func _ready():
    
    corners = get_parent().get_node("RectCorners")
    cursorShape = Control.CURSOR_CROSS

func pointerClick(pos):
    
    if not startPos:
        startPos = pos
    endPos = pos
    Log.log("rect select", startPos, endPos)
    updateCorners()
    corners.visible = true
    
func updateCorners():
    
    var maxx = max(startPos.x, endPos.x)  
    var maxy = max(startPos.y, endPos.y)
    var minx = min(startPos.x, endPos.x) 
    var miny = min(startPos.y, endPos.y)
     
    corners.get_child(0).global_position = Vector3(maxx, 0, miny)
    corners.get_child(1).global_position = Vector3(maxx, 0, maxy)
    corners.get_child(2).global_position = Vector3(minx, 0, maxy)
    corners.get_child(3).global_position = Vector3(minx, 0, miny)
    
func pointerDrag(pos): 

    pointerClick(pos)
    
func pointerRelease(pos):
    
    Log.log("rect select done", startPos, endPos)
    startPos = null
    corners.visible = false
