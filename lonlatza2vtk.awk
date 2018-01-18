#convert 
#
# lon lat depth attribute 
#
# file to VTK format
#
BEGIN{
  f=0.017453292519943296;
  R=6371.;
}
{
  if((substr($1,1,1)!="#")&&(NF>=4)){
    n++;
    lambda=$2*f;phi=$1*f;
    d[n]=$3;
    r=(R-d[n])/R;
    tmp=cos(lambda)*r;
    x[n]=tmp * cos(phi);
    y[n]=tmp * sin(phi);
    z[n]=sin(lambda)*r;
    att[n]=$4;
  }
}
END{
  print("# vtk DataFile Version 3.0");
  printf("converted from %s\n",FILENAME);
  print("ASCII");
  print("DATASET POLYDATA");
  printf("POINTS %i float\n",n);
  for(i=1;i<=n;i++)
    printf("%g %g %g\n",x[i],y[i],z[i]);
  printf("POINT_DATA %i\n",n);
  print("SCALARS attribute float 1");
  print("LOOKUP_TABLE default");
  for(i=1;i<=n;i++)
    printf("%g\n",att[i]);

}
