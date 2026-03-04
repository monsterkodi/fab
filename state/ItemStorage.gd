class_name ItemStorage
extends Node

var storage : Dictionary[Item.Type, int]

func _ready():
    
    reset()
    
func addItem(type : Item.Type):
    
    storage[type] += 1
    
func reset():
    
    for type in Item.Types:
        storage[type] = 0

    storage[Item.Type.CubeBlack] = 10
    
func canAfford(type):

    var cost = Mach.costForType(type)
    #Log.log(type, cost)
    for itemType in cost:
        if storage[itemType] < cost[itemType]: return false
    return true
    
func refund(type):

    var cost = Mach.costForType(type)
    for itemType in cost:
        storage[itemType] += cost[itemType]
    
func buy(type):
    
    var cost = Mach.costForType(type)
    for itemType in cost:
        storage[itemType] -= cost[itemType]
    
