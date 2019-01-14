extends Node

# Load
# var lib = load("res://path/to/this/script").new()

# var state = lib.init(Node2D)

# state.change(stateName, args=[]) # returns true/false. Success or not
# state.current() # returns current state node
# state.process(delta) # Update state

# ### How to create states ###
# 1. Create 'states' Node Object inside your player node
# 2. Add there inside another one node with state name, for example: 'move'
# 3. Write boilerplate code, like this:
#	extends Node
#
#	func start(player, args):
#		pass
#	func stop(player):
#		pass
#	func process(player, delta):
#		pass

func init(obj):
	if obj.has_node("mstate"):
		print("MState: This node already has MState!")
	var node = StateNode.new(obj)
	obj.add_child(obj)
	return node

# --- STATE NODE ---

class StateNode extends Node:
	var obj
	var state
	
	func _init(_obj):
		self.obj = _obj
		self.name = "mstate"
		
	func _find_state(name):
		if !obj.has_node("states"):
			print("MState: please, create 'states' inside your node!")
			return null
		var states_node = obj.get_node("states")
		if !states_node.has_node(name):
			print("MState: no such 'states/" + name + "' state in node!")
			return null
		return states_node.get_node(name)
	
	func change(name: String, args=[]):
		if !name: return false
		var state_node = _find_state(name)
		if !state_node: return false
		var prev_state = state
		state = state_node
		if prev_state and prev_state.has_method('stop'):
			prev_state.call("stop", obj)
		if state.has_method("start"):
			state.call("start", obj, args)
		return true
	
	func current():
		return state
	
	func process(delta):
		if !state: return
		if state.has_method("process"):
			state.process(obj, delta)
		else:
			print("MState: no process method in state node!")