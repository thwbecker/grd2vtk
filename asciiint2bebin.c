#include <stdio.h>
#include "bo.h"
/* 
   read in n intergers as ASCII and write in BIN ENDIAN binary

   $Id: asciiint2bebin.c,v 1.1 2018/01/18 14:41:26 twb Exp twb $

*/
int main(int argc, char **argv)
{
  int *i,n;
  int rbo;
  static size_t len = sizeof(int);
  rbo = is_little_endian();	/* do we need to flip the byte order? */

  if(argc != 1){
    fprintf(stderr,"%s\nread integers as ASCII from stdin and write them in binary to stdout\n\n",
	    argv[0]);
    exit(-1);
  }
  n=0;
  i=(int *)malloc(len);
  while(fscanf(stdin,"%i",(i+n)) == 1){
    if(rbo)
      flip_byte_order((void *)(i+n),len);
    n++;
    i=(int *)realloc(i,len*(n+1));
    if(!i){
      fprintf(stderr,"%s: memory error during buffering, n=%i\n",
	      argv[0],n);
      exit(-1);
    }

  }
  if(n){
    fwrite(i,len,n,stdout);
    fprintf(stderr,"%s: converted %i integers\n",argv[0],n);
  }
  free(i);
  exit(n);
}
