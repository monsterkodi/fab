class_name World
extends Node

var currentLevel : Level
const LEVEL = preload("uid://b1g34431itmpg")
                    
func _ready():
    
    %MenuHandler.hideAllMenus()
    
    Post.subscribe(self)
    
    var settings = Settings.defaults
    var sd = Saver.getSettings()
    if sd: settings = sd
    Settings.apply(settings)
    
    %MusicHandler.playMenuMusic()
    get_tree().paused = true
    
    if Saver.getSaveGame(): # bypass main menu when savegame exists
        Post.continueGame.emit()
        return
        
    %MenuHandler.appear(%MainMenu)
    
func mainMenu():
    
    get_tree().paused = true
    #Saver.saveGame() # done in pause menu for now
    %MenuHandler.appear(%MainMenu)

func _process(delta: float):
    
    var orphan = Node.get_orphan_node_ids()
    if not orphan.is_empty():
        Log.log(orphan.size(), "orphans")
        Node.print_orphan_nodes()
        #quitGame()
        pass
        
func _unhandled_input(event: InputEvent):
    
    if Input.is_action_just_pressed("pause"): pauseMenu();   return
    if Input.is_action_just_pressed("quit"):  quitGame();    return
                
func continueGame():

    loadLevel(LEVEL)
                
func newGame():
    
    loadLevel(LEVEL, false)
        
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
    
    get_tree().quit()
        
func settingsMenu(backMenu:Menu):
    
    %SettingsMenu.backMenu = backMenu
    %MenuHandler.appear(%SettingsMenu)
    
func clearLevel():

    if currentLevel:
        currentLevel.free()

func loadLevel(levelRes, load = true):
    
    clearLevel()

    currentLevel = levelRes.instantiate()
    add_child(currentLevel)
    
    currentLevel.start()
    Post.startLevel.emit()
    
    if load:
        Saver.loadGame()

    Post.levelStart.emit()
    resumeGame()
