class_name MachineCost
extends PanelContainer

var machineName : String

func setMachineName(string : String):
    
    machineName = string
    
func _ready():
    
    %MachineName.text = machineName
    
    var cost
    if machineName == "BuildingBelt":
        cost = {Item.Type.CubeBlack: 1}
    else:
        cost = Mach.costForType(Mach.typeForString(machineName))
    var index = 0
    for item in cost:
        %IconGrid.addIcon(Item.iconResForType(item))
        %IconGrid.setNumber(index, cost[item])
        index += 1
