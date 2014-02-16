
#define MAIN_PROGRAM

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "extras.h"

double T;
double V;

double func (double x);
double envar (double x);
void plot_envar ();

int main (int argc, char *argv[]) {
	
	if (argc < 5) {
		printf("Set all parameters: x_min, x_max, T, V.\n\n");
		exit(EXIT_FAILURE);
	}

	double result, extremes[2];

	extremes[0] = atof(argv[1]);
	extremes[1] = atof(argv[2]);
	T = atof(argv[3]);
	V = atof(argv[4]);

	plot_envar(extremes[0], extremes[1]);

	Zbisection(func, extremes, 1.0e-4);
	result = Zsecant(func, extremes, 1.0e-8);

	printf("Minimum            : %.8lf \n", result);
	printf("Function @ minimum : %.8lf \n\n", envar(result));

	exit(EXIT_SUCCESS);
}

double func (double x) {
	return T*sinh(x) + V*exp(-2.0*x)/(1.0 - exp(-2.0*x))/(1.0 - exp(-2.0*x));
}

double envar (double x) {
	return -2*T*cosh(x) + V/(1.0 - exp(-2.0*x));
}


void plot_envar (double min, double max) {
	double x, dx;
	dx = (max - min)/100.0;
	FILE *out;
		out = fopen("lp_output/analytic.dat","w");
	for (x=min; x<max; x+=dx)
		fprintf(out,"%lf\t%lf\n", x, envar(x));
	fclose(out);
}