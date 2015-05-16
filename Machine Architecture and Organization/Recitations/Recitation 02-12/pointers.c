/*************************************
 * pointers.c
 * A simple c program to give an introduction
 * to what pointers are in C
 *
 * Andy Exley
 *
 * **********************************/

#include <stdio.h>
#include <stdlib.h>

/* globals bad, yeah, yeah. */
double x;
double y;
double* px;
double* py;

/* Set initial vals of x and y, and initialize space for px and py */
void init() {
   x = 2.0;
   y = 4.0;
   px = (double*)malloc(sizeof(double)); /* (ack! memory leak!) */
   py = (double*)malloc(sizeof(double)); /* (ditto!) */
}

/* Print out the addresses and values */
void display() {
   printf("&x: %p &y: %p px: %p py: %p\n",(void*)&x, (void*)&y, (void*)px, (void*)py);
   printf("x: %f y: %f *px: %f *py: %f\n\n", x, y, *px, *py);
}

int main(void) {

   init();

   // demo of *
   *px = x;
   *py = y;
   x = 10.0;
   *py = 20.0;
   
   display();

   init();

   // demo of &
   px = &x;
   py = &y;
   x = 10.0;
   *py = 20.0;

   display();

   init();

   // demo of & and *
   px = &x;
   py = &y;
   *px = x + y;
   *py = x - y;
   
   display();

   init();

   // setting pointers equal to each other
   px = &x;
   py = px;
   *px = x + y;
   *py = x - y;

   display();
   
   init();

   // pointer arithmetic!
   px = &x;
   py = &y;
   *(px + 2) = 20.0;
   
   display();
   
   return 0;
}

