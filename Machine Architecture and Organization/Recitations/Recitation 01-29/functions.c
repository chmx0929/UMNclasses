#include<stdio.h>
#include"functions.h"

#define PI 3.14


int main() {
  double area = areaCircle(3.0);

  printf("Area is: %g\n", area);

  return 0;
}


double areaCircle(double r) {
  double area = r * r * PI;
  return area;
}
