#include<stdio.h>
#include<stdlib.h>

int main() {

    /* (1) Declare array and immediately set entries */
    int array[5] = {1, 2, 3, 4, 5};
    int k;
    for (k = 0; k < 5; k++) {
        printf("array[%d] = %d\n", k, array[k]);
    }
    printf("\n");




    /* (2) Create an array and set entries after */
    int class_sections[5];
    int i;
    for (i = 0; i < sizeof(class_sections)/4; i++){
        class_sections[i] = i + 1;
        printf("class section[%d]: %d\n", i, class_sections[i]);
    }
    printf("\n");




    /* (3) An array as a pointer */
    int j;
    for (j = 0; j < sizeof(array)/4; j++) {
        printf("First array[%d]: %d\n", j, *(array+j));
    }
    printf("\n");




    /* (4) We can have arrays of types other than integers! */
    char letter_grades[5] = {'A', 'B', 'C', 'D', 'F'};
    int n;
    for (n = 0; n < sizeof(letter_grades); n++){
        printf("letter_grade[%d]: %c\n", n, letter_grades[n]);
    }
    printf("\n");




    /* (5) FYI: More complex stuff with malloc */
    int *myarray;
    myarray = (int *)malloc(sizeof(int) * 5);
    int l;
    for (l = 0; l < 5; l++) {
        *(myarray + l) = l;
        printf("myarray[%d]: %d\n", l, *(myarray + l));
    }
    printf("\n");



    return 0;
}
