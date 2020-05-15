#include <cstdlib>
#include <ctime>
#include <iostream>

#include <generator.hpp>


Generator::Generator(int min, int max) : _min(min), _max(max)
{
  srand((unsigned) time(0));
}

Generator::Generator()
{
  srand((unsigned) time(0));
}

Generator::~Generator()
{
}

int Generator::add_range(int min, int max)
{
  this->_min = min;
  this->_max = max;
  return (rand() % (_max - _min + 1)) + _min;
}

int Generator::get_number()
{
  return (rand() % (_max - _min + 1)) + _min;
}


//TODO: remove
int Generator::get_sum(int min, int max)
{
  return min+max;
}
