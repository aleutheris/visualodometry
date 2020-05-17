#include <cstdlib>

#include "generator.hpp"
#include "generator_cbridge.h"


#ifdef __cplusplus
extern "C" {
#endif

static Generator generator;

int Generator_get_number(int min, int max)
{
  return generator.add_range(min, max);
}

int Generator_get_sum(int min, int max)
{
  return generator.get_sum(min, max);
}

#ifdef __cplusplus
}
#endif
