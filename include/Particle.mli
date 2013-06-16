class particle:
	float ->
	float ->
	object
		method draw : unit
	end;;

class electric :
	float ->
	float ->
	float ->
	object
		val mutable acceleration : float * float
		val charge : float
		val mutable position : float * float
		val mutable velocity : float * float
		method getAcceleration : float * float
		method getCharge : float
		method discharge : unit
		method getForce :
			< getCharge : float; getPosition : float * float; .. > ->
			float * float
		method getPosition : float * float
		method move : unit
		method setAcceleration : float * float -> unit
		method setPosition : float * float -> unit
		method getForce : < getCharge : float; getPosition : float * float; .. > -> float * float
	end;;

