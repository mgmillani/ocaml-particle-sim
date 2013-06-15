open Particle;;
open Loader;;

(* quantos milisegundos dura cada frame*)
let mili = 15

let minx = ~-. 0.5
let miny = ~-. 0.5
let maxx = 0.5
let maxy = 0.5

(*posicao inicial dos pontos*)
(*let dots = ref [new electric 0.4 0.7 ~-. 0.0003 ; new electric minx miny 0.0005 ; new electric maxx miny 0.0009 ; new electric maxx maxy ~-. 0.0001 ; new electric minx maxy ~-. 0.0007 ; new electric 0.5 0.5 0.0002 ]*)

let dots = ref [new electric 0.4 0.7 ~-. 0.0003 ; new electric 0.5 0.2 0.0005]

(*
	desenha cada ponto em sua posicao
*)
let rec drawDots points = match points with
  | h::r -> h#draw;
						drawDots r;
	| [] -> ()

(*
	atualiza o desenho
*)
let display dots ()=
	GlClear.color (0.0, 0.0, 0.0);
	GlClear.clear [ `color ];
	drawDots !dots;
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
				dots := ( new electric px py 0.004 ) :: !dots
			else
				dots := ( new electric px py ~-. 0.0004 ) :: !dots
		; ()

(*let idle () =*)

let _ =

	dots := Loader.loadConfig "config" readParticleCategory;
	Printf.printf "Number of particles: %d\n" (List.length !dots);

	ignore (Glut.init Sys.argv);
	Glut.initDisplayMode ~double_buffer:true ();
	ignore (Glut.createWindow ~title:"Simparticle");

	Glut.displayFunc ~cb:(display dots);
	Glut.reshapeFunc ~cb:reshape;
	Glut.mouseFunc ~cb:mouseHandler;
	(*Glut.idleFunc ~cb:(Some idle);*)
	Glut.timerFunc ~ms:mili ~cb:timerF ~value:1;
	Glut.mainLoop()
