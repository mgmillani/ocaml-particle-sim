open Particle;;
open Loader;;
open Quadtree;;

(* quantos milisegundos dura cada frame*)
let mili = 15

let minx = ~-. 0.5
let miny = ~-. 0.5
let maxx = 0.5
let maxy = 0.5

let dots = ref []
let circles = ref []

let drawTree = ref false;;

(*
	desenha cada ponto em sua posicao
*)
let rec drawBodies points = match points with
  | h::r -> h#draw;
						drawBodies r;
	| [] -> ()

(*
	atualiza o desenho
*)
let display dots circles ()=
	GlClear.color (0.0, 0.0, 0.0);
	GlClear.clear [ `color ];
	drawBodies !dots;
	drawBodies !circles;
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
let rec timerF ~value =
	Physics.move !dots;
	Physics.simulateElectricNaive !dots;
	Glut.timerFunc ~ms:mili ~cb:timerF ~value:1;
	Glut.postRedisplay ()

let mouseHandler ~button ~state ~x ~y =
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
let keyhandler ~key ~(x : int) ~(y : int) =
	if key = (int_of_char 'd') then
		drawTree := not !drawTree
	else ()

(*let idle () =*)

let _ =

	let (elec,massive) =  Loader.loadBodies "config" in
	dots := elec;
	circles := massive;

	ignore (Glut.init Sys.argv);
	Glut.initDisplayMode ~double_buffer:true ();
	ignore (Glut.createWindow ~title:"Simparticle");

	Glut.displayFunc ~cb:(display dots circles);
	Glut.reshapeFunc ~cb:reshape;
	Glut.mouseFunc ~cb:mouseHandler;
	Glut.keyboardFunc ~cb:keyhandler;
	(*Glut.idleFunc ~cb:(Some idle);*)
	Glut.timerFunc ~ms:mili ~cb:timerF ~value:1;
	Glut.mainLoop()
