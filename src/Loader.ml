open Body;;
open Massive;;
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
				End_of_file ->
					if String.length acc = 0 then
						raise End_of_file
					else '\n'
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
		|"x"::"="::value::rest -> readAux (fun k -> float_of_string value) y charge rest
		|"y"::"="::value::rest -> readAux x (fun k -> float_of_string value) charge rest
		|"charge"::"="::value::rest -> readAux x y (fun k -> float_of_string value) rest
		|"end"::r -> (Electric ((x 0),(y 0),(charge 0)) , r)
		| _ -> (Electric ((x 0),(y 0),(charge 0)) , lst)
	in
		let none = (fun x -> raise Invalid_format) in
		readAux none none none lst

let readMassiveParticle lst =
	let rec readAux x y mass lst = match lst with
		|"x"::"="::value::rest -> readAux (fun k -> float_of_string value) y mass rest
		|"y"::"="::value::rest -> readAux x (fun k -> float_of_string value) mass rest
		|"mass"::"="::value::rest -> readAux x y (fun k -> float_of_string value) rest
		|"end"::r -> (Massive ((x 0),(y 0),(mass 0)) , r)
		| _ -> (Massive ((x 0),(y 0),(mass 0)) , lst)
	in
		let none = (fun x -> raise Invalid_format) in
		readAux none none none lst

let readBodyCategory lst = match lst with
	| "electric"::rest -> (readElectricParticle,rest)
	| "massive"::rest -> (readMassiveParticle,rest)
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

let constructBodies lst =
	let rec constructAux lst elec massive = match lst with
		| Electric (x,y,charge)::rest -> constructAux rest ((new electric x y charge)::elec) massive
		| Massive (x,y,mass)::rest -> constructAux rest elec ((new massive x y mass)::massive)
		| _ -> (elec,massive)
	in
		constructAux lst [] []

let rec changeValue f lst = match lst with
	| Electric (x,y,charge)::rest -> (Electric (x,y,f charge))::(changeValue f rest)
	| Massive (x,y,mass)::rest -> (Massive (x,y,f mass))::(changeValue f rest)
	| _ -> []
		
let loadConfig filename categoryFunc =
	let chan = open_in_bin filename in
	let lines = parseChannel chan readLine in
	parseList categoryFunc lines

let loadBodies filename =
	let data = loadConfig filename readBodyCategory in
	constructBodies (changeValue (fun x -> x*.1.1) data)


