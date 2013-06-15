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
		|' ' -> if String.length acc = 0 then readLineAux acc else acc
		|'\t' -> if String.length acc = 0 then readLineAux acc else acc
		| _ -> (readLineAux (acc ^ (String.make 1 c)) )
	in
		readLineAux ""

let readElectricParticle lst =
	let rec readAux x y charge lst = match lst with
		 "x"::"="::value::rest -> readAux (fun k -> float_of_string value) y charge rest
		|"y"::"="::value::rest -> readAux x (fun k -> float_of_string value) charge rest
		|"charge"::"="::value::rest -> readAux x y (fun k -> float_of_string value) rest
		| h::r -> (new electric (x 0) (y 0) (charge 0) , r)
		| _ -> (new electric (x 0) (y 0) (charge 0) , lst)
	in
		readAux (fun x -> raise Invalid_format) (fun x -> raise Invalid_format) (fun x -> raise Invalid_format) lst

let readParticleCategory lst = match lst with
	 "electric"::rest -> (readElectricParticle,rest)
	| _ -> raise Invalid_format

let parseList readCategory lst =
	let rec parseListAux readElement readCategory lst =
		match lst with
		[] -> []
		| _ ->
			try
				let (readElement2,rest) = readCategory lst in
				parseListAux readElement2 readCategory rest
			with
				Invalid_format ->
					try
						let (el,rest) = readElement lst in
						el :: (parseListAux readElement readCategory rest)
					with
						Invalid_format -> []
	in
		let (readElement2,rest) = readCategory lst in
		parseListAux readElement2 readCategory rest

let loadConfig filename categoryFunc =
	let chan = open_in_bin filename in
	let lines = parseChannel chan readLine in
	parseList categoryFunc lines


