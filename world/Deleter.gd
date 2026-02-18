extends Node
class_name Deleter

var beltPieces: Dictionary[Vector2i, int]

func start():
    
    beltPieces = Utils.buildings().beltPieces
    
func stop(): pass
    
func pointerClick(pos):
    
    beltPieces[pos] = 0
    Utils.buildings().updateBelt()
    
func pointerDrag(pos): pointerClick(pos)

func pointerRelease(pos): pass
func pointerShiftClick(pos): pass
func pointerCancel(pos): pass
