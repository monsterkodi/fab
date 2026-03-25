class_name ItemStats
extends Node

var storage   : ItemStorage
var lastItems : Dictionary[Item.Type, int]
var graphs    : Dictionary[Item.Type, Array]
var deltaSum  : float

const INTERVAL := 10.0

func _ready():
    
    Post.subscribe(self)
    
func levelStart():
    
    deltaSum = 0
    storage  = Utils.fabState().storage

func fabState(delta: float):
    
    deltaSum += delta
    if deltaSum < INTERVAL: return
    deltaSum -= INTERVAL
    if lastItems:
        for item in storage.storage:
            if not graphs.has(item): graphs[item] = []
            graphs[item].push_back(maxf(0.0, (storage.storage[item] - lastItems[item])/INTERVAL)) 
            if graphs[item].size() > 1500/5:
                graphs[item].pop_front()
        Post.itemStats.emit()
    lastItems = storage.storage.duplicate()
