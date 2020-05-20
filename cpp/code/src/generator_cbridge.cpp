#include <cstdlib>

#include "generator.hpp"
#include "generator_cbridge.h"


#ifdef __cplusplus
extern "C" {
#endif

int generator_get_number(int min, int max)
{
  Generator generator;
  return generator.add_range(min, max);
}

int generator_get_sum(int min, int max)
{
  Generator generator;
  return generator.get_sum(min, max);
}

#ifdef __cplusplus
}
#endif
