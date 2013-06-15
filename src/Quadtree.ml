type 'a quadtree =
	| Empty
	| Leaf of 'a
	| Node of 'a quadtree * 'a quadtree * 'a quadtree * 'a quadtree;;

let comparePosition f particle =
	let (x,y) = particle#getPosition in
	f x y;;

(* Constrói uma quadtree a partir de particulas. Se houver mais de uma particula na lista *)
let buildQuadtree particles =
	let rec buildAux particles maxx maxy minx miny = match particles with
	| h::[] -> Leaf h
	| [] -> Empty
	| _ ->
		Printf.printf "Amount left: %d\n" (List.length particles) ;
		let w2 = (maxx -. minx)/. 2.0 in
		let h2 = (maxy -. miny)/. 2.0 in
		let wMinx = minx +. w2 in
		let nMiny = miny +. h2 in
		let eMaxx = maxx -. w2 in
		let sMaxy = maxy -. h2 in
		let nw = buildAux (List.filter (comparePosition (fun x y -> x>=wMinx && x<maxx && y< maxy && y>=nMiny)) particles) wMinx maxx	maxy nMiny in
		let sw = buildAux (List.filter (comparePosition (fun x y -> x>=wMinx && x<maxx && y< sMaxy && y>=miny)) particles) wMinx maxx	maxy nMiny in
		let ne = buildAux (List.filter (comparePosition (fun x y -> x>=minx && x<eMaxx && y< maxy && y>=nMiny)) particles) minx eMaxx	sMaxy miny in
		let se = buildAux (List.filter (comparePosition (fun x y -> x>=minx && x<eMaxx && y< sMaxy && y>=miny)) particles) minx eMaxx	sMaxy miny in
		Node (nw, sw, se, ne)
	in
		buildAux particles 1.0 1.0 (-1.0) (-1.0);;
