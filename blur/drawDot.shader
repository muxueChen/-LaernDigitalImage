{
	    "type": "text",
	    "category": "15",
	    "text": "Discover \ntrue beauty",
	    "rotation": "0.00",
	    "loop_mode": "1",
	    "remain_duration": 1500,
	    "view_x_gravity": "Center",
	    "view_y_gravity": "Center",
	    "view_width": "wrap",
	    "view_height": "wrap",
	    "text_font": "Jura-Regular",
	    "text_gravity": "Center",
	    "text_size": "0.08",
	    "first_color": "000000",
	    "second_color": "",
	    "padding": "0",
	    "outline_width": "0",
	    "paint_style": "",
	    "shadow_offset": "0",
	    "line_height_multiple": "1",
	    "kerning_bonus": "0",
	    "background_line_color": "ffffff",
	    "background_margin_top": "0.1",
	    "background_margin_bottom": "0.1",
	    "background_margin_left": "0.45",
	    "background_margin_right": "0.45",
	    "default_alpha": 0,
	    "in_animators": {
		"background_animators":[
			{
				"interpolator":{
					"type":"slowInExpOut"
				},
				"from":0,
				"reverse":0,
				"duration":500,
				"type":"scale_x",
				"direction":"LEFT_TO_RIGHT",
				"to":1
			}
		],
		"line_delay":333,
		"word_delay":200,
		"word_animators":[
			{
				"from":1,
				"reverse":0,
				"duration":3000,
				"type":"translate_y",
				"to":-1,
				"interpolator":{
					"type":"slowInExpOut"
				}
			},
			{
				"from":0,
				"reverse":0,
				"duration":30,
				"type":"fade",
				"to":1
			}
		],
		"line_animators":[
			{
				"interpolator":{
					"type":"slowInExpOut"
				},
				"reverse":0,
				"duration":0,
				"type":"clip",
				"direction":"NONE"
			}
		],
		"alphabet_delay":0,
		"background_delay":0,
		"shuffle_chars_delays":0
	},
	    "out_animators": {
		"background_animators":[
			{
				"from":1,
				"reverse":0,
				"duration":33,
				"type":"fade",
				"to":0
			}
		],
		"line_delay":0,
		"word_delay":30,
		"word_animators":[
			{
				"from":1,
				"reverse":0,
				"duration":300,
				"type":"fade",
				"to":0
			}
		],
		"alphabet_delay":0,
		"background_delay":0,
		"shuffle_chars_delays":0
	}
}