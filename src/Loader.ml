open Particle;;

exception Invalid_format

let rec parseChannel chan readElement =
	try
		let el = readElement chan in
		el::(parseChannel chan readElement)
	with
		End_of_file -> []

let readLine chan =
	let rec readLineAux acc =
		let c =
			try
				input_char chan
			with
				End_of_file -> if String.length acc = 0 then raise End_of_file else '\n'
		in
		match c with
		 '\n' -> acc
		|'\r' -> acc
		| _ -> (readLineAux (acc ^ (String.make 1 c)) )
	in
		readLineAux ""

let readElectricCategory lst =
	let rec readAux lst =

	in
	let (x,y,charge) = readAux lst in
	fun => new particle x y charge


let readParticleCategory lst = match lst with
	 "electric"::rest -> readElectricCategory rest
	| _ -> raise Invalid_format

let parseList readCategory readElement lst =
	let rec parseListAux constructor readCategory readElement lst =
		match lst with
		[] -> []
		| _ ->
			try
				let (nextConstructor,rest) = readCategory lst in
				parseListAux nextConstructor readCategory readElement rest
			with
				Invalid_format ->
					let (el,rest) = readElement constructor lst in
					el :: (parseListAux constructor readCategory readElement rest)
	in
		let (nextConstructor,rest) = readCategory lst in
		parseListAux nextConstructor readCategory readElement rest

let loadConfig filename =
	let chan = open_in_bin filename in
	let lines = parseChannel chan readLine in
	(*parseList categoryFunc elementFunc characters*)
	List.iter (Printf.printf "%s\n") lines


