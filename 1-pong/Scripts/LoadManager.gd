extends Node

# Signal that will be emitted when the loading progress changes
signal progress_changed(progress)

# Sinal that is emitted when the loading completes
signal load_done

# Path to the loading screen scene
const _loadScreenPath = "res://Scenes/Menus/LoadingScreen.tscn"

# Variable to store the loading screen instance
var  _loadScreen = load(_loadScreenPath)

# Variable to handle the loaded resource files
var _loadedResource: PackedScene

# Variable to store the link of what needs to be loaded
var _scenePath: String

# Variable to store the loading progress
var _progress: Array = []

# Variable indicating whether the loading should use multiple processor cores
# using multiple cores can speed up the loading process, might be less compatible on some plataforms
var useSubThreads: bool = false

# Function to load the scene
# This function initializaes the loading process by instantiating the loading screen and connecting signals
func LoadScene(scenePath: String) -> void:
	_scenePath = scenePath
	
	# Instantiate the loading screen add it to the scene tree
	var newLoadingScreen = _loadScreen.instantiate()
	get_tree().get_root().add_child(newLoadingScreen)
	
	# Connect signals for updating the progress bar and and starting the outro animation
	self.progress_changed.connect(newLoadingScreen.UpdateProgressBar)
	self.load_done.connect(newLoadingScreen.StartOutroAnimation)
	
	# Wait until the loading screen has full coverage before starting the load
	await Signal(newLoadingScreen, "loading_screen_has_full_coverage")
	StartLoad()

# Function to process the loading status
# This function is called every frame to check the loading status and update progress.
func _process(delta: float) -> void:
	var loadStatus = ResourceLoader.load_threaded_get_status(_scenePath, _progress)
	
	match loadStatus:
		0, 2: # THREAD_LOAD_INVALID_RESOURCE, THREAD_LOAD_FAILED
			set_process(false)
			print("invalid")
			return
		1: # THREAD_LOAD_IN_PROGRESS
			emit_signal("progress_changed", _progress[0])
			print("Loading")
		3: # THREAD_LOAD_LOADED
			print("Loading completed")
			_loadedResource = ResourceLoader.load_threaded_get(_scenePath)
			emit_signal("progress_changed", 1.0)
			emit_signal("load_done")
			get_tree().change_scene_to_packed(_loadedResource)

# Function to start the loading process
# Request the resource to be loaded in a separate thread if enabled
func StartLoad() -> void:
	var state = ResourceLoader.load_threaded_request(_scenePath, "", useSubThreads)
	
	if state == OK:
		set_process(true)
