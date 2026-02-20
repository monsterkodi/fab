class_name Machine
extends Node

var pos   : Vector2i
var type  : int
var slots : Array

func _ready():
    
    assert(type)
    
    #Log.log("New Machine", Mach.stringForType(type))
    var fabState = Utils.fabState()
    for slot in slots:
        #Log.log("slot", slot.pos, slot.type)
        fabState.beltPieces[pos + slot.pos] = Belt.fixInput(Belt.OUTPUT[slot.type])
        
    fabState.updateBelt()

func consume():
    
    pass
    
func produce():
    
    for i in range(slots.size()):
        var bs = Utils.fabState().beltStateAtPos(pos + slots[i].pos)
        var adv = bs.hasSpace(0.3)
        if adv >= 0:
            bs.addItem(Item.new())
        
