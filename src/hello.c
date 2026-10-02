
#include <stdio.h>

void hello() {
    printf("Hello from library!\n");
}

void __attribute__ ((constructor)) initLibrary(void) {
    //
    // Function that is called when the library is loaded
    //
    printf("Library is initialized\n");
}
void __attribute__ ((destructor)) cleanUpLibrary(void) {
    //
    // Function that is called when the library is »closed«.
    //
    printf("Library is exited\n");
}