extends Node
class_name BeltBuilder

var beltPieces: Dictionary[Vector2i, int]
var tempPoints: Dictionary[Vector2i, int]
var lastTemp
var trail = []

func start():
    
    beltPieces = Utils.fabState().beltPieces
    tempPoints = Utils.fabState().tempPoints
    
func stop():
    
    tempPoints.clear()
    lastTemp = null
    trail = []
    updateTemp()    
    
func pointerClick(pos):
    
    tempPoints.clear()
    addTempPoint(pos)
    updateTemp()
    
func addTempPoint(pos):
    
    if lastTemp:
        trail.push_back(lastTemp)

    tempPoints[pos] = beltTypeAtPos(pos)
    
    if lastTemp:
        tempPoints[lastTemp] = neighborConnect(lastTemp, 0)
        
    lastTemp = pos

func beltTypeAtPos(pos):
    
    var type = 0
    
    if lastTemp:
        type = Belt.setInput(type, Belt.dirForPositions(pos, lastTemp))

    return neighborConnect(pos, type)    
    
func neighborConnect(pos, type):
    
    var otype = type
    var tempConnected = Belt.connectNeighbors(pos, tempPoints, type)
    
    type = Belt.connectNeighbors(pos, beltPieces, tempConnected)
    
    if Belt.hasNoOutput(type) and lastTemp and lastTemp != pos:
        type = Belt.connectNeighbors(pos, beltPieces, Belt.setOutput(tempConnected, Belt.dirForPositions(lastTemp, pos)))
    elif Belt.hasNoInput(type) and tempConnected:
        type = Belt.connectNeighbors(pos, beltPieces, Belt.fixInput(tempConnected))
        
    if type == 0:
        type = Belt.I_W | Belt.O_E # 0b0001_0100
        
    if Belt.isInvalidType(type):
        Log.warn(Belt.stringForType(type))

    return type
             
func pointerShiftClick(pos):
    
    if tempPoints.is_empty(): 
        pointerClick(pos)
    else:
        pointerDrag(pos)
        
func popTrail():
    
    if trail.size() > 1 and tempPoints.has(trail[-1]):
        tempPoints[trail[-1]] = Belt.clearOutput(tempPoints[trail[-1]], Belt.dirForPositions(trail[-1], lastTemp))
    tempPoints.erase(lastTemp)
    lastTemp = trail.pop_back()
    updateTemp()
    
func pointerDrag(pos):
    
    if tempPoints.is_empty(): 
        return
        
    if pos == lastTemp: 
        return
        
    if not trail.is_empty() and pos == trail[-1]:
        popTrail()
        return
        
    while lastTemp.x - pos.x > 1: # interpolate horizontally
        addTempPoint(Vector2i(lastTemp.x-1, lastTemp.y))
        
    while lastTemp.x - pos.x < -1:
        addTempPoint(Vector2i(lastTemp.x+1, lastTemp.y))
        
    while lastTemp.y - pos.y > 1: # interpolate vertically
        addTempPoint(Vector2i(lastTemp.x, lastTemp.y-1))
        
    while lastTemp.y - pos.y < -1:
        addTempPoint(Vector2i(lastTemp.x, lastTemp.y+1))
    
    if lastTemp.x != pos.x and lastTemp.y != pos.y: # fill corner in diagonal case
        if lastTemp.x - pos.x > 0:
            addTempPoint(Vector2i(lastTemp.x-1, lastTemp.y))
        else:
            addTempPoint(Vector2i(lastTemp.x+1, lastTemp.y))
        
    addTempPoint(pos)
    updateTemp()
    
func pointerCancel(pos):
    
    stop()
    
func pointerRelease(p):
    
    for pos in tempPoints:
            
        if Belt.isInvalidType(tempPoints[pos]):
            Log.warn("RELEASE", Belt.stringForType(tempPoints[pos]))
            
        beltPieces[pos] = tempPoints[pos]
        
    tempPoints.clear()
    lastTemp = null
    trail = []
    updateTemp()
    updateBelt()
    
func updateTemp():
    Utils.fabState().updateTemp()
    
func updateBelt():
    Utils.fabState().updateBelt()
