class_name Deleter
extends Builder

var beltPieces: Dictionary[Vector2i, int]
var ghost

const GHOST_MATERIAL = preload("uid://b35kuqwv15nfr")

func _ready():
    
    cursorShape = Control.CURSOR_FORBIDDEN
    
func stop():
    
    if ghost: ghost.free()

func start():
    
    beltPieces = Utils.fabState().beltPieces
    
func pointerClick(pos):
    
    Utils.fabState().delObjectAtPos(pos)
    
func pointerDrag(pos): pointerClick(pos)
        
func pointerHover(pos):
    
    if Utils.fabState().machines.has(pos):
        if ghost: ghost.free()
        ghost = Utils.fabState().machines[pos].createGhost(GHOST_MATERIAL)
    elif ghost:
        ghost.free()
