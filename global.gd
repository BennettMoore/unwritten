extends Node
## Holds all generic global variables
##
## @author: Bennett Moore 2024

## All possible damage types
enum DAMAGE_TYPES {NONE, BLUDGEONING, PIERCING, SLASHING, FIRE, EARTH, WATER, LIGHTNING, ARCANE, TRUE}
const SHOW_GHOSTS = false ## Whether "ghost" rooms (AKA invalid room placements) should be visible to the player

var drop_points: Dictionary ## Holds all drop point data, keyed by the node's hashed path data
