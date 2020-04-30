#include <iostream>

#include "Geometry.h"

int main(int argc, char *argv[])
{
  Geometry g;
  int number1 = 1;
  int number2 = 2;

  std::cout << "The sum of " << number1 << " + " << number2 << " is equal to " << g.get_sum(number1,number2) << std::endl;

  return 0;
}
