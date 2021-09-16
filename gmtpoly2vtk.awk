#
# convert a GMT  polygon file to VTK polygon format, GMT file
# needs to close with a ">"
#
# assumes inpput is in
# 
# lon lat 
#
# format, which will convert geographic coordinates to  Cartesian at unity radius
#
# alternatively, if 
#
# lon lat r 
#
# are given, will use the specified radius
#
# if no_proj=1, will use lon-lat-0 as coordinates
#
# USAGE EXAMPLE:
#
# pscoast -Dc -A50000 -Rg -W1 -m | gawk -f ~/awk/gmtpoly2vtk.awk > coast.vtk
# 
# will create a coastline VTK file
#
#
# Thorsten Becker, UT Austin
# thorstinski@gmail.com
#
# $Id: gmtpoly2vtk.awk,v 1.2 2008/10/16 15:51:22 becker Exp becker $
#

BEGIN{
  # counters
  nsc=0;
  nsi=0;
  np=0;
  R = 1;
  # constants
  f=0.017453292519943296;
  # 
  use_attribute=0
}
{
  if(substr($1,1)!="#"){
    if($1 == ">"){
# segment end/start sign
      if(np-nlast > 0){
	nsi++;			# nodename counter
	ns[nsi] = -nseg;

	nsc++;			# polygon counter

	ilim = nsi+1+nseg;	# limit for loop

	for(i=nsi+1;i<=ilim;i++)
	  ns[i] = i-1-nsc;		# node names
	nsi += nseg;		# increment node name counter
	nseg = 0;			# reset segment counter
	nlast = np;
      }
    }else{
# new point
      np++;
      nseg++;
      
      if(no_proj){
	  x[np] = $1;
	  y[np] = $2;
	  if(NF>2){
	      if(is_depth)
		  z[np] = (1-$3/6371);
	      else
		  z[np] = $3;
	  }else{
	      z[np] = 0;
	  }
      }else{
	  lambda=$2*f;
	  phi=$1*f;
	  if(NF>2){			# r specified
	      if(is_depth)
		  r = (1-$3/6371);	# third column is 
	      else
		  r = $3;
	      tmp=cos(lambda) * r;	# 
	      
	  }else{			# no z
	      r = R;
	      tmp=cos(lambda);
	  }
	  x[np]=tmp * cos(phi);
	  y[np]=tmp * sin(phi);
	  z[np]=sin(lambda)*r;
      }
      if(NF>3){			# attribute
	  a[np] = $4;
	  use_attribute=1;
      }
    }
  }
}
END{
  print("# vtk DataFile Version 4.0");
  print("converted from GMT -m file");
  print("ASCII");
  print("DATASET POLYDATA");
  print("POINTS",np,"float")
  for(i=1;i<=np;i++)
    printf("%.6e %.6e %.6e\n",x[i],y[i],z[i]);
# print("");
  if(use_attribute){
      print("POINT_DATA ",np)
      print("SCALARS attribute float 1")
      print("LOOKUP_TABLE default ")
      for(i=1;i<=np;i++)
	  printf("%s\n",a[i]);


  }
  print("LINES",nsc,nsi);
  ic=0;
  for(i=1;i<=nsc;i++){
    ic++;
    nseg = -ns[ic];
    printf("%i\t",nseg)
    for(j=1;j<=nseg;j++){
      ic++;
      printf("%i ",ns[ic]);
    }
    printf("\n");
  }



}

