// use to call the python script to do matrix multiplication
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <python3.12/Python.h>

int main(void) {
	const char *script_path = "../matrix_mul_python.py";

	FILE *script = fopen(script_path, "r");
	if (script == NULL) {
		fprintf(stderr, "Failed to open Python script '%s'\n", script_path);
		return 1;
	}

	Py_Initialize();
	int rc = PyRun_SimpleFile(script, script_path);
	fclose(script);

	if (rc != 0) {
		PyErr_Print();
		Py_Finalize();
		return 1;
	}

	Py_Finalize();
	return 0;
}