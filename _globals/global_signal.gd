extends Node

signal player_ability_1()
signal player_ability_2()
signal player_ground_slam(instigator)
signal player_add_item(item)
signal player_remove_item(item)
signal player_hurt
signal player_stat_change
signal player_die(player: PlayerCharacter)
signal player_finished_dying

signal player_enter_interact_area(interactable)

signal character_hit(hit_object, attacker) #add le thing. uhhh ya
