# turn row into column
BEGIN{
    if(use=="")
	use=1;
}
{
  if(substr($1,1,1)!="#"){
      for(i=1;i <= NF/use;i ++){
	  for(j=1;j <= use;j++)
	      printf("%s ",$((i-1)*use+j));
	  printf("\n");
      }
  }
}