#include <iostream>
#include <algorithm>
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

TEST_F(TestPixelsGenerate, test_generante_random_number)
{
  PixelsGenerate pg;
  const int begin_test_number = 0;
  const int end_test_number = 200;
  const int number_of_attempts = 10000;
  int generated_number = 0;
  std::array<std::array<int, number_of_attempts>, end_test_number> numbers_generated_by_attempt = {{0}};

  for(int number = 1; number < end_test_number; number++)
  {
    for(int a = 0; a < number_of_attempts; a++)
    {
      generated_number = pg.generante_random_number(begin_test_number, number);
      numbers_generated_by_attempt[number][a] = generated_number;
    }
  }

  for(int number = 1; number < end_test_number; number++)
  {
    std::vector<int> unique_occurrences;
    bool same_number = true;

    unique_occurrences.push_back(numbers_generated_by_attempt[number][0]);
    for(int a = 1; a < number_of_attempts; a++)
    { // Add generated number to unique_occurrences if it is not in there already
      if(std::find(unique_occurrences.begin(), unique_occurrences.end(), numbers_generated_by_attempt[number][a]) == unique_occurrences.end())
      {
        unique_occurrences.push_back(numbers_generated_by_attempt[number][a]);
      }
      same_number &= (numbers_generated_by_attempt[number][a-1] == numbers_generated_by_attempt[number][a]);
    }
    ASSERT_NE(same_number, true); // Checks if it is not generating the same number sequence
    ASSERT_EQ(unique_occurrences.size(), number);  // Checks if all possible numbers are generated
  }
}


int main(int argc, char** argv)
{
  InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}

