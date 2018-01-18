/* 
   routines dealing with little/big endian crap

   taken from the web at some point, i think 

   $Id: flip_byte_order.c,v 1.2 2018/01/18 14:41:45 twb Exp $

*/
#include "bo.h"

/* check for endian-ness */

int is_little_endian(void)
{
  static const unsigned long a = 1;
  
  return *(const unsigned char *)&a;
}

/* 


flip endian-ness


*/
/* 

flip endianness of x

*/
void flip_byte_order(void *x, size_t len)
{
  void *copy;
  copy = (void *)malloc(len);
  if(!copy){
    fprintf(stderr,"flip_byte_order: memerror with len: %i\n",(int)len);
    exit(-1);
  }
  memcpy(copy,x,len);
  flipit(x,copy,len);
  free(copy);
}
/* this should not be called with (i,i,size i) */
void flipit(void *d, void *s, size_t len)
{
  unsigned char *dest = d;
  unsigned char *src  = s;
  src += len - 1;
  for (; len; len--)
    *dest++ = *src--;
}

