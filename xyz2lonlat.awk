#
# reads x y z ...
#
# writes lon lat R ...
#
BEGIN{

  twopi = 6.28318530717958647;
  f = 360.0/twopi;
}
{
  # check for GMT -M files
  if($1==">")
      print($1);
  else
      if((substr($1,1,1)!="#") && (NF>=3)){
	  x=$1;
	  y=$2;
	  z=$3;
	  
	  tmp1 = x*x + y*y;
	  tmp2=tmp1 + z*z;
	  if(tmp2 > 0.0)
	      r=sqrt(tmp2);
	  else
	      r=0.0;
	  theta=atan2(sqrt(tmp1),z);
	  phi=atan2(y,x);

	  #if(phi < 0)
	  #    phi += twopi;
	  #if(phi >= twopi)
	  #    phi -= twopi;
	  
	  printf("%20.16f %20.16f %20.16e ",phi*f,90.-theta*f,r);
	  for(i=4;i<=NF;i++)
	      printf("%s ",$i);
	  printf("\n");
      }
}
END{
}
