extends Node

func show_multiplier(var win_multi, duration : float):
	$multiplier_text.set_visible(true)
	$multiplier_text.set_text("x" + str(win_multi))
	
	$CPUParticles2D.set_lifetime(duration)
	$CPUParticles2D.set_emitting(true)
	while $CPUParticles2D.is_emitting():
		yield(get_tree(),"idle_frame")
	
	$multiplier_text.set_visible(false)

