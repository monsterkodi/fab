extends Node

func _ready(): 
    
    Log.log("Saver.ready")

func saveGame():
    
    var savegame = SaveData.new()
    Post.saveGame.emit(savegame.data)
    Log.log("saveGame", savegame.data)
    ResourceSaver.save(savegame, "user://savegame.tres")
    
func clearGame():
    
    var savegame = SaveData.new()
    ResourceSaver.save(savegame, "user://savegame.tres")
    self.loadGame()
        
func loadGame():

    var data = getSaveGame()
    if data:
        #Log.log("loadGame", data)
        Post.loadGame.emit(data)

func getSaveData(resource):

    if ResourceLoader.exists(resource):
        return load(resource).data
    return null
    
func getSaveGame(): return getSaveData("user://savegame.tres")
func getSettings(): return getSaveData("user://settings.tres")

func saveSettings():
    
    var settings = SaveData.new()
    settings.data = Settings.settings
    #Log.log("saveSettings", settings.data)
    ResourceSaver.save(settings, "user://settings.tres")
