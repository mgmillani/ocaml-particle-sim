class virtual body:
	float ->
	float ->
	object
		val mutable position : float * float
		val mutable velocity : float * float
		val mutable acceleration : float * float
		method getAcceleration : float*float
		method setAcceleration : float*float-> unit
		method applyAcceleration : float*float -> unit
		method virtual draw : unit
		method move : unit
	end;;