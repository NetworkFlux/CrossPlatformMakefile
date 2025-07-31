#include "ccm.h"
#include "win_static_test.h"
#include "win_dyn.h"

int main(void)
{
    printf("Hello from compile_test!\n");
	win_static_hello();
	win_dyn_hello();
    return (0);
}