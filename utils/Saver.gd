extends Node

var savegame : SaveData
var settings : SaveData

func _ready(): 
    
    savegame = SaveData.new()
    assert(savegame.data != null)
    settings = SaveData.new()
    assert(settings.data != null)
    Log.log("Saver.ready")

func saveGame():
    
    savegame = SaveData.new()
    Post.saveGame.emit(savegame.data)
    Log.log("saveGame", savegame.data)
    ResourceSaver.save(savegame, "user://savegame.tres")
    
func clearGame():
    
    savegame = SaveData.new()
    ResourceSaver.save(savegame, "user://savegame.tres")
    self.loadGame()
        
func loadGame():

    var data = getSaveGame()
    if data:
        Log.log("loadGame", data)
        Post.loadGame.emit(data)
        return data
    return null

func getSaveData(resource):

    if ResourceLoader.exists(resource):
        var sd = load(resource)
        if sd: 
            #Log.log("getSaveData", resource, sd.data)
            return sd.data
    return null
    
func getSaveGame(): return getSaveData("user://savegame.tres")
func getSettings(): return getSaveData("user://settings.tres")

func saveSettings():
    
    settings = SaveData.new()
    settings.data = Settings.settings
    #Log.log("saveSettings", settings.data)
    ResourceSaver.save(settings, "user://settings.tres")
