extends Node

# -------------------- DECLARE VARIABLES --------------------

var score : int = 0

# --------------------  DECLARE SIGNALS  --------------------

# Description of what each signal does WHEN emitted:

# When the alien group moves right or left
signal alien_group_moved()

# The aliens go out of bounds on the left or right
signal alien_group_exited_side_edge(edge)

# An alien is killed by the player
signal alien_killed()

# The game is finished
signal game_over()

signal wave_state_changed()
signal wave_cleared()

signal projectile_alien_landed()

signal player_died()
signal disable_player_reviving()
signal player_eliminated()
# --------------------   RUN THE CODE    --------------------

# -------------------- DECLARE FUNCTIONS --------------------
