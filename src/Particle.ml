include Body;;

class particle x y =
	object (self)
		inherit body x y
		method draw =
			GlDraw.begins `points;
			GlDraw.vertex2 position;
			GlDraw.ends ()
	end;;
