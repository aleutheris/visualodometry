#include <iostream>
#include <algorithm>
#include <gtest/gtest.h>

#include "pixels_generator.hpp"

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

TEST_F(TestPixelsGenerate, test_something)
{
}


int main(int argc, char** argv)
{
  InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}

