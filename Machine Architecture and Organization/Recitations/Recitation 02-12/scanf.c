#include<stdio.h>

int main() {
  char a = 'a';
  int b = 1;
  float c = 1.23;
  char string[10] = {'c','s','c','i','-','2','0','2','1','\0'};

  scanf("%c%i%f%s", &a, &b, &c, string); 

  printf("a: %c \nb: %d \nc: %g \nstring: %s \n", a, b, c, string);

  return 0;
}
