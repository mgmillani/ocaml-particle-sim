include Body;;

class particle x y =
	object (self)
		inherit body x y
		method draw =
			GlDraw.begins `points;
			GlDraw.vertex2 position;
			GlDraw.ends ()
	end;;

class electric x y charge_init =
	let coulombConst = 8.9875517873681764 in
	object (self)
		inherit particle x y
		val charge = charge_init
		method getCharge = charge
		method getForce (otherParticle : electric) =
			(* vetor desta particula a outra *)
			let (x0,y0) = self#getPosition in
			let (x1,y1) = otherParticle#getPosition in
			let (fx,fy) = (x1 -. x0 , y1 -. y0) in
			let sqrDistance = fx *. fx +. fy *. fy in
			let distance = sqrt sqrDistance in
			(* vetor unitario desta particula a outra *)
			let (ux,uy) = (fx /. distance , fy /. distance) in
			let force = coulombConst *. charge *. otherParticle#getCharge /. sqrDistance in
			if sqrDistance < 0.000001 then (0.0,0.0) else
				(* a força é multiplicada por -1 pois deve ser de repulsão quando as cargas tiverem o mesmo sinal (ou seja, quando for positiva) *)
				(ux *. ~-. force , uy *. ~-. force)
	end;;