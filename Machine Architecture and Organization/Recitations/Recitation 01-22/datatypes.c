/* datatypes.c -- by Reid Priedhorsky for CSCI 2021, Spring 2005

   This program demonstrates some of the data types available in C. These are
   the most useful fundamental data types. Beyond these, there are a few other
   fundamental types, and on top of these you can layer various qualifiers and
   aggregations, and you can define your own types as well. */


#include <stdio.h>


int main(void)
{
  // Integral types
  short int a = 123;      // can omit "int"
  int b = 456;
  long int c = 0x1abc89;  // ditto
  char d = 'q';           // equivalent: char d = 113;

  // Floating-point types
  float e = 1.999;
  double f = 3/2;    // careful!
  double g = 3/2.0;  // ok
  long double h = 3.141;

  // Printing them:
  printf("a: short, size %d bytes, value %d\n", sizeof(a), a);
  printf("b: int, size %d bytes, value %d\n", sizeof(b), b);
  printf("c: long, size %d bytes, value %ld\n", sizeof(c), c);
  printf("d: char, size %d bytes, value %c or %d or 0x%x\n", sizeof(d), d, d, d);
  printf("e: float, size %d bytes, value %f or %g or %e\n", sizeof(e), e, e, e);
  printf("f: double, size %d bytes, value %g\n", sizeof(f), f);  // ???
  printf("g: double, size %d bytes, value %g\n", sizeof(g), g);
  printf("h: long double, size %d bytes, value %Lg\n", sizeof(h), h);

  return 0;
}

