class_name World
extends Node

var currentLevelName : String
var currentLevel     : Level
var currentLevelRes  : PackedScene
          
func _ready():
    
    %MenuHandler.hideAllMenus()
    
    Post.subscribe(self)
    
    Settings.apply(Settings.defaults)

    loadGame()
    
    #%MenuHandler.activeMenu = %MainMenu
    #%MusicHandler.playMenuMusic()
    newGame()
    #mainMenu()
        
func mainMenu():
    
    get_tree().paused = true
    saveLevel()
    %MenuHandler.appear(%MainMenu)

func _process(delta: float):
    
    var orphan = Node.get_orphan_node_ids()
    if not orphan.is_empty():
        Node.print_orphan_nodes()
        Log.log("orphans")
        #quitGame()
        
func _unhandled_input(event: InputEvent):
    
    if Input.is_action_just_pressed("pause"): pauseMenu();   return
    if Input.is_action_just_pressed("quit"):  quitGame();    return
                
func newGame():
    
    Saver.clear()
    const LEVEL = preload("uid://b1g34431itmpg")
    playLevel(LEVEL)
        
func pauseMenu():
    
    if not get_tree().paused:
        pauseGame()
        %MenuHandler.appear(%PauseMenu)
        
func pauseGame():
    
    %MenuHandler.slideOutTop(%Hud)
    
    get_tree().call_group("game", "gamePaused")
    get_tree().paused = true
    Post.gamePaused.emit()
           
func resumeGame():
    
    %MenuHandler.vanishActive()
    
    %MenuHandler.slideInTop(%Hud)
    
    get_tree().paused = false
    get_tree().call_group("game", "gameResumed")
    Post.gameResume.emit()
        
func quitGame():
    
    Saver.save()
    get_tree().quit()
        
func saveGame():
    
    Saver.save()
    
func loadGame():
    
    Saver.load()
    
func settings(backMenu:Menu):
    
    %SettingsMenu.backMenu = backMenu
    %MenuHandler.appear(%SettingsMenu)
    
func clearLevel():
    Log.log("clearLevel", currentLevel)
    if currentLevel:
        currentLevel.clear(Saver.savegame.data)
        Saver.save()
        currentLevel.free()

func retryLevel():
    
    loadLevel(currentLevelRes)
    
func playLevel(levelRes):
    
    loadLevel(levelRes)
        
func loadLevel(levelRes):
    
    currentLevelRes = levelRes
    currentLevel = levelRes.instantiate()
    currentLevel.inert = false
    currentLevelName = currentLevel.name
    Log.log("currentLevelName", currentLevelName)
    add_child(currentLevel)
    currentLevel.start()
    Post.startLevel.emit()
    
    var isFresh = true
    if Saver.savegame.data.has("Level") and Saver.savegame.data.Level.has(currentLevel.name):
        if Saver.savegame.data.Level[currentLevel.name]:
            currentLevel.loadLevel(Saver.savegame.data)
            isFresh = not Saver.savegame.data.Level[currentLevel.name].has("gameTime")
            Post.levelLoaded.emit()

    Post.levelStart.emit()
    resumeGame()

func saveLevel():
    
    if currentLevel:
        
        currentLevel.save(Saver.savegame.data)
        saveGame()
        Post.levelSaved.emit(currentLevel.name)
        currentLevel.free()
