#
# convert lon lat input to x y z output
# input:
#
# lon lat [ v1 v2 v3 ...]
#
# output:
#
# x y z [ v1 v2 v3 ...]
#
# $Id: lonlat2xyz.awk,v 1.3 2003/12/01 02:42:50 becker Exp twb $
#
BEGIN{
  if(R==0)
    R=1.0;
  f=0.017453292519943296;
}
{
  if((substr($1,1,1)!="#") && (NF>=2)){
      if((tolower($1)=="nan")||(tolower($2)=="nan")){
	  print("NaN NaN NaN");

      }else{
	  lambda=$2*f;
	  phi=$1*f;
	  
	  tmp=cos(lambda)*R;
	  
	  x=tmp * cos(phi);
	  y=tmp * sin(phi);
	  z=sin(lambda)*R;
	  
	  
	  printf("%20.16e %20.16e %20.16e ",x,y,z);
      }
      for(i=3;i<=NF;i++)
	  printf("%s ",$i);
      printf("\n");
  }
}
