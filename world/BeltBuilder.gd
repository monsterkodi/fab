extends Node
class_name BeltBuilder

var beltPieces: Dictionary[Vector2i, int]
var tempPoints: Dictionary[Vector2i, int]
var lastTemp
var trail = []

func start():
    
    beltPieces = Utils.buildings().beltPieces
    tempPoints = Utils.buildings().tempPoints
    
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
        # make sure the last point has an output in the new direction
        var tp = tempPoints[lastTemp]
        
        if   lastTemp.x < pos.x: tp = initialBeltWithDir(tp, Belt.E)
        elif lastTemp.y < pos.y: tp = initialBeltWithDir(tp, Belt.S)
        elif lastTemp.x > pos.x: tp = initialBeltWithDir(tp, Belt.W)
        elif lastTemp.y > pos.y: tp = initialBeltWithDir(tp, Belt.N)

        #if Belt.isInvalidType(tp):
            #Log.log(Belt.stringForType(tp))
            
        tempPoints[lastTemp] = tp
        trail.push_back(lastTemp)

    tempPoints[pos] = beltTypeAtPos(pos)
    lastTemp = pos
    
func initialBeltWithDir(tp, dir):
    
    tp = Belt.setOutput(tp, dir)
    if tempPoints.size() == 1: 
        for d in Belt.DIRS:
            var nt = beltPieces.get(lastTemp + Belt.NEIGHBOR[d], 0)
            if not (nt & Belt.OUTPUT_DIR[d]) and (tp & Belt.INPUT[d]):
                tp = Belt.clearInput(tp, d)
            if d != dir and (tp & Belt.OUTPUT[d]):
                if not nt or not (nt & Belt.INPUT_DIR[d]):
                    tp = Belt.clearOutput(tp, d)
    return tp
    
func beltTypeAtPos(pos):
    
    var bt = 0
    var mightNeedOutput = false
    
    for d in Belt.DIRS:
        var np = pos + Belt.NEIGHBOR[d]
        var nt = tempPoints.get(np, 0)
        if nt:
            if nt & (1 << (((d + 2) % 4) + 4)):
                bt |= (1 << d)
            elif nt & (1 << ((d + 2) % 4)):
                bt |= (1 << d+4)
        else:        
            nt = beltPieces.get(np, 0)
            if nt:
                if nt & (1 << (((d + 2) % 4) + 4)):
                    bt = Belt.setInput(bt, d)
                    mightNeedOutput = true
                elif nt & (1 << ((d + 2) % 4)):
                    bt = Belt.setOutput(bt, d)
         
    if mightNeedOutput:           
        bt = Belt.addAnyOutput(bt)
                
    if bt == 0:
        bt = 0b0001_0100
        
    if beltPieces.has(pos):
        bt = combineBeltTypes(beltPieces[pos], bt)
    return bt
    
func combineBeltTypes(old: int, new: int) -> int:
    
    # remove outputs that conflict with new inputs, and vice versa
    var inputs  = (old & 0b00001111) & ~((new >> 4) & 0b00001111)
    var outputs = (old & 0b11110000) & ~((new << 4) & 0b11110000)
    
    # merge input and outputs with new belt
    return inputs | outputs | new   
    
func pointerShiftClick(pos):
    
    if tempPoints.is_empty(): 
        pointerClick(pos)
    else:
        pointerDrag(pos)
        
func popTrail():
    
    if not trail.is_empty() and tempPoints.has(trail[-1]):
        if   trail[-1].x < lastTemp.x: tempPoints[trail[-1]] = Belt.clearOutput(tempPoints[trail[-1]], Belt.E)
        elif trail[-1].y < lastTemp.y: tempPoints[trail[-1]] = Belt.clearOutput(tempPoints[trail[-1]], Belt.S)
        elif trail[-1].x > lastTemp.x: tempPoints[trail[-1]] = Belt.clearOutput(tempPoints[trail[-1]], Belt.W)
        elif trail[-1].y > lastTemp.y: tempPoints[trail[-1]] = Belt.clearOutput(tempPoints[trail[-1]], Belt.N)
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
        if Belt.hasNoOutput(tempPoints[pos]):
            tempPoints[pos] = Belt.fixOutput(tempPoints[pos])
        if Belt.hasNoInput(tempPoints[pos]):
            tempPoints[pos] = Belt.fixInput(tempPoints[pos])
        if Belt.isInvalidType(tempPoints[pos]):
            Log.warn(Belt.stringForType(tempPoints[pos]))
        beltPieces[pos] = tempPoints[pos]
        
    tempPoints.clear()
    lastTemp = null
    trail = []
    updateTemp()
    updateBelt()
    
func updateTemp():
    Utils.buildings().updateTemp()
    
func updateBelt():
    Utils.buildings().updateBelt()
