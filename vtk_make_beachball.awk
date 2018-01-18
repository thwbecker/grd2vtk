#
# this is taken almost verbatim from Christian Moder's Diplomarbeit,
# LMU, 2006
#
# slightly modified by Thorsten Becker twb@usc.edu
#
# $Id: vtk_make_beachball.awk,v 1.1 2014/05/06 22:50:06 becker Exp becker $
#
# for each beach ball:
#
# fields: lon, lat, depth, magnitude, strike, dip, rake
#
BEGIN {
    #
    # initializations
    number = 0; # number of beach balls
    stepwidth = 10; # must be a divisor of 360 and 190 => 1, 2, 5, 10
    bb_radius = 0.0001; # compare to earth radius
    earth_radius_km = 6371;
    if(vert_exag == "")
	vert_exag = 1;
    
 # local variables and settings
 #fs = ","; # input: separated by komma
    ofs = "\t"; # output: separate fields with a tab
    pi = atan2( 0, -1 );
    pif = pi/180.;

    lonsteps = int( 360 / stepwidth );
    latsteps = int( 190 / stepwidth );
    nrpoints = lonsteps * latsteps; # number of grid points per beach ball
    corr = -90;


    corr_rad = corr * pif;
    cos_corr = cos(corr_rad);
    sin_corr = sin(corr_rad);


    filename = ARGV[1]; # use input from first command line argument
    ("wc -l < " filename) | getline number; # get number of lines in input file
    
    # output vtk header
    print "# vtk DataFile Version 3.0";
    print "converted from",filename;
    print "ASCII";
    print "DATASET POLYDATA";
    print "POINTS " (nrpoints * number) " float";

    n=0;
}

{
    if(substr($1,1,1)!="#"){
	n++;
	
	bb_lon = $1;
	bb_lon_rad = bb_lon * pif;
	
	bb_lat = $2;
	bb_lat_rad = bb_lat * pif;
	
	radius = 1 - ($3 / earth_radius_km) * vert_exag; # vertical exageration
	
	
	#magnitude_fact = ($4 - 5.5); # typical: something like magnitude_fact = magnitude - 6
	magnitude_fact = $4; 
	bb_size = bb_radius * magnitude_fact;
	
	strike = -$5;
	strike_rad = strike * pif;
	
	dip =    -$6;
	dip_rad = dip * pif;
	
	rake =    $7;
	rake_rad = rake * pif;
	
	scalar[n] = $8;
	
	cos_rake = cos(rake_rad);
	sin_rake = sin(rake_rad);
	
	cos_dip = cos(dip_rad);
	sin_dip = sin(dip_rad);
	
	cos_strike = cos(strike_rad);
	sin_strike = sin(strike_rad);

	sin_bb_lon = sin(bb_lon_rad);
	cos_bb_lon = cos(bb_lon_rad);
	
	sin_bb_lat = sin(bb_lat_rad);
	cos_bb_lat = cos(bb_lat_rad);
	
	NF = 3;
# create gridpoints
	for( lat = 90; lat >= -90; lat-=stepwidth ){
	    for( lon = 0; lon < 360; lon+=stepwidth ){
		# location of each point = original location + rotation by its position on earth
		# add stepwidth/2 because colors are interpolated *between * points, 
		# i.e. it must lie exactly between two points
		point_lon = lon + stepwidth/2;
		point_lat = lat;
		
		# calculate cartesian coordinates
		tmp =  bb_size * cos(point_lat * pif);
		x = tmp * cos(point_lon * pif);
		y = tmp * sin(point_lon * pif);
		z = bb_size * sin(point_lat * pif);
		
		# use correct position: rotate around x axis
		x_rot = x;
		y_rot = y * cos_corr - z * sin_corr;
		z_rot = y * sin_corr + z * cos_corr;
		
		x = x_rot; y = y_rot; z = z_rot;
		
		# rotate: rake (rotate around x axis)
		x_rot = x;
		y_rot = y * cos_rake - z * sin_rake;
		z_rot = y * sin_rake + z * cos_rake;
		
		x = x_rot; y = y_rot; z = z_rot;
		
		# rotate: dip (rotate around z axis)
		x_rot = x * cos_dip - y * sin_dip;
		y_rot = x * sin_dip + y * cos_dip;
		z_rot = z;
		
		x = x_rot; y = y_rot; z = z_rot;
		
		# rotate: strike (rotate around x axis)
		x_rot = x;
		y_rot = y * cos_strike - z * sin_strike;
		z_rot = y * sin_strike + z * cos_strike;
		
		x = x_rot; y = y_rot; z = z_rot;
		
		# rotate according to latitude
		rot_lat = -bb_lat_rad;
		#rot_lat = bb_lat_rad;
		x_rot =  x * cos(rot_lat) + z * sin(rot_lat);
		y_rot =  y;
		z_rot = -x * sin(rot_lat) + z * cos(rot_lat);
		
		x = x_rot; y = y_rot; z = z_rot;
		
		# rotate according to longitude
		x_rot = x * cos_bb_lon - y * sin_bb_lon;
		y_rot = x * sin_bb_lon + y * cos_bb_lon;
		z_rot = z;
		
		x = x_rot; y = y_rot; z = z_rot;
		
		# move origin: add cartesian coordinates of earth
		tmp =  radius * cos_bb_lat;
		x +=  tmp * cos_bb_lon;
		y +=  tmp * sin_bb_lon ;
		z +=  radius * sin_bb_lat;
		
		print(x,y,z);
	    }
	}
    }
}

