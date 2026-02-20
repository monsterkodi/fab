extends Node
class_name Deleter

var beltPieces: Dictionary[Vector2i, int]

func start():
    
    beltPieces = Utils.fabState().beltPieces
    
func stop(): pass
    
func pointerClick(pos):
    
    beltPieces.erase(pos)
    for d in Belt.DIRS:
        var np = pos + Belt.NEIGHBOR[d]
        var bt = beltPieces.get(np, 0)
        if bt:
            var clean = Belt.connectNeighbors(np, beltPieces, 0)
            if Belt.isValidType(clean):
                beltPieces[np] = clean
    updateBelt()
    
func pointerDrag(pos): pointerClick(pos)

func pointerRelease(pos): pass
func pointerShiftClick(pos): pass
func pointerCancel(pos): pass

func updateBelt():
    Utils.fabState().updateBelt()
