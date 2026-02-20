extends Node
class_name Deleter

var beltPieces: Dictionary[Vector2i, int]

func start():
    
    beltPieces = Utils.fabState().beltPieces
    
func stop(): pass
    
func pointerClick(pos):
    Utils.fabState().delBeltAtPos(pos)
    
func pointerDrag(pos): pointerClick(pos)

func pointerRelease(pos): pass
func pointerShiftClick(pos): pass
func pointerCancel(pos): pass
