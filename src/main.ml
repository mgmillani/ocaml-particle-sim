include Physics;;
include Particle;;

(* quantos milisegundos dura cada frame*)
let mili = 15

(*posicao inicial dos pontos*)
let dots = ref [new particle 0.5 (0.5) ; new particle 0.2 (0.3) ; new particle 0.4 (0.7)]

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

(*
	controla o passo entre um frame e outro
	move os pontos para baixo
*)
let rec timerF ~value =
	Physics.move !dots;
	Glut.timerFunc ~ms:mili ~cb:timerF ~value:1;
	Glut.postRedisplay ()

(*let idle () =*)

let _ =
	ignore (Glut.init Sys.argv);
	Glut.initDisplayMode ~double_buffer:true ();
	ignore (Glut.createWindow ~title:"Simparticle");

	Glut.displayFunc ~cb:display;
	(*Glut.idleFunc ~cb:(Some idle);*)
	Glut.timerFunc ~ms:mili ~cb:timerF ~value:1;
	Glut.mainLoop()