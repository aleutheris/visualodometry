#include <iostream>
#include <gtest/gtest.h>

#include "pixels_generator.hpp"

using namespace ::testing;


class TestPixelsGenerator : public Test
{
public:
  PixelsGenerator pixelsgenerator;

private:
  virtual void SetUp()
  {
  }

  virtual void TearDown()
  {
  }
};

TEST_F(TestPixelsGenerator, test_find_generated_pixel_all_in)
{
  std::vector<ImageDimensions> pixels;
  std::vector<ImageDimensions> pixels_copy;
  ImageDimensions imagedimensions_aux;
  int pixels_size = 1000;
  int number_of_pixels_found = 0;
  const int no_pixels_found = 0;

  // Fill pixel vector
  for(int i = 1; i <= pixels_size; i++)
  {
    imagedimensions_aux.x = i * 2;
    imagedimensions_aux.y = i * 4;
    pixels.push_back(imagedimensions_aux);
    pixels_copy.push_back(imagedimensions_aux);
  }

  for(std::vector<ImageDimensions>::iterator it = pixels_copy.begin(); it != pixels_copy.end(); it++)
  {
    number_of_pixels_found = pixelsgenerator.find_generated_pixel(pixels, (*it).x, (*it).y);
    ASSERT_GT(number_of_pixels_found, 0);
  }
}

TEST_F(TestPixelsGenerator, test_find_generated_pixel_no_pixel_in)
{
  std::vector<ImageDimensions> pixels;
  std::vector<ImageDimensions> pixels_comparator;
  ImageDimensions imagedimensions_aux;
  int pixels_size = 4;
  int number_of_pixels_found = 0;
  const int no_pixels_found = 0;

  // Fill pixel vector
  for(int i = 1; i <= pixels_size; i++)
  {
    imagedimensions_aux.x = i * 2;
    imagedimensions_aux.y = i * 4;
    pixels.push_back(imagedimensions_aux);
  }

  // Fill comparator vector
  imagedimensions_aux.x = -1;
  imagedimensions_aux.y = -1;
  pixels_comparator.push_back(imagedimensions_aux);

  imagedimensions_aux.x = 0;
  imagedimensions_aux.y = 0;
  pixels_comparator.push_back(imagedimensions_aux);

  imagedimensions_aux.x = 9999;
  imagedimensions_aux.y = 0;
  pixels_comparator.push_back(imagedimensions_aux);

  imagedimensions_aux.x = 0;
  imagedimensions_aux.y = 9999;
  pixels_comparator.push_back(imagedimensions_aux);

  for(std::vector<ImageDimensions>::iterator it = pixels_comparator.begin(); it != pixels_comparator.end(); it++)
  {
    number_of_pixels_found = pixelsgenerator.find_generated_pixel(pixels, (*it).x, (*it).y);
    ASSERT_EQ(number_of_pixels_found, no_pixels_found);
  }
}

TEST_F(TestPixelsGenerator, test_generate_simple_size_good_weather)
{
  PixelsGenerator pixelsgenerator;
  std::vector<ImageDimensions> pixels_local;
  std::vector<ImageDimensions> pixels_object;
  ImageDimensions image_dimensions;
  const int number_of_pixels_to_generate = 10;

  image_dimensions.x = 40;
  image_dimensions.y = 30;

  pixels_local = pixelsgenerator.generate_simple(image_dimensions, number_of_pixels_to_generate);
  pixels_object = pixelsgenerator.get_pixels_generated_simple();

  ASSERT_EQ(pixels_local, pixels_object);
  ASSERT_EQ(pixels_local.size(), number_of_pixels_to_generate);
}

TEST_F(TestPixelsGenerator, test_generate_simple_size_bad_weather)
{
  std::vector<ImageDimensions> pixels;
  ImageDimensions image_dimensions;
  PixelsGenerator pixelsgenerator;
  int number_of_pixels_to_generate = 0;

  number_of_pixels_to_generate = -1;
  image_dimensions.x = 40;
  image_dimensions.y = 30;
  pixels = pixelsgenerator.generate_simple(image_dimensions, number_of_pixels_to_generate);
  ASSERT_EQ(pixels.size(), 0);
  pixels.clear();

  number_of_pixels_to_generate = 10;
  image_dimensions.x = 40;
  image_dimensions.y = -1;
  pixels = pixelsgenerator.generate_simple(image_dimensions, number_of_pixels_to_generate);
  ASSERT_EQ(pixels.size(), 0);
  pixels.clear();

  number_of_pixels_to_generate = 10;
  image_dimensions.x = -1;
  image_dimensions.y = 30;
  pixels = pixelsgenerator.generate_simple(image_dimensions, number_of_pixels_to_generate);
  ASSERT_EQ(pixels.size(), 0);
  pixels.clear();

  number_of_pixels_to_generate = 10;
  image_dimensions.x = -1;
  image_dimensions.y = -1;
  pixels = pixelsgenerator.generate_simple(image_dimensions, number_of_pixels_to_generate);
  ASSERT_EQ(pixels.size(), 0);
  pixels.clear();
}

TEST_F(TestPixelsGenerator, test_generate_simple_valid_range)
{
  PixelsGenerator pixelsgenerator;
  std::vector<ImageDimensions> pixels;
  ImageDimensions image_dimensions;
  int number_of_pixels_to_generate = 10;

  image_dimensions.x = 40;
  image_dimensions.y = 30;

  pixels = pixelsgenerator.generate_simple(image_dimensions, number_of_pixels_to_generate);

  for(std::vector<ImageDimensions>::iterator it = pixels.begin(); it != pixels.end(); it++)
  {
    ASSERT_GE((*it).x, 0);
    ASSERT_GE((*it).y, 0);
    ASSERT_LT((*it).x, image_dimensions.x);
    ASSERT_LT((*it).y, image_dimensions.y);
  }
}

TEST_F(TestPixelsGenerator, test_generate_simple_coordinates_diversity)
{
  PixelsGenerator pixelsgenerator;
  std::vector<ImageDimensions> pixels;
  ImageDimensions image_dimensions;
  int number_of_pixels_to_generate = 10;
  int same_pixel_count = 0;

  image_dimensions.x = 40;
  image_dimensions.y = 30;

  pixels = pixelsgenerator.generate_simple(image_dimensions, number_of_pixels_to_generate);

  for(std::vector<ImageDimensions>::iterator it1 = pixels.begin(); it1 != pixels.end(); it1++)
  {
    for(std::vector<ImageDimensions>::iterator it2 = pixels.begin(); it2 != pixels.end(); it2++)
    {
      if(*it1 == *it2)
      {
        same_pixel_count++;
        ASSERT_EQ(same_pixel_count, 1);
      }
    }
    same_pixel_count = 0;
  }
}


int main(int argc, char** argv)
{
  InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}
