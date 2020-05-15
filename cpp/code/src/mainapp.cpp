#include <iostream>

//#include "generator_cbridge.h"
#include "pixels_generator_cbridge.h"


int main()
{
  int num1 = 2;
  int num2 = 4;
  //int sum = Generator_get_sum(num1, num2);
  int sum = pixelsgenerator_get_sum(num1, num2);

  std::cout << sum << std::endl;

  return 0;
}
