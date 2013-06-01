class virtual body:
	float ->
	float ->
	object
		val mutable position : float * float
		val mutable velocity : float * float
		val mutable acceleration : float * float
		method getAcceleration : float
		method setAcceleration : float->unit
		method virtual draw : unit
		method move : unit
	end;;