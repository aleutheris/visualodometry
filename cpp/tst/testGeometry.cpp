#include <iostream>
#include <gtest/gtest.h>

#include "Geometry.hpp"

using std::runtime_error;
using namespace ::testing;

class TestGeometry : public Test
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

TEST_F(TestGeometry, testSum)
{
}


int main(int argc, char ** argv) {
  InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}
