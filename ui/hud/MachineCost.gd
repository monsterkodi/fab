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

    for item in cost:
        %IconGrid.addButton(Item.iconResForType(item), item)
        %IconGrid.setNumber(item, cost[item])
