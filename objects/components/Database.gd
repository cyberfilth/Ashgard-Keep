extends Node

# Return an instance of a node in that database at 'path'
func spawn( path ):
	# Find our Thing before we try returning anything
	var thing = get_node( path )
	if thing:
		return thing.duplicate()
	# Print an error message if thing doesn't drop out
	print( "Cannot find an object at: " + path )