extends CanvasLayer

class_name Menu
## The abstract class for all menus
##
## Handles all boilerplate found across all menu types
## @author: Bennett Moore 2024

## Closes the menu
func close_menu():
	get_tree().paused = false
	hide()

## Opens the menu
func open_menu():
	get_tree().paused = true
	show()
