extends Node
## Holds all generic global variables
##
## @author: Bennett Moore 2024

## All possible damage types
enum DAMAGE_TYPES {NONE, BLUDGEONING, PIERCING, SLASHING, FIRE, EARTH, WATER, LIGHTNING, ARCANE, TRUE}

var drop_points: Dictionary ## Holds all drop point data, keyed by the node's hashed path data
