# find the mean longitude of a GMT region
BEGIN{}
{
  n=split($1,a,"/");
  print(substr(a[1],3),a[2],a[3],a[4]);
}
