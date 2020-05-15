#include <cstdlib>

#include "generator.hpp"
#include "generator_cbridge.h"


#ifdef __cplusplus
extern "C" {
#endif

static Generator* Generator_instance = NULL;

int Generator_get_number(int min, int max)
{
  return Generator_instance->add_range(min, max);
}

int Generator_get_sum(int min, int max)
{
  return Generator_instance->get_sum(min, max);
}

#ifdef __cplusplus
}
#endif
