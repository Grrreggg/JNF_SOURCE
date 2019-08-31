extends Node

func save_game(data):
    var save_game = File.new()
    save_game.open("res://savegame.save", File.WRITE)
    if save_game.file_exists("res://savegame.save"):
        pass
    save_game.store_var(data)
    save_game.close()
	
func load_game():
	var save_game = File.new()
	if not save_game.file_exists("res://savegame.save"):
		return # Error! We don't have a save to load.
		
	save_game.open("res://savegame.save", File.READ)
	var res = save_game.get_var()
	save_game.close()
	return res