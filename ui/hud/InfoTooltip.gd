extends PanelContainer

const MACHINE_COST = preload("uid://cc1hgcwcl8ymg")

func _ready():
    
    Post.subscribe(self)
    theme = preload("uid://ck2ofhthyh3rs")
    hide()
    
func clear():
    
    while get_child_count():
        get_child(0).queue_free()
        remove_child(get_child(0))
    reset_size()

func infoTooltip(string : String, button : Button):
    
    clear()
    show()
    if Mach.Type.has(string) or string == "BuildingBelt":
        #Log.log("machine.tooltip", string)
        var machineCost : Control = MACHINE_COST.instantiate()
        machineCost.setMachineName(string)
        add_child(machineCost)
        reset_size()
        global_position.x = button.get_global_rect().get_center().x - get_global_rect().size.x / 2 
        global_position.y = button.get_global_rect().position.y - get_global_rect().size.y
    elif Item.Type.has(string):
        global_position = button.get_global_rect().end
    #else:
        #Log.log("misc.tooltip", string)

func infoTooltipHide():

    clear()    
    hide()
