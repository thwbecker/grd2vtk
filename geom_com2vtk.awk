BEGIN{
  go=-1;
}
{
  if(match($0,"CNOFF"))
    go=0;
  if(go != -1){
    if((substr($1,1,1)!="#")&&($1!="")){
      go++;
      if(go == 1)
	



    }
  }

}
