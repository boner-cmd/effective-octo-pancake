extends Node
## TODO document honk counter

## getter should only be used when preparing to store the total for save data. A getter is used here
## to avoid doing math or otherwise directly interacting with the honk number.
var honk_total : int = 0 : 
	get : return honk_total

func add_honk() -> void: honk_total += 1


## get_honks_string() returns the string representation of honk_total.
func get_honks_string() -> String : return str(honk_total)
