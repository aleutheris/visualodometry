#include <iostream>
#include "generator.hpp"

  Generator::Generator(int min, int max) : _min(min), _max(max)
  {
    srand((unsigned) time(0));
  }

  Generator::Generator()
  {
  }

  Generator::~Generator()
  {
  }

  void Generator::add_range(int min, int max)
  {
    this->_min = min;
    this->_max = max;
  }

  int Generator::get_number()
  {
    return (rand() % (_max - _min + 1)) + _min;
  }

