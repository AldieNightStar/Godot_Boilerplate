extends Node

# Timeo Script
# Author: Ihor Fox

# Load
# var lib = load("res://path/to/this/script").new()

# API
# var timer = lib.once(sec, obj, method_name, args=[]) # Returns: Timer
# var timer = lib.repeat(sec, obj, method_name, args=[]) # Returns: Timer
#	timer.stop()
#	timer.queue_free()

# Call operation ONCE after some period
func once(sec, obj, method_name, args=[]):
	return _doTimer(sec, obj, method_name, false, args)
	
func repeat(sec, obj, method_name, args=[]):
	return _doTimer(sec, obj, method_name, true, args)

func _doTimer(sec, obj, method_name, repeat, args=[]):
	var t = Timer.new()
	t.set_one_shot(!repeat)
	t.set_wait_time(sec)
	
	obj.add_child(t)
	t.connect("timeout", obj, method_name, args)
	if !repeat: t.connect("timeout", self, "_end", [t])
	t.start()
	return t

func _end(t):
	t.queue_free()