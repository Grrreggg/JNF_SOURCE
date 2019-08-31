extends Node

var controllers = []

func _ready():
	self.set_pause_mode(PAUSE_MODE_PROCESS)
	set_process(true)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index('Music'), 0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index('Sound'), -7)
	
func mute_music(arg = true):
	var volume = -500 if arg else 0
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index('Music'), volume)	
		
func stop_all_sounds():
	for controller in controllers:
		if controller.player and !controller.song:
			controller.loop = false
			controller.player.stop()

func get_controller(sound):
	for controller in controllers:
		if controller.player:
			if controller.player.stream == sound:
				return controller

func play_random_sound(sounds_array):
	for sound in sounds_array:
		stop_sound(sound)
		
	var rnd = randi()%sounds_array.size()+0
	play_sound(sounds_array[rnd])

func play_sound(sound, loop = false, song = false):
	var controller = get_controller(sound)
	if controller:
		controller.player.play()
	else:
		controller = AudioStreamPlayer.new()
		add_child(controller)
		controller.stream = sound
		controller.bus = "Music" if song else 'Sound'
		controller.stream.loop = false
		controller.connect('finished', self, 'on_finished', [sound])
		controller.play()
		
		var controller_dict = {
			'player':controller,
			'loop':loop,
			'song':song
		}
		controllers.append(controller_dict)

func stop_sound(sound):
	var controller = get_controller(sound)
	if controller:
		controller.loop = false
		controller.player.stop()

func is_playing(sound):
	var controller = get_controller(sound)
	if controller:
		return controller.player.playing
		
func on_finished(sound):
	var controller = get_controller(sound)
	if controller and controller.loop:
		controller.player.play()
	