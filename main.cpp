#include <kplot.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>

#define N 100
#define STEP (2.0 * M_PI / N)

int main(void)
{
	double x[N], y[N];
	for (int i = 0; i < N; ++i) {
		x[i] = i * STEP;
		y[i] = sin(x[i]);
	}

	struct kplot_cfg cfg = {0};
	cfg.width = 400;
	cfg.height = 300;

	struct kplot *p = kplot_alloc(&cfg);
	if (!p) {
		perror("kplot_alloc");
		return 1;
	}

	kplot_data(p, x, y, N, "sin(x)", KPLOT_DLINE, NULL);

	if (kplot_draw(p, "out.svg", KPLOT_SVG) == KPLOT_OK)
		puts("Gráfico salvo em out.svg");
	else
		puts("Erro ao salvar SVG");

	kplot_free(p);
	return 0;
}

