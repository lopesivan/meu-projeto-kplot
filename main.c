#define _DEFAULT_SOURCE /* Necessário para habilitar ssize_t no Linux/Glibc */

/* 1. Includes do Sistema (Definem os tipos básicos) */
#include <math.h>
#include <stddef.h> /* Define size_t */
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h> /* Define ssize_t */

/* 2. Includes de Terceiros */
#include <cairo/cairo-svg.h>
#include <cairo/cairo.h>

/* 3. Kplot (Deve vir POR ÚLTIMO, pois depende dos tipos acima) */
#include <kplot.h>

/* ... resto do código ... */

#define N 100
#define STEP (2.0 * M_PI / N)

int main(void) {
  // 1. Preparar dados
  struct kpair *points = calloc(N, sizeof(struct kpair));
  if (points == NULL) {
    perror("calloc");
    return 1;
  }

  for (int i = 0; i < N; ++i) {
    points[i].x = i * STEP;
    points[i].y = sin(points[i].x);
  }

  // 2. Criar fonte de dados
  struct kdata *d = kdata_array_alloc(points, N);
  if (d == NULL) {
    perror("kdata_array_alloc");
    free(points);
    return 1;
  }

  // 3. Criar o plot (CORREÇÃO AQUI: usando NULL para config padrão)
  struct kplot *p = kplot_alloc(NULL);
  if (!p) {
    perror("kplot_alloc");
    return 1;
  }

  // 4. Anexar dados
  if (!kplot_attach_data(p, d, KPLOT_LINES, NULL)) {
    fprintf(stderr, "Erro ao anexar dados\n");
    return 1;
  }

  // 5. Configurar Cairo
  double width = 400.0;
  double height = 300.0;

  cairo_surface_t *surf = cairo_svg_surface_create("out.svg", width, height);
  cairo_t *cr = cairo_create(surf);

  // Fundo branco
  cairo_set_source_rgb(cr, 1, 1, 1);
  cairo_paint(cr);

  // 6. Desenhar
  // Nota: passamos width/height aqui, o que substitui a necessidade do cfg
  // antigo
  kplot_draw(p, width, height, cr);

  // 7. Limpeza
  cairo_surface_destroy(surf);
  cairo_destroy(cr);
  kplot_free(p);
  kdata_destroy(d);
  // free(points); // Dependendo da versão do kplot, o array pode ser tomado
  // pelo kdata

  puts("Gráfico salvo em out.svg");
  return 0;
}
