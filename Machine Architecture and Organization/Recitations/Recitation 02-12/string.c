#include<stdio.h>
#include<stdlib.h>

int main() {

    /* A string is a null terminated array of characters */
    char firstname[10] = {'B','r','i','a','n','\0'};
    printf("My firstname is: %s\n", firstname);



    /* Using quotes */
    char lastname[10] = "Smith";
    printf("My lastname is: %s\n", lastname);



    /* Assign as much memory as needed to hold string */
    char *class = "csci-2021";
    char section[] = "section 1";
    printf("I am registered for %s, %s\n", class, section);



    /* Since a string is an array of chars, I can modify any char within */
    section[8] = '2';
    lastname[0] = 'C';
    printf("My section has changed to: %s\n", section);
    printf("My lastname has changed to: %s\n", lastname);



    /* FYI, we can also create a pointer and allocate memory */
    char *mylab;
    mylab = (char *)malloc(10);
    mylab = "Datalab";
    printf("My lab assignment is: %s\n", mylab);

    printf("\n");
    return 0;
}
