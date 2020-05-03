#include "pixels_generate.hpp"

// Within the margin there will not be pixels generated
const int margin_size = 6;


int PixelsGenerate::get_sum(int number1, int number2)
{
  return number1 + number2;
}

int PixelsGenerate::generate_simple(ImageDimensions image_dimensions, int number_of_pixels)
{
  int generation_x = image_dimensions.x - margin_size;
  int generation_y = image_dimensions.y - margin_size;

  if(number_of_pixels < generation_x * generation_y)
  {

  }

  return 0;
}
