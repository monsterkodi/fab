class_name Machine
extends Node

var pos   : Vector2i
var type  : int
var slots : Array
var slits : Array

func _ready():
    
    assert(type)
    
    var fabState = Utils.fabState()

    for slit in slits:
        fabState.beltPieces[pos + slit.pos] = Belt.fixOutput(Belt.INPUT[slit.dir])

    for slot in slots:
        fabState.beltPieces[pos + slot.pos] = Belt.fixInput(Belt.OUTPUT[slot.dir])
        
    fabState.updateBelt()
    
func setOrientation(orientation):
    Log.log("orientation", orientation)
    for slot in slots:
        Log.log("slot before", slot)
        slot.pos = Belt.orientatePos(orientation, slot.pos)
        slot.dir = Belt.orientateDir(orientation, slot.dir)
        Log.log("slot after", slot)
        
    for slit in slits:
        slit.pos = Belt.orientatePos(orientation, slit.pos)
        slit.dir = Belt.orientateDir(orientation, slit.dir)
    
func _exit_tree():
    
    #Log.log("exit", name)
    Utils.fabState().machines.erase(pos)    

func consume():
    
    for i in range(slits.size()):
        var slit = slits[i]
        var bs = Utils.fabState().beltStateAtPos(pos + slit.pos)
        if bs.get_child_count():
            var item = bs.get_child(0)
            if item.advance >= 1:
                if consumeItemAtSlit(item, slit):
                    item.queue_free()
    
func advanceAtSlotIndex(i):
    
    var slot = slots[i]
    var bs = Utils.fabState().beltStateAtPos(pos + slot.pos)
    var inDir = Belt.OPPOSITE[slot.dir]
    return bs.inSpace(inDir)
    
func produce():
    
    for i in range(slots.size()):
        var adv = advanceAtSlotIndex(i)
        if adv >= 0:
            var item = produceItemAtSlot(slots[i])
            if item:
                var bs = Utils.fabState().beltStateAtPos(pos + slots[i].pos)
                bs.addItem(Belt.OPPOSITE[slots[i].dir], item)
        
func produceItemAtSlot(slot): return null
func consumeItemAtSlit(item, slit): return null
