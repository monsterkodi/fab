extends PanelContainer

func _ready():
    
    Post.subscribe(self)
    hide()
    
func infoTooltip(string : String, button : Button):
    
    if Mach.TypeMap.has(string):
        Log.log("machine.tooltip", string, button.get_global_rect().position)
        global_position = button.get_global_rect().position
    elif Item.TypeMap.has(string):
        Log.log("item.tooltip", string, button.get_global_rect().end)
        global_position = button.get_global_rect().end
    show()

func infoTooltipHide():
    
    hide()
