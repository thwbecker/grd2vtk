#
# find max of $col, if col is not set, will use first
# if pcol is set to some number, will print the $pcol value of the line of the max
# if pcol is all, print whole row
#
BEGIN{
  max=-9e20;
  if(col=="")
      col=1;
  if(pcol == ""){
      print_col=0;
  }else if(pcol=="all"){
      print_col=-1;
  }else{
      print_col=1;
  }
}

{
  if(((substr($1,1,1)!="#")) && ($1 != "") && ($1 != ">")){
    if(($col!="") && (tolower($col) != "nan")){
      if($col > max){
	max=$col;
	if(print_col != 0){
	    if(print_col <0){
		x = $0;
	    }else{
		x = $(pcol);
	    }
	}
      }
    }
  }
}
END{
  if(print_col == 0)
      print(max);
  else{
      print(max,x);
  }
}
