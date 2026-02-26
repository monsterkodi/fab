extends Node

func saveGame():
    
    var savegame = SaveData.new()
    Post.saveGame.emit(savegame.data)
    #Log.log("saveGame", savegame.data)
    ResourceSaver.save(savegame, "user://savegame.tres")
    
func clearGame():
    
    ResourceSaver.save(SaveData.new(), "user://savegame.tres")
    self.loadGame()
        
func loadGame():

    var data = getSaveGame()
    if data:
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
    ResourceSaver.save(settings, "user://settings.tres")
