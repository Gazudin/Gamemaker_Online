///scr_draw_border_text(x, y, text, color, border, thickness, alpha)

var pos_x = argument0
var pos_y = argument1
var text = argument2
var color = argument3
var border = argument4
var thickness = argument5
var alpha = argument6

// draw shadow
draw_text_colour(pos_x+thickness, pos_y, text, border, border, border, border, alpha)
draw_text_colour(pos_x-thickness, pos_y, text, border, border, border, border, alpha)
draw_text_colour(pos_x, pos_y+thickness, text, border, border, border, border, alpha)
draw_text_colour(pos_x, pos_y-thickness, text, border, border, border, border, alpha)

// draw inner
draw_text_colour(pos_x, pos_y, text, color, color, color, color, alpha)

