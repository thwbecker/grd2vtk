# find the mean longitude of a GMT region
BEGIN{}
{
    split($1,a,"/");
    w = sprintf("%f",substr(a[1],3));
    e=sprintf("%f",a[2]);
    s=sprintf("%f",a[3]);
    n=sprintf("%f",a[4]);
    printf("%g %g %g %g\n",w,e,s,n)
}
