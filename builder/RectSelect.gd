class_name RectSelect
extends Builder

@onready var corners: Node3D = $Corners

var startPos  : Vector2i
var endPos    : Vector2i
var isPasting := false

const MAX_SIZE = 10000

const GHOST_MATERIAL      = preload("uid://b0use4n8rmlgb")
const GHOST_BLUE_MATERIAL = preload("uid://bqhwhtt3kc30s")

func _init():
    
    cursorShape = Control.CURSOR_CROSS
    
func start():
    
    Utils.setOverrideMaterial(corners, GHOST_MATERIAL)
    fab.tmp.setRectSelectColors()
    corners.show()

func stop():
    
    corners.hide()
    clearGhosts()
    
func pointerHover(pos):
    
    var delta = posRelativeToPointer(pos)
    startPos = pos
    endPos = pos
    if isPasting: moveGhosts(delta)
    updateCorners()

func pointerClick(pos):
    
    Utils.clearOverrideMaterial(corners)
        
    endPos = pos

    if isPasting: pasteGhosts()
    else:
        clearGhosts()
    
func clampEndPos(pos : Vector2i):
    
    var diff = pos - startPos
    var dx = diff.x
    var dy = diff.y

    var a = absi(dx * dy)
    
    if a <= MAX_SIZE:
        endPos = pos
        return
        
    var scale_factor : float = sqrt(float(MAX_SIZE) / float(a))
    var clamped_diff := Vector2(diff) * scale_factor
    endPos = startPos + Vector2i(clamped_diff.round())
        
func pointerShiftClick(pos):

    Utils.clearOverrideMaterial(corners)
        
    clampEndPos(pos)
    updateGhosts(true)
        
func pointerDrag(pos): 

    clampEndPos(pos)
    updateGhosts(Input.is_physical_key_pressed(KEY_SHIFT))
    
func pointerRelease(pos):
    
    pointerHover(pos)
    Utils.setOverrideMaterial(corners, GHOST_MATERIAL)        

func pointerContext(pos):
    
    if isPasting: stopPasting()
    startPos = pos
    endPos = pos
    clearGhosts()

func clearGhosts():

    super.clearGhosts()
    clearTemp()
    updateGhosts()
    
func updateGhosts(keepOld : bool = false):

    var maxx = max(startPos.x, endPos.x)  
    var maxy = max(startPos.y, endPos.y)
    var minx = min(startPos.x, endPos.x) 
    var miny = min(startPos.y, endPos.y)
    
    var newGhosts : Dictionary[Vector2i, Ghost] = {}
    var newTemps  : Dictionary[Vector2i, int] = {}
    
    for x in range(minx, maxx+1):
        for y in range(miny, maxy+1):
            var pos = Vector2i(x, y)
            if fab.machines.has(pos):
                var machine = fab.machines[pos]
                if not newGhosts.has(machine.pos):
                    var ghost = fab.ghostAtPos(machine.pos)
                    if not ghost:
                        ghost = fab.ghostForMachine(machine, GHOST_MATERIAL, ["Arrow"])
                    newGhosts[machine.pos] = ghost
                    
            if fab.beltAtPos(pos):
                if fab.tempAtPos(pos):
                    fab.delTempAtPos(pos)
                newTemps[pos] = fab.beltAtPos(pos)

    if keepOld:
        
        for i in range(fab.numTemp()):
            var pos = fab.tempPosAtIndex(i)
            if not newTemps.has(pos):
                newTemps[pos] = fab.tempAtPos(pos)
                
    else:
        for ghost in fab.ghosts():
            if not newGhosts.has(ghost.pos):
                ghost.queue_free()

    clearTemp()
    for pos in newTemps:
        fab.addTempAtPos(pos, newTemps[pos])
    updateCorners()

func updateCorners():
    
    var maxx = max(startPos.x, endPos.x)  
    var maxy = max(startPos.y, endPos.y)
    var minx = min(startPos.x, endPos.x) 
    var miny = min(startPos.y, endPos.y)
     
    corners.get_child(0).global_position = Vector3(maxx+0.5, 0, miny-0.5)
    corners.get_child(1).global_position = Vector3(maxx+0.5, 0, maxy+0.5)
    corners.get_child(2).global_position = Vector3(minx-0.5, 0, maxy+0.5)
    corners.get_child(3).global_position = Vector3(minx-0.5, 0, miny-0.5)
    
    corners.get_child(4).scale = Vector3(maxx-minx+1, 1, maxy-miny+1)
    corners.get_child(4).global_position = Vector3((minx+maxx)/2.0, corners.get_child(4).global_position.y, (miny+maxy)/2.0)

