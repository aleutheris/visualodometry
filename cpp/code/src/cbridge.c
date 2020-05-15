#include <stdio.h>
#include <stdlib.h>

#include "cbridge.h"


int* create_array(int m)
{
  int* array = calloc(m, sizeof(int));

  return array;
}

int** create_multi_array(int length1, int length2)
{
  int** multi_array = calloc(length1, sizeof(int*));
  int i = 0;

  for(i = 0; i < length1; i++)
  {
    multi_array[i] = calloc(length2, sizeof(int));
  }

  return multi_array;
}

void destroy_array(int* array)
{
  free(array);
}

void destroy_multi_array(int** multi_array, int length1)
{
  int i = 0;

  for(i = 0; i < length1; i++)
  {
    free(multi_array[i]);
  }

  free(multi_array);
}
