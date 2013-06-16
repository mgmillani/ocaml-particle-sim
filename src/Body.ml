class virtual body x y =
	object
		val mutable position = (x,y)
		val mutable velocity = (0.0,0.0)
		val mutable acceleration = (0.0,0.0)
		method getPosition = position
		method setPosition pos = position <- pos
		(* faz com que o corpo fique dentro dos limites *)
		method loopBound (x0,y0) (x1,y1) =
			let (px,py) = position in
			let bx = if px < x0 then x1 else if px > x1 then x0 else px in
			let by = if py < y0 then y1 else if py > y1 then y0 else py in
			position <- (bx,by)
		method getAcceleration = acceleration
		method setAcceleration acc = acceleration <- acc
		method applyAcceleration (x,y) =
			let (ax,ay) = acceleration in
			acceleration <- (ax +. x , ay +. y)
		method virtual draw : unit
		method virtual getValue : float
		(* aplica a aceleracao e a velocidade *)
		method move =
			let (px,py) = position in
			let (vx,vy) = velocity in
			let (ax,ay) = acceleration in
			position <- (px +. vx,py +. vy);
			velocity <- (vx +. ax,vy +. ay);
			acceleration <- (0.0,0.0)
	end;;

type bodyData =
	| Electric of float*float*float
	| Massive of float*float*float;;