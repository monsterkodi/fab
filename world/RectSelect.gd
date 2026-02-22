class_name RectSelect
extends Builder

var startPos
var endPos

func pointerClick(pos):
    
    if not startPos:
        startPos = pos
    endPos = pos
    Log.log("rect select", startPos, endPos)
    
func pointerDrag(pos): 
    
    pointerClick(pos)
    
func pointerRelease(pos):
    
    Log.log("rect select done", startPos, endPos)
