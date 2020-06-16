#include <iostream>

#include "pixels_generator_cbridge.h"


int main(int argc, char *argv[])
{
  int num1 = 2;
  int num2 = 4;
  //int sum = Generator_get_sum(num1, num2);
  //int sum = pixelsgenerator_get_sum(num1, num2);
  //std::cout << sum << std::endl;

  /*
  int length = 40;
  int cenas[2] = {30, 40};
  int array_cenas[2][length] = {{0}};
  int* array_cenas_ptr = &array_cenas[0][0];

  pixelsgenerator_generate_simple(cenas, length, array_cenas_ptr);

  std::cout << std::endl << std::endl << std::endl;

  for(int i = 0; i < length; i++)
  {
    printf("%d %d\n", array_cenas[0][i], array_cenas[1][i]);
  }*/


  std::cout << atoi(argv[1]) + atoi(argv[2]) << std::endl;

  return 0;
}
