extends Node

#region Overworld
signal move_to_area(area_id : String, resource : String, direction : String)

func bc_move_to_area(area_id : String, resource : String, direction : String):
	move_to_area.emit(area_id, resource, direction)
#endregion


#region Battle
signal ready_to_move(character: BattleCharacter)
signal action_over
#endregion
