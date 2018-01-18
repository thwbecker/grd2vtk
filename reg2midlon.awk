# find the mean longitude of a GMT region
BEGIN{
    if(frac=="")
	frac = 0.5;
}
{
  n=split($1,a,"/");
  print(substr(a[1],3)+(a[2]-substr(a[1],3))*frac);
}
