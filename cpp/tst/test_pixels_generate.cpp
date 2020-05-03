#include <iostream>
#include <gtest/gtest.h>

#include "pixels_generate.hpp"

using namespace ::testing;

class TestPixelsGenerate : public Test
{
public:

private:
  virtual void SetUp()
  {
  }

  virtual void TearDown()
  {
  }
};

TEST_F(TestPixelsGenerate, testSum)
{
  PixelsGenerate pg;
  int number1 = 1;
  int number2 = 2;

  std::cout << "The sum of " << number1 << " + " << number2 << " is equal to " << pg.get_sum(number1,number2) << std::endl;
}


int main(int argc, char ** argv) {
  InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}

