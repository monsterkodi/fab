class_name Deleter
extends Builder

var beltPieces: Dictionary[Vector2i, int]

func start():
    
    beltPieces = Utils.fabState().beltPieces
    
func pointerClick(pos):
    
    Utils.fabState().delObjectAtPos(pos)
    
func pointerDrag(pos): pointerClick(pos)
