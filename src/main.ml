open Particle;;

(* quantos milisegundos dura cada frame*)
let mili = 15

let minx = ~-. 0.5
let miny = ~-. 0.5
let maxx = 0.5
let maxy = 0.5

let width = ref 1 and height = ref 1

(*posicao inicial dos pontos*)
let dots = ref [new electric 0.5 0.5 0.0002 ; new electric 0.4 0.7 ~-. 0.0003 ; new electric minx miny 0.0005 ; new electric maxx miny 0.0009 ; new electric maxx maxy ~-. 0.001 ; new electric minx maxy ~-. 0.0007]

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
let display ()=
	GlClear.clear [ `color ];
	drawDots !dots;
	Glut.swapBuffers ()

let reshape ~w ~h =
  width := max 1 w;
  height := max 1 h;
  GlDraw.viewport 0 0 w h
	
(*
	controla o passo entre um frame e outro
	move os pontos para baixo
*)
let rec timerF ~value =
	Physics.move !dots;
	dots := Physics.simulateElectricNaive !dots;
	Glut.timerFunc ~ms:mili ~cb:timerF ~value:1;
	Glut.postRedisplay ()

(*let idle () =*)

let _ =
	ignore (Glut.init Sys.argv);	
	Glut.initDisplayMode ~double_buffer:true ();
	ignore (Glut.createWindow ~title:"Simparticle");
	
	Glut.displayFunc ~cb:display;
	Glut.reshapeFunc ~cb:reshape;
	(*Glut.idleFunc ~cb:(Some idle);*)
	Glut.timerFunc ~ms:mili ~cb:timerF ~value:1;
	Glut.mainLoop()