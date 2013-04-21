(* move cada ponto para baixo, fazendo um loop na tela *)
let move dots = List.map (fun (x,y) -> if y > -1. then (x , y -. 0.02 ) else (x,1.)) dots;;