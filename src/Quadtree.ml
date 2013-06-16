type 'a quadtree =
	| Empty
	| Leaf of float*(float*float)*'a
	| Node of float*(float*float)*('a quadtree * 'a quadtree * 'a quadtree * 'a quadtree);;

let testPosition f particle =
	let (x,y) = particle#getPosition in
	f x y;;

let treeCenter a b c d =
	let rec avgAux lst amount accx accy = match lst with
		| Empty::rest -> avgAux rest amount accx accy
		| Leaf(_,(x,y),_)::rest -> avgAux rest (amount + 1) (accx +. x) (accy +. y)
		| Node(_,(x,y),_)::rest -> avgAux rest (amount + 1) (accx +. x) (accy +. y)
		| _ -> (accx /. (float_of_int amount), accy /. (float_of_int amount))
	in
	avgAux (a::b::c::[d]) 0 0.0 0.0

let valueAverage a b c d =
	let rec avgAux lst amount acc = match lst with
		| Empty::rest -> avgAux rest amount acc
		| Leaf(v,_,_)::rest -> avgAux rest (amount + 1) (acc +. v)
		| Node(v,_,_)::rest -> avgAux rest (amount + 1) (acc +. v)
		| _ -> acc /. (float_of_int amount)
	in
	avgAux (a::b::c::[d]) 0 0.0

(* Constrói uma quadtree a partir de corpos *)
let buildQuadtree particles =
	let rec buildAux particles maxx maxy minx miny = match particles with
	| h::[] -> Leaf (h#getValue,h#getPosition,h)
	| [] -> Empty
	| _ ->
		let midx = (maxx +. minx)/. 2.0 in
		let midy = (maxy +. miny)/. 2.0 in
		let quadrant = fun right up left down x y -> x >= left && x<right && y<up && y>=down in
		let nwlist = (List.filter (testPosition (quadrant maxx maxy midx midy)) particles) in
		let swlist = (List.filter (testPosition (quadrant maxx midy midx miny)) particles) in
		let nelist = (List.filter (testPosition (quadrant midx maxy minx midy)) particles) in
		let selist = (List.filter (testPosition (quadrant midx midy minx miny)) particles) in
		let nw = buildAux nwlist maxx maxy midx midy in
		let sw = buildAux swlist maxx midy midx miny in
		let ne = buildAux nelist midx maxy minx midy in
		let se = buildAux selist midx midy minx miny in
		Node ((valueAverage nw sw se ne),(treeCenter nw sw se ne),(nw, sw, se, ne))
	in
		let result = buildAux particles 1.0 1.0 (-1.0) (-1.0) in
		result;;

let draw tree =
	let rec drawAux tree min max = match tree with
		| Empty ->
			let (x0,y0) = min in
			let (x1,y1) = max in
			GlDraw.begins `line_loop;
			GlDraw.color (0.0,0.2,0.8);
			GlDraw.vertex2 (x0+.0.01,y0+.0.01);
			GlDraw.vertex2 (x0+.0.01,y1-.0.01);
			GlDraw.vertex2 (x1-.0.01,y1-.0.01);
			GlDraw.vertex2 (x1-.0.01,y0+.0.01);
			GlDraw.ends ()

		| Leaf(_,(px,py),_) ->
			let (x0,y0) = min in
			let (x1,y1) = max in
			GlDraw.begins `line_loop;
			GlDraw.color (0.0,8.0,0.2);
			GlDraw.vertex2 (x0+.0.01,y0+.0.01);
			GlDraw.vertex2 (x0+.0.01,y1-.0.01);
			GlDraw.vertex2 (x1-.0.01,y1-.0.01);
			GlDraw.vertex2 (x1-.0.01,y0+.0.01);
			GlDraw.ends ()

		| Node(_,_,(nw,sw,se,ne)) ->
			let (x0,y0) = min in
			let (x1,y1) = max in
			let (xmid,ymid) = ((x0 +. x1)/.2.0 , (y0 +. y1)/.2.0) in
			drawAux nw (xmid,ymid) (x1,y1);
			drawAux sw (xmid,y0) (x1,ymid);
			drawAux ne (x0,ymid) (xmid,y1);
			drawAux se (x0,y0) (xmid,ymid)

	in
		drawAux tree (-1.0, -1.0) (1.0,1.0)



