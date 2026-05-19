// use to call the python script to do matrix multiplication
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <python3.12/Python.h>

static double g_time_taken = 0.0;

double matrix_mul_shell_4python(void) {
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

	PyObject *main_mod = PyImport_AddModule("__main__");
	PyObject *time_obj = NULL;
	if (main_mod != NULL) {
		time_obj = PyObject_GetAttrString(main_mod, "time_taken");
	}
	if (time_obj != NULL) {
		double time_taken = PyFloat_AsDouble(time_obj);
		if (PyErr_Occurred() != NULL) {
			PyErr_Print();
		} else {
			g_time_taken = time_taken;
		}
		Py_DECREF(time_obj);
	} else {
		PyErr_Clear();
		fprintf(stderr, "Failed to read time_taken from Python.\n");
	}

	Py_Finalize();
	return g_time_taken;
}