class_name ItemStorage
extends Node

var maxItem : int = 10000
var storage : Dictionary[Item.Type, int]

func _ready():
    
    reset()
    
func saveData() -> Dictionary[Item.Type, int]: return storage
func loadData(data : Dictionary[Item.Type, int]):
    
    storage = data 
    for type in storage:
        storage[type] = mini(maxItem, storage[type])

func canTakeItem(type : Item.Type):
    if type == Item.Type.Energy: return true
    return storage[type] < maxItem
    
func addItem(type : Item.Type):

    if type != Item.Type.Energy:
        assert(storage[type] <= maxItem)
        if storage[type] == maxItem: return
        if storage[type] == maxItem-1:
            storage[type] = maxItem
            Post.storageItemMax.emit(type)
            return
    if storage[type] == 0:
        Post.storageItemChange.emit(type)
    storage[type] += 1
    
func addItems(type : Item.Type, num : int):
    
    assert(num > 0)
    if type != Item.Type.Energy:
        assert(storage[type] <= maxItem)
        if storage[type] == maxItem: return
        if storage[type] + num >= maxItem:
            storage[type] = maxItem
            Post.storageItemMax.emit(type)
            return
    if storage[type] == 0:
        Post.storageItemChange.emit(type)
    storage[type] += num
    
func delItems(type : Item.Type, num : int):
    
    assert(num > 0)
    assert(storage[type] >= 0)
    if storage[type] == 0: return
    if storage[type] - num <= 0:
        storage[type] = 0
        Post.storageItemEmpty.emit(type)
        return
    if storage[type] == maxItem:
        Post.storageItemChange.emit(type)
    storage[type] -= num
    
func reset():
    
    for type in Item.Types:
        storage[type] = 1000

    storage[Item.Type.CubeBlack] = 100
    
func canAfford(type):

    var cost = Mach.costForType(type)
    for itemType in cost:
        if storage[itemType] < cost[itemType]: return false
    return true
    
func refund(type):

    var cost = Mach.costForType(type)
    for itemType in cost:
        addItems(itemType, cost[itemType])
    
func buy(type):
    
    var cost = Mach.costForType(type)
    for itemType in cost:
        delItems(itemType, cost[itemType])
    
