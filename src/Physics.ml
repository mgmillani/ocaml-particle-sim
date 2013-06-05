open Particle;;

(* chama o metodo move e loopBound de cada ponto *)
let rec move dots = match dots with
	| h::r -> h#move;
						h#loopBound (~-. 1.0 , ~-. 1.0) (1.0 , 1.0);
						move r;
	| [] -> ()

let rec electricForce (h : electric) dots = match dots with
	| front::back ->
			let (fx,fy) = h#getForce front in
			h#applyAcceleration (fx,fy);
			front#applyAcceleration (~-. fx, ~-. fy);
			electricForce h back
	| [] -> ()

let rec simulateElectricNaive dots = match dots with
	| h::r ->
		electricForce h r;
		simulateElectricNaive r
	| [] -> ()

