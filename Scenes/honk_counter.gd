extends Node
## TODO document honk counter

var honk_total : int = 0

func add_honk() -> void: honk_total += 1


## get_honks_string() returns the string representation of honk_total.
func get_honks_string() -> String : return str(honk_total)
