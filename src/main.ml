open Particle;;
open Loader;;
open Quadtree;;

(* quantos milisegundos dura cada frame*)
let mili = 15

(*
	desenha cada ponto em sua posicao
*)
let rec drawBodies points = match points with
  | h::r -> h#draw;
						drawBodies r;
	| [] -> ()

let rec convertToBody lst = match lst with
	| h::r -> (h :> Body.body)::(convertToBody r)
	| [] -> []

(*
	atualiza o desenho
*)
let display dots circles drawTree ()=
	GlClear.color (0.0, 0.0, 0.0);
	GlClear.clear [ `color ];
	drawBodies (List.append (convertToBody !dots)
		(convertToBody !circles));
	if !drawTree then
		let dTree = Quadtree.buildQuadtree !dots in
		let cTree = Quadtree.buildQuadtree !circles in
		Quadtree.draw dTree;
		Quadtree.draw cTree;
	else
		();
	Glut.swapBuffers ()

let reshape ~w ~h =
  GlDraw.viewport 0 0 w h

(*
	controla o passo entre um frame e outro
	move os pontos para baixo
*)
let rec timerF mili dots ~value =
	Physics.move !dots;
	Physics.simulateElectricNaive !dots;
	Glut.timerFunc ~ms:mili ~cb:(timerF mili dots) ~value:1;
	Glut.postRedisplay ()

let mouseHandler dots ~button ~state ~x ~y =
	let width = float_of_int (Glut.get(Glut.WINDOW_WIDTH)) in
		let height = float_of_int (Glut.get(Glut.WINDOW_HEIGHT)) in
		let rx = (float_of_int x) /. width in
		let ry = (float_of_int y) /. height in
		let px = rx *. 2.0 -. 1.0 in
		let py = ry *. ~-. 2.0 +. 1.0 in
		if state = Glut.DOWN then
			if button = Glut.LEFT_BUTTON then
				dots := ( new electric px py 0.0004 ) :: !dots
			else
				dots := ( new electric px py ~-. 0.0004 ) :: !dots
		; ()

let keyhandler drawTree ~key ~(x : int) ~(y : int) =
	if key = (int_of_char 'd') then
		drawTree := not !drawTree
	else ()

(*let idle () =*)

let _ =

	let dots = ref [] in
	let circles = ref [] in
	let drawTree = ref true in
	let (elec,massive) =  Loader.loadBodies "config" in
	dots := elec;
	circles := massive;

	ignore (Glut.init Sys.argv);
	Glut.initDisplayMode ~double_buffer:true ();
	ignore (Glut.createWindow ~title:"Simparticle");

	Glut.displayFunc ~cb:(display dots circles drawTree);
	Glut.reshapeFunc ~cb:reshape;
	Glut.mouseFunc ~cb:(mouseHandler dots);
	Glut.keyboardFunc ~cb:(keyhandler drawTree);
	(*Glut.idleFunc ~cb:(Some idle);*)
	Glut.timerFunc ~ms:mili ~cb:(timerF mili dots) ~value:1;
	Glut.mainLoop()
