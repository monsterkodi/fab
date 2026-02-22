class_name MainMenu
extends Menu

signal playLevel

func onQuit():      if is_processing_input(): Post.quitGame.emit()
func onSettings():  if is_processing_input(): Post.settingsMenu.emit(self)
func onHelp():      if is_processing_input(): %HelpMenu.backMenu = self; %MenuHandler.appear(%HelpMenu)
func onCredits():   if is_processing_input(): %MenuHandler.appear(%CreditsMenu)
func onContinue():  if is_processing_input(): Post.continueGame.emit()

func onNewGame():   
    
    if is_processing_input(): 
        Post.newGame.emit()

var lastFocused = null

func _ready():
    
    Log.log("MainMenu ready")
    if Saver.getSaveGame():
        %Buttons.get_node("Continue").visible = true
        #%Buttons.get_node("Save Game").visible = true
        #%Buttons.get_node("Load Game").visible = true
    
    Post.subscribe(self)
    
    Utils.wrapFocusVertical(%Buttons)
    %Buttons.get_child(0).grab_focus()
    
    super._ready()
    
func levelSaved(levelName):
    
    Log.log("mainMenu.levelSaved", levelName)

func back(): 
    
    if %Quit.has_focus():
        Post.quitGame.emit()
    else:
        %Quit.grab_focus()
    
func appear():

    %Buttons.get_child(0).grab_focus()
    super.appear()

func appeared():
    
    super.appeared()
    
func vanish():
    
    lastFocused = Utils.focusedChild(self)
    super.vanish()




    
