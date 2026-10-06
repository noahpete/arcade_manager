extends Node

## UI
signal attraction_menu_toggle_requested()
signal attraction_menu_open_requested()
signal attraction_menu_close_requested()
signal attraction_menu_option_selected(data: AttractionData)

# Layout Mode
signal attraction_place_requeseted(data: AttractionData, cell: Vector2i)
signal attraction_placed()
