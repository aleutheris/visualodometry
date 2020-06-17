#include <iostream>
#include <json.hpp>

#include "pixels_generator_cbridge.h"

using json = nlohmann::json;

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


  // instead, you could also write (which looks very similar to the JSON above)
  json j;

  // add a number that is stored as double (note the implicit conversion of j to an object)
  j["pi"] = 3.141;

  // add a Boolean that is stored as bool
  j["happy"] = true;

  // add a string that is stored as std::string
  j["name"] = "Niels";

  // add another null object by passing nullptr
  j["nothing"] = nullptr;

  // add an object inside the object
  j["answer"]["everything"] = 42;

  // add an array that is stored as std::vector (using an initializer list)
  j["list"] = { 1, 0, 2 };

  // add another object (using an initializer list of pairs)
  j["object"] = { {"currency", "USD"}, {"value", 42.99} };

  std::cout << j.dump() << std::endl;

  return 0;
}
