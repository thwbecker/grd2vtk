#convert x y z time mag file to VTK format
BEGIN{
}
{
    if((substr($1,1,1)!="#")&&(NF>=5)){
	n++;
	x[n]=$1;
	y[n]=$2;
	z[n]=$3;
	time[n]=$4;
	mag[n]=$5;
    }
}
END{
  print("# vtk DataFile Version 3.0");
  printf("converted from %s\n",FILENAME);
  if(binary)
      print("BINARY")
  else
      print("ASCII");
  print("DATASET POLYDATA");
  printf("POINTS %i float\n",n);
  if(binary){
      for(i=1;i<=n;i++)
	  printf("%g %g %g\n",x[i],y[i],z[i]) | "asciifloat2bebin"
      close("asciifloat2bebin")
  }else{
      for(i=1;i<=n;i++)
	  printf("%g %g %g\n",x[i],y[i],z[i]);
  }
  printf("POINT_DATA %i\n",n);
  print("SCALARS time float 1");
  print("LOOKUP_TABLE default");
  if(binary){
      for(i=1;i<=n;i++)
	  printf("%g ",time[i]) | "asciifloat2bebin"
      close("asciifloat2bebin")
  }else{
      for(i=1;i<=n;i++)
	  printf("%g\n",time[i]);
  }
  print("SCALARS mag float 1");
  print("LOOKUP_TABLE default");
  if(binary){
     for(i=1;i<=n;i++)
	  printf("%g ",mag[i]) | "asciifloat2bebin"
     close("asciifloat2bebin")
  }else{
      for(i=1;i<=n;i++)
	  printf("%g\n",mag[i]);
  }



}
