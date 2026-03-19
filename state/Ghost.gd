class_name Ghost
extends Machine

var proxy : Machine
var color : Color

func _ready():

    assert(type)
    
    if proxy:
        proxy.hide()

    fab = get_parent().get_parent()
    mst = fab.gst
    createBuilding()
    
func setColor(c : Color): 
    
    color = c
    if bdg:
        for module in bdg.modules:
            if module.kind == Module.Kind.ARROW_IN:
                module.color = Color(4,0,0)
            elif module.kind == Module.Kind.ARROW_OUT:
                module.color = Color(0.2,0.2,4)
            else:
                module.color = color
        mst.add(bdg)
    
func createBuilding():
    
    bdg = newBuilding()
    setColor(color)
    
func _exit_tree():
    
    if proxy:
        proxy.show()

    if bdg:
        mst.del(bdg)
        bdg = null
