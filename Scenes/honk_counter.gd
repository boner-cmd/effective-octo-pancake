extends Node

var honk_total : int = 0

func add_honk() -> void: honk_total += 1


## get_honk_number() should only be used when preparing to store the total for save
## data. A getter is used here to avoid doing math or otherwise directly interacting
## with the honk number.
func get_honk_number() -> int : return honk_total


## get_honks() returns the string representation of honk_total.
func get_honks() -> String : return str(honk_total)
