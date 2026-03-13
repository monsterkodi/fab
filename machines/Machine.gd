class_name Machine
extends Node

var pos   : Vector2i
var type  : int
var belts : Array
var slots : Array
var slits : Array
var orientation = 0
var bdg
var fab : FabState
var mst : MachState

const BLINK_TIME = 4.0

func _init(t, p, o):
    
    type  = t
    belts = Mach.beltsForType(type)
    slots = Mach.slotsForType(type)
    slits = Mach.slitsForType(type)
    
    pos = p
    setOrientation(o)

func _ready():
    
    assert(type)
    
    fab = get_parent().get_parent()
    mst = fab.mst
    
    for belt in belts:
        fab.addBeltAtPos(pos + belt.pos, belt.type)
    
    for slit in slits:
        slit.idle = 0
        fab.addBeltAtPos(pos + slit.pos, Belt.INPUT[slit.dir])

    for slot in slots:
        slot.idle = 0
        fab.addBeltAtPos(pos + slot.pos, Belt.OUTPUT[slot.dir])
        
    for opos in getOccupied():
        fab.machines[opos] = self
                
    createBuilding()

func createBuilding():
    
    bdg = MachState.Building.new(type, pos, Utils.basisForOrientation(orientation))
    mst.add(bdg)
    
func hide():
    
    if bdg:
        mst.del(bdg)
        bdg = null
        
func show():
    
    if not bdg:
        createBuilding()

func _exit_tree():
    
    if bdg:
        fab.mst.del(bdg)
        bdg = null
        
    for belt in belts:
        fab.delBeltAtPos(pos + belt.pos)
    for slot in slots:
        fab.delBeltAtPos(pos + slot.pos)
    for slit in slits:
        fab.delBeltAtPos(pos + slit.pos)
        
    for opos in getOccupied():
        fab.machines.erase(opos)
        
func rotateCW():
    
    orientation = ((orientation + 1) % 4)

    for belt in belts:
        belt.pos  = Belt.rotatePos(belt.pos)
        belt.type = Belt.rotateType(belt.type)

    for slot in slots:
        slot.pos = Belt.rotatePos(slot.pos)
        slot.dir = Belt.rotateDir(slot.dir)
        
    for slit in slits:
        slit.pos = Belt.rotatePos(slit.pos)
        slit.dir = Belt.rotateDir(slit.dir)
        
    if bdg: mst.rotateBuilding(bdg)

func rotateAround(center: Vector2i):

    setPos(Belt.rotatePosAround(pos, center))
    rotateCW()
        
func setPos(p):
    
    pos = p
    if bdg: mst.setBuildingPos(bdg, p)

func setOrientation(o : int):
    
    orientation = o
    
    for belt in belts:
        belt.pos  = Belt.orientatePos(o, belt.pos)
        belt.type = Belt.orientateType(o, belt.type)

    for slot in slots:
        slot.pos = Belt.orientatePos(o, slot.pos)
        slot.dir = Belt.orientateDir(o, slot.dir)
        
    for slit in slits:
        slit.pos = Belt.orientatePos(o, slit.pos)
        slit.dir = Belt.orientateDir(o, slit.dir)
        
    if bdg:
        for i in range(o):
            mst.rotateBuilding(bdg)
            
func hasSlotArrows():
    
    return type not in [Mach.Type.Tunnel, Mach.Type.Tunnel2, Mach.Type.Tunnel3]

func hasSlitArrows():
    
    return type not in [Mach.Type.Tunnel, Mach.Type.Tunnel2, Mach.Type.Tunnel3]
    
func consume(delta:float):
    
    var advance = delta * 0.5
    
    for i in range(slits.size()):
        var slit = slits[i]
        var item = fab.consumableItemAtPos(pos + slit.pos, advance)
        if item:
            if consumeItemAtSlit(item, slit):
                fab.delItem(item)
                if slits[i].idle:
                    slits[i].idle = 0
                    if bdg and hasSlitArrows():
                        bdg.modules[2*i + 1].color = COLOR.ARROW
                        bdg.modules[2*i + 1].trans.origin.y = 0.9
                        mst.add(bdg)
        else:
            slits[i].idle += delta
            if hasSlitArrows():
                if bdg and slits[i].idle >= BLINK_TIME and slits[i].idle-delta < BLINK_TIME:
                    bdg.modules[2*i + 1].color = COLOR.SLIT
                    bdg.modules[2*i + 1].trans.origin.y = 0.901
                    mst.add(bdg)
    
func advanceAtSlotIndex(i):
    
    return fab.inSpace(pos + slots[i].pos, Belt.OPPOSITE[slots[i].dir])
    
func produce(delta:float):
    
    var advance = delta * 0.5
    
    for i in range(slots.size()):
        var adv = advanceAtSlotIndex(i)
        if adv >= 0:
            var item = produceItemAtSlot(slots[i])
            if item:
                item.advance = minf(advance, adv)
                fab.addItem(pos + slots[i].pos, Belt.OPPOSITE[slots[i].dir], item)
                if slots[i].idle:
                    slots[i].idle = 0
                    if bdg and hasSlotArrows(): # this sucks!
                        bdg.modules[slits.size() * 2 + 2*i + 1].color = COLOR.ARROW # crap
                        bdg.modules[slits.size() * 2 + 2*i + 1].trans.origin.y = 0.9
                        mst.add(bdg)
        else:
            slots[i].idle += delta
            if hasSlotArrows(): # sucks also!
                if bdg and slots[i].idle >= BLINK_TIME and slots[i].idle-delta < BLINK_TIME:
                    bdg.modules[slits.size() * 2 + 2*i + 1].color = COLOR.SLOT
                    bdg.modules[slits.size() * 2 + 2*i + 1].trans.origin.y = 0.901
                    mst.add(bdg)
                elif bdg and slots[i].idle >= BLINK_TIME*2:
                    slots[i].idle = BLINK_TIME*0.75
                    bdg.modules[slits.size() * 2 + 2*i + 1].color = COLOR.ARROW
                    mst.add(bdg)
        
func produceItemAtSlot(slot): return null
func consumeItemAtSlit(item, slit): return false

func getOccupied() -> Array[Vector2i]:

    var posl : Array[Vector2i] = []
    for slot in slots:
        posl.push_back(pos + slot.pos)
    for slit in slits:
        posl.push_back(pos + slit.pos)
    if not posl.has(pos):
        posl.push_front(pos)    
    return posl
    
func isRoot(): return pos.x == 0 and pos.y == 0
        
func slitAtPos(p : Vector2i):
    
    var relPos = p - pos
    for slit in slits:
        if slit.pos == relPos:
            return slit
    return null

    
