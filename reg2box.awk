#
# given w e s n input, make a box
#
BEGIN{
    if((z1=="") && (z2=="")){
	z1=0;z2=0;dz=1;
    }else if(z2==""){
	z1=0;z2=z1;dz=1;
    }else if(z1==""){
	z1=0;z2=z2;dz=1;
    }else{
	dz = z2-z1;
	if(dz==0)
	    dz=1;
    }
    
    nx = 50;			# subdivisions
    
    r1 = 1-z1/6371;
    r2 = 1-z2/6371;
    n=0;
    ccw=0;			# counter clockwise ?
    if(divide=="")
	divide=0;			# add ">"
}
{
    if((substr($1,1,1)!="")&&(NF>=4)&&(n==0)){

	
	dx=($2-$1)/nx;
	dy=($4-$3)/nx;

	n++;
	for(z=z1;z <= z2;z += dz){
	    r = 1-z/6371;
	    if(ccw){
		# lower
		for(x=$1;x<=$2;x+=dx)
		    print(x,$3,r);
		if(divide)print(">");
		# right
		for(y=$3;y<=$4;y+=dy)
		    print($2,y,r);
		if(divide)print(">");
		# upper
		for(x=$2;x>=$1;x-=dx)
		    print(x,$4,r);
		if(divide)print(">");
		# left
		for(y=$4;y>=$3;y-=dy)
		    print($1,y,r);
		if(divide)print(">");
		
	    }else{		# clockwise
		# left
		for(y=$3;y<=$4;y+=dy)
		    print($1,y,r);
		if(divide)print(">");
		# upper
		for(x=$1;x<=$2;x+=dx)
		    print(x,$4,r);
		if(divide)print(">");
		
		# right
		for(y=$4;y>=$3;y-=dy)
		    print($2,y,r);
		if(divide)print(">");

		# lower
		for(x=$2;x>=$1;x-=dx)
		    print(x,$3,r);
		if(divide)print(">");
		
	    }
	}
	# box sides
	print($1,$3,r1);  print($1,$3,r2);print(">");
	print($1,$4,r1);  print($1,$4,r2);print(">");
	print($2,$3,r1);  print($2,$3,r2);print(">");
	print($2,$4,r1);  print($2,$4,r2);print(">");
    }


}
