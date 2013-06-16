open Body;;

let twoPi = 8.0 *. atan 1.0;;

let drawCircle x y precision radius =
	let step = twoPi /. (float_of_int precision) in
	let rec drawAux index = match index with
		|	0 -> ()
		| _ ->
			let fi = float_of_int index in
			GlDraw.vertex2 (x +. radius *. sin (fi *. step) , y +. radius *. cos (fi *. step));
			drawAux (index - 1)
	in
		drawAux precision

class massive x y mass_init =
	let gravitationConst = 6.67384 in
	object (self)
		inherit body x y
		val mutable mass = mass_init
		val mutable objectColor = (0.3, 0.7, 0.8)
		val precision = 32
		method getValue = mass
		method draw =
			GlDraw.begins `line_loop;
			GlDraw.color objectColor;
			let (x,y) = position in
			drawCircle x y precision (mass *. 10.0);
			GlDraw.ends ()
		method getForce pos1 mass1 =
			let (x0,y0) = position in
			let (x1,y1) = pos1 in
			let (fx,fy) = (x0 -. x1 , y0 -. y1) in
			let sqrDistance = fx *. fx +. fy*.fy in
			let distance = sqrt sqrDistance in
			let f = gravitationConst *. mass *. mass1 /. sqrDistance in
			(* vetor unitario deste corpo ao outro *)
			let (ux,uy) = (fx /. distance , fy/. distance) in
			(ux *. f, uy *. f)
		method applyForce f =
			let (fx,fy) = f in
			(*F = ma*)
			(*a = F/m*)
			self#applyAcceleration (fx /. mass, fy /. mass)
	end;;