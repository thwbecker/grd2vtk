#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include "bo.h"
/* 
   read in floats as ASCII and write in binary,

   BIG ENDIAN

   $Id: asciifloat2bebin.c,v 1.1 2018/01/18 14:41:26 twb Exp twb $

*/
int main(int argc, char **argv)
{
  int n;
  float *x;
  int rbo;
  static size_t len = sizeof(float);
  rbo = is_little_endian();	/* do we need to flip the byte order? */
  if(argc != 1){
    fprintf(stderr,"%s\nread floats as ASCII from stdin and write them in binary to stdout\n\n",
	    argv[0]);
    exit(-1);
  }
  n=0;
  x=(float *)malloc(len);
  while(fscanf(stdin,"%f",(x+n)) == 1){
    if(rbo)
      flip_byte_order((void *)(x+n),len);
    n++;
    x=(float *)realloc(x,(n+1)*len);
    if(!x){
      fprintf(stderr,"%s: memory error during buffering, n=%i\n",
	      argv[0],n);
      exit(-1);
    }
  }
  if(n){
    fwrite(x,len,n,stdout);
    fprintf(stderr,"%s: converted %i floats\n",argv[0],n);
  }
  free(x);
  exit(n);
}