# write the connectivity and the other remaining stuff
END {
     
     # output polygons
     print "POLYGONS " ((nrpoints - lonsteps) * number) " " (5 * (nrpoints - lonsteps) * number );
     
     for( i = 0; i < number; i++ )
     {
	 
	 for( lat = 0; lat < latsteps - 1; lat++ )
	 {
	     for( lon = 0; lon < lonsteps - 1; lon++ )
	     {
		 $1 = 4;
		 $2 = (lat * lonsteps + lon + i * nrpoints);
		 $3 = ( (lat + 1) * lonsteps + lon + i * nrpoints);
		 $4 = ( (lat + 1) * lonsteps + lon + 1 + i * nrpoints);
		 $5 = (lat * lonsteps + lon + 1 + i * nrpoints);
		 
		 print;
	     }
	     
	     $1 = 4;
	     $2 = (lat * lonsteps + lon + i * nrpoints);
	     $3 = ( (lat + 1) * lonsteps + lon + i * nrpoints);
	     $4 = ( (lat + 1) * lonsteps + i * nrpoints);
	     $5 = (lat * lonsteps + i * nrpoints);
	     
	     print;
	 }
	 
     }
     
     # output color data
     print "POINT_DATA " (nrpoints * number);
     print "SCALARS color float";
     print "LOOKUP_TABLE colortbl";
     
     for( i = 0; i < number; i++ )
     {
	 
	 for( lat = 90; lat >= -90; lat-=stepwidth )
	 {
	     for( lon = 0; lon < 360; lon+=stepwidth )
	     {
		 if( (1 == int( lon / 90)) || (3 == int( lon / 90)) )
		 {
		     print 1;
		 }
		 else
		 {
		     print 0;
		 }
	     }
	 }
	 
     }
     
     #print "POINT_DATA " (nrpoints * number);
     print "SCALARS time float";
     print "LOOKUP_TABLE default";
     
     for( i = 1; i <= number; i++ )
     {
	 
	 for( lat = 90; lat >= -90; lat-=stepwidth )
	 {
	     for( lon = 0; lon < 360; lon+=stepwidth )
	     {
		 print scalar[i];
	     }
	 }
     }
     
     # output color table (black and white)
     print "LOOKUP_TABLE colortbl 2";
     print "0.000000 0.000000 0.000000 1.000000";
     #print "0.000000 0.000000 1.000000 1.00000";
     print "1.000000 1.000000 1.000000 1.00000";
     
 }

