extends Builder
class_name BuildingBuilder

var buildingName
var buildingType

func setBuilding(string):
    buildingName = string
    buildingType = Mach.typeForString(string)

func pointerClick(pos): 
    
    Utils.fabState().addMachineAtPosOfType(pos, buildingType)
