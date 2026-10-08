extends Node

## UI
signal attraction_menu_toggle_requested()
signal attraction_menu_open_requested()
signal attraction_menu_close_requested()
signal attraction_menu_option_selected(data: AttractionData)

## Gameplay
signal zone_changed(new_zone: StringName, old_zone: StringName)
signal attraction_layout_finished()
