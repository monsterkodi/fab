class_name RectSelect
extends Builder

@onready var corners: Node3D = $Corners

var startPos
var endPos

var ghosts : Dictionary[Vector2i, Ghost]
const GHOST_MATERIAL = preload("uid://b0use4n8rmlgb")

func _ready():
    
    cursorShape = Control.CURSOR_CROSS
    
func start():
    
    Utils.setOverrideMaterial(corners, GHOST_MATERIAL)
    fabState().mm().setRectSelectColors()
    corners.show()

func stop():
    
    corners.hide()
    clearGhosts()
    
func pointerHover(pos):
    
    startPos = pos
    endPos = pos
    updateCorners()

func pointerClick(pos):
            
    Utils.clearOverrideMaterial(corners)
        
    endPos = pos
    
    clearGhosts()
    updateGhosts()

func pointerShiftClick(pos):

    Utils.clearOverrideMaterial(corners)
        
    endPos = pos
    
    updateGhosts(true)
        
func pointerDrag(pos): 

    endPos = pos
    updateGhosts(Input.is_physical_key_pressed(KEY_SHIFT))
    
func pointerRelease(pos):
    
    pointerHover(pos)
    Utils.setOverrideMaterial(corners, GHOST_MATERIAL)

func pointerCancel(pos):
    
    startPos = pos
    endPos = pos
    clearGhosts()
    updateGhosts()

func clearGhosts():
    
    for ghost in ghosts:
        ghosts[ghost].queue_free()
    ghosts.clear()
    
    clearTemp()
    
func updateGhosts(keepOld=false):

    var maxx = max(startPos.x, endPos.x)  
    var maxy = max(startPos.y, endPos.y)
    var minx = min(startPos.x, endPos.x) 
    var miny = min(startPos.y, endPos.y)
    
    #Log.log("minmax", keepOld, minx, miny, maxx, maxy)

    var newGhosts : Dictionary[Vector2i, Ghost] = {}
    var newTemps  : Dictionary[Vector2i, int] = {}
    for x in range(minx, maxx+1):
        for y in range(miny, maxy+1):
            var pos = Vector2i(x, y)
            if fabState().machines.has(pos):
                var machine = fabState().machines[pos]
                if ghosts.has(pos):
                    newGhosts[pos] = ghosts[pos]
                    ghosts.erase(pos)
                else:
                    newGhosts[pos] = fabState().ghostForMachine(machine, GHOST_MATERIAL, ["Arrow"])
                    
            if fabState().beltPieces.has(pos):
                if fabState().tempPoints.has(pos):
                    fabState().tempPoints.erase(pos)
                newTemps[pos] = fabState().beltPieces[pos]

    if keepOld:
        for pos in ghosts:
            if not newGhosts.has(pos):
                newGhosts[pos] = ghosts[pos]
        ghosts.clear()
        
        for pos in fabState().tempPoints:
            if not newTemps.has(pos):
                newTemps[pos] = fabState().tempPoints[pos]

    clearGhosts()
    ghosts = newGhosts
    
    clearTemp()
    fabState().tempPoints = newTemps
    updateTemp()
    
    updateCorners()

func updateCorners():
    
    var maxx = max(startPos.x, endPos.x)  
    var maxy = max(startPos.y, endPos.y)
    var minx = min(startPos.x, endPos.x) 
    var miny = min(startPos.y, endPos.y)
     
    corners.get_child(0).global_position = Vector3(maxx, 0, miny)
    corners.get_child(1).global_position = Vector3(maxx, 0, maxy)
    corners.get_child(2).global_position = Vector3(minx, 0, maxy)
    corners.get_child(3).global_position = Vector3(minx, 0, miny)
    
    corners.get_child(4).scale = Vector3(maxx-minx+1, 1, maxy-miny+1)
    corners.get_child(4).global_position = Vector3((minx+maxx)/2.0, corners.get_child(4).global_position.y, (miny+maxy)/2.0)

func cut():  

    if not ghosts.is_empty():
        for pos in ghosts:
            fabState().delMachineAtPos(ghosts[pos].pos)
        
    if not fabState().tempPoints.is_empty():
        for pos in fabState().tempPoints:
            fabState().delBeltAtPos(pos)
            
    clearGhosts()
    clearTemp()
    updateGhosts()
        
func paste(): 
    
    if not ghosts.is_empty():
        Log.log("paste")

func _shortcut_input(event: InputEvent):

    if event.is_action("cut"):   cut();   get_viewport().set_input_as_handled(); return
    if event.is_action("paste"): paste(); get_viewport().set_input_as_handled(); return
