#include <iostream>
#include <algorithm>
#include <gtest/gtest.h>

#include "generator.hpp"

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

TEST_F(TestPixelsGenerate, test_get_number)
{
  Generator gen;
  const int begin_test_number = 0;
  const int end_test_number = 200;
  const int number_of_attempts = 10000;
  const int portion_of_delta = 4;
  const int number_shift_on_array = 2;
  int generated_number = 0;
  std::array<std::array<int, number_of_attempts>, end_test_number> numbers_generated_by_attempt = {{0}};

  for(int number = 0; number < end_test_number; number++)
  {
    for(int a = 0; a < number_of_attempts; a++)
    {
      gen.add_range(begin_test_number, number+1);
      numbers_generated_by_attempt[number][a] = gen.get_number();
    }
  }

  for(int number = 0; number < end_test_number; number++)
  {
    std::vector<int> unique_occurrences;
    int count_delta_on_generated_numbers = 0;

    unique_occurrences.push_back(numbers_generated_by_attempt[number][0]);
    for(int a = 1; a < number_of_attempts; a++)
    { // Add generated number to unique_occurrences if it is not in there already
      if(std::find(unique_occurrences.begin(), unique_occurrences.end(), numbers_generated_by_attempt[number][a]) == unique_occurrences.end())
      {
        unique_occurrences.push_back(numbers_generated_by_attempt[number][a]);
      }
      if(numbers_generated_by_attempt[number][a-1] != numbers_generated_by_attempt[number][a])
      {
        count_delta_on_generated_numbers++;
      }
    }
    ASSERT_GT(count_delta_on_generated_numbers, number*portion_of_delta); // Checks if there is enough variation
    ASSERT_EQ(unique_occurrences.size(), number+number_shift_on_array);  // Checks if all possible numbers are generated
  }
}


int main(int argc, char** argv)
{
  InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}

