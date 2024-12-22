extends Node2D

class_name TimeComponent

var time_start = 0
var time_now = 0
var start_timevar
var end_time
var elapsed_time
func _ready():
	pass


func start_time():
	time_start = Time.get_unix_time_from_system()
	#set_process(true)
	start_timevar = Time.get_unix_time_from_system() #captures the initial unix time
	await get_tree().create_timer(60).timeout #timer for 220 seconds (3.666666667 minutes)
	end_time = Time.get_unix_time_from_system() #captures the end time in unix time
	print(start_timevar) # just for testing
	print(end_time) # just for testing
	elapsed_time = (end_time - start_timevar) / 60 #this calculates the elapsed time in minutes - divisor will need to be adjusted if you want hours, days, etc.
	print(elapsed_time) # just for testing - this printed out as 3.66675816774368

func _process(delta):
	#start_time()
	pass
	#time_now = Time.get_unix_time_from_system()
	#print(Time.get_ticks_msec())
	#var elapsed = time_now - time_start
	#var minutes = elapsed / 60
	#var seconds = elapsed % 60
	#var str_elapsed = "%02d : %02d" % [minutes, seconds]
	#print("elapsed : ", str_elapsed)