func xyRelativeToPointer(pos : Vector2i) -> Array[int]:
    
    if endPos: return [pos.x - endPos.x, pos.y - endPos.y]
    return [0, 0]

func posRelativeToPointer(pos : Vector2i) -> Vector2i:
    
    if endPos: return pos - endPos
    return Vector2i.ZERO
    
func moveGhosts(delta : Vector2i):
    
    for ghost in fab.ghosts():
        ghost.setPos(ghost.pos + delta)
        
    var newTemps : Dictionary[Vector2i, int] = {}
    if fab.numTemp() > 0:
        for i in range(fab.numTemp()):
            var pos = fab.tempPosAtIndex(i)
            newTemps[pos + delta] = fab.tempAtPos(pos)
        clearTemp()
        for pos in newTemps:
            fab.addTempAtPos(pos, newTemps[pos])
    
func pasteGhosts():    
    
    for ghost in fab.ghosts():
        fab.addMachineAtPosOfType(ghost.pos, ghost.type, ghost.orientation)
        
    if fab.numTemp() > 0:
        for i in range(fab.numTemp()):
            var pos = fab.tempPosAtIndex(i)
            fab.addBeltAtPos(pos, fab.tempAtPos(pos))

    stopPasting()
    
func stopPasting():
    
    isPasting = false
    fab.tmp.setRectSelectColors()
    clearGhosts()
    clearTemp()
    updateGhosts()
    
func copy():
    
    var data = {"machines": [], "belts": []}
    
    for ghost in fab.ghosts():
        var machine = ghost.proxy
        var pos = machine.pos
        data.machines.push_back([pos.x - endPos.x, pos.y - endPos.y, machine.type, machine.orientation])
            
    if fab.numTemp() > 0:
        for i in range(fab.numTemp()):
            var pos = fab.tempPosAtIndex(i)
            data.belts.push_back([pos.x - endPos.x, pos.y - endPos.y, fab.tempAtPos(pos)])
    
    var string = JSON.stringify(data) 

    DisplayServer.clipboard_set(string)    

func cut():  

    copy()
    
    for ghost in fab.ghosts():
        fab.delMachineAtPos(ghost.pos)
        
    if fab.numTemp() > 0:
        for i in range(fab.numTemp()):
            fab.delBeltAtPos(fab.tempPosAtIndex(i))
            
    clearGhosts()
    clearTemp()
    updateGhosts()
        
func paste(): 

    clearGhosts()
    clearTemp()
    
    var string = DisplayServer.clipboard_get()
    if string.is_empty(): return
    var data = JSON.parse_string(string)
    if not data is Dictionary: return
    if not data.has("belts") or not data.has("machines"): return

    for md in data.machines:
        var mp = Vector2i(md[0] + endPos.x, md[1] + endPos.y)
        var ghost = fab.ghostForType(md[2], GHOST_BLUE_MATERIAL, ["Arrow"])
        ghost.setOrientation(md[3])
        ghost.setPos(mp)

    for bd in data.belts:
        var bp = Vector2i(bd[0] + endPos.x, bd[1] + endPos.y)
        fab.addTempAtPos(bp, bd[2])
    
    updateGhosts(true) 
    fab.tmp.setBeltBuilderColors()
    isPasting = true
            
func _shortcut_input(event: InputEvent):
    
    if not event.pressed: return
    #Log.log("event", event)
    if event.is_action("cut"):   cut();   get_viewport().set_input_as_handled(); return
    if event.is_action("copy"):  copy();  get_viewport().set_input_as_handled(); return
    if event.is_action("paste"): paste(); get_viewport().set_input_as_handled(); return
    
func pointerRotate():
    
    if isPasting:
        fab.tmp.rotateAround(endPos)
        for ghost in fab.ghosts():
            ghost.rotateAround(endPos)
        
