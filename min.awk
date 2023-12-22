#
# find min of $col, if col is not set, will use fist
# if pcol is set, will print the $pcol value of the line of the min
#
BEGIN{
  min=9e20;
  if(col==0)
    col=1;
  if(pcol==0){
    print_col=0;
  }else{
    print_col=1;
  }
  if(print_row != 0)
      print_row = 1;
  else
      print_row = 0;
}

{
  if(((substr($1,1,1)!="#")) && ($1 != "") && ($1 != ">") ){
      if(($col!="") && (tolower($col) != "nan")){
	  if($col < min){
	      min=$col;
	      if(print_row)
		  row = $0;
	      if(print_col)
		  x=$pcol;
	      
	  }
      }
  }
}
END{
    if((!print_col)&&(!print_row)){
	print(min);
    }else{
	if(print_row)
	    print(row)
	else
	    print(min,x)
    }
}
