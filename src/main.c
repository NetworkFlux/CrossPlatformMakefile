#include "cpm.h"
#include "staticlib.h"
#include "dynamiclib.h"
#include <windows.h>

int main(void)
{
	printf("Hello from Project\n");
	static_lib_hello();
	dynamic_lib_hello();
	MessageBoxA(NULL, "Hello from Windows Library\n", "Test", MB_OK);
	return (0);
}