#include <iostream>

#include "json_bridge.hpp"
#include "pixels_generator.hpp"


int main(int argc, char *argv[])
{/*
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

  std::cout << j.dump() << std::endl;*/


  ImageDimensions id;
  id.x = 4;
  id.y = 5;

  JsonBridge jb;
  json j = jb.to_json(id);

  std::cout << j.dump() << std::endl;

  return 0;
}
