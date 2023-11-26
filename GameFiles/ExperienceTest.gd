extends Label


func update_text(level, experience, experience_required):
	text = """Level: %s
			Experience: %s
			Next Level: %s
			""" % [level, experience, experience_required]
