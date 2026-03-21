extends Node

signal player_ability_1()
signal player_ability_2()
signal player_ground_slam(instigator)
signal player_add_item(player: PlayerCharacter, item)
signal player_remove_item(player: PlayerCharacter, item)
signal player_hurt(player: PlayerCharacter)
signal player_stat_change(player: PlayerCharacter)
signal player_die(player: PlayerCharacter)
signal player_finished_dying

signal player_enter_interact_area(interactable)

signal character_hit(hit_object, attacker) #add le thing. uhhh ya

signal portal_levels_chosen(levels: Array, level_names)
signal portal_interacted_with

signal save_game
signal load_animation
signal load_game
