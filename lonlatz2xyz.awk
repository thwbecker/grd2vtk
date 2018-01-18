#
# convert lon lat depth[>0, km] input to x y z output
#
# $Id: lonlat2xyz.awk,v 1.2 2003-01-03 11:29:58-08 tbecker Exp $
#
BEGIN{
    f=0.017453292519943296;
    R=6371.;
    if(scale == "")
	scale = 1.0;
}
{
    if((substr($1,1,1)!="#") && (NF>=3)){
	lambda=$2*f;
	phi=$1*f;
	if($3!="NaN"){
	    r=(R-$3)/R*scale;
	    
	    tmp=cos(lambda)*r;
	    
	    x=tmp * cos(phi);
	    y=tmp * sin(phi);
	    z=sin(lambda)*r;
	    printf("%20.16e %20.16e %20.16e ",x,y,z);
	}else{
	    printf("NaN NaN NaN ");
	}
	for(i=4;i<=NF;i++)
	    printf("%s ",$i);
	printf("\n");
    }
}

