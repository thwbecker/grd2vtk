#convert a 
#
# lon lat depth magnitude 
#
# file to VTK format
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
    if($4==0)
      mag[n]=3;
    else
      mag[n]=$4;
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
#  printf("CELLS %i %i\n",n,n);
#  for(i=1;i<=n;i++){
#    printf("1 %i ",i-1);
#    if(i%40 == 0)printf("\n");
#  }
#  printf("\n");
#  printf("CELL_TYPE %i\n",n);
#  for(i=1;i<=n;i++){
#    printf("2 ");
#    if(i%40 == 0)printf("\n");
#  }
#  printf("\n");
  printf("POINT_DATA %i\n",n);
  print("SCALARS Mw float 1");
  print("LOOKUP_TABLE default");
  for(i=1;i<=n;i++)
    printf("%g\n",mag[i]);
  print("SCALARS depth float 1");
  print("LOOKUP_TABLE default");
  for(i=1;i<=n;i++)
    printf("%g\n",d[i]);




}
