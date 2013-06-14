class virtual body:
	float ->
	float ->
	object
		val mutable position : float * float
		val mutable velocity : float * float
		val mutable acceleration : float * float
		method getPosition : float*float
		method setPosition : float*float -> unit
		method getAcceleration : float*float
		method loopBound : float*float -> float*float -> unit
		method setAcceleration : float*float-> unit
		method applyAcceleration : float*float -> unit
		method virtual draw : unit
		method move : unit
	end;;