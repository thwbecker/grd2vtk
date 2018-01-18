#
#
# convert lon lat v_east v_north to VTK vectors
#
# Thorsten Becker, UT Austin
# thorstinski@gmail.com
#
# $Id: gmtpoly2vtk.awk,v 1.2 2008/10/16 15:51:22 becker Exp becker $
#
# if adjust_height is set, will expect fifth column with height

BEGIN{

  np=0;

  # constants
  f=0.017453292519943296;
  if(height == "")
      r = 1;
  else
      r = 1 + height/6371.;

   if(adjust_height == ""){
     adjust_height = 0;
   }else{
     adjust_height = 1;
   }
  if(vex == "")
     vex = 25;
  if(zscale == "")
	zscale = 1e-3;
}
{
  if(substr($1,1)!="#"){

      
      np++;

      lambda=$2*f;
      theta=(90.0-$2)*f;
      phi=$1*f;

# polar velocity components
      vr=0;
      vtheta=-$4;
      vphi=$3;
#
# base vecs
      ct=cos(theta);
      cp=cos(phi);
      st=sin(theta);
      sp=sin(phi);
#
      polar_base_r[1]= st * cp;
      polar_base_r[2]= st * sp;
      polar_base_r[3]= ct;
#
      polar_base_theta[1]= ct * cp;
      polar_base_theta[2]= ct * sp;
      polar_base_theta[3]= -st;
#
      polar_base_phi[1]= -sp;
      polar_base_phi[2]=  cp;
      polar_base_phi[3]= 0.0;
# convert vector

      for(i=1;i<=3;i++){
	  cart_vec[np*3+i]  = polar_base_r[i]    * vr ;
	  cart_vec[np*3+i] += polar_base_theta[i]* vtheta;
	  cart_vec[np*3+i] += polar_base_phi[i]  * vphi;
      }

      if(adjust_height){
        r = 1 + (($5*zscale)/6371.)*vex;
      }
      tmp=r * cos(lambda);		
      x[np]=tmp * cos(phi);
      y[np]=tmp * sin(phi);
      z[np]=r * sin(lambda);
    }

}
END{
  print("# vtk DataFile Version 4.0");
  print("converted from GMT -M file");
  print("ASCII");
  print("DATASET POLYDATA");
  print("POINTS",np,"float")
  for(i=1;i<=np;i++)
    printf("%.6e %.6e %.6e\n",x[i],y[i],z[i]);
  print("");

  print("POINT_DATA ",np)
  print("VECTORS velocity float");
  for(i=1;i<=np;i++){
      printf("%g %g %g\n",cart_vec[i*3+1],cart_vec[i*3+2],cart_vec[i*3+3]);
  }



}

