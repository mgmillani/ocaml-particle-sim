(* chama o metodo move de cada ponto *)
let rec move dots = match dots with
	| h::r -> h#move;
						move r;
	| [] -> ()
