#include <cstdlib>
#include <ctime>

#include "pixels_generator.hpp"


// Within the margin there will not be pixels generated
const int margin_size = 3;


int PixelsGenerator::get_sum(int number1, int number2)
{
  return number1 + number2;
}

int PixelsGenerator::generate_simple(ImageDimensions image_dimensions,
                                     int number_of_pixels_to_generate)
{
  int image_generation_x = image_dimensions.x - (margin_size * 2);
  int image_generation_y = image_dimensions.y - (margin_size * 2);
  int image_generation_min_x = 0;
  int image_generation_min_y = 0;
  int image_generation_max_x = image_generation_x;
  int image_generation_max_y = image_generation_y;
  ImageDimensions pixel_aux = {0, 0};


  /* Makes sure that the number of pixels to generate is not higher *
   * than the number of the image available pixels                  */
  if(number_of_pixels_to_generate < image_generation_x * image_generation_y)
  {
    for(int i = 0; i < number_of_pixels_to_generate; i++)
    {
      do
      {
        generate_pixel(pixel_aux, image_generation_min_x,
                                  image_generation_max_x,
                                  image_generation_min_y,
                                  image_generation_max_y);
      } while(find_generated_pixel(this->_pixels_generated_simple, pixel_aux.x, pixel_aux.y) > 0);

      this->_pixels_generated_simple.push_back(pixel_aux);
    }
  }

  return 0;
}


ImageDimensions PixelsGenerator::generate_pixel(ImageDimensions& pixel, int min_x, int max_x, int min_y, int max_y)
{
  pixel.x = generante_random_number(min_x, max_x);
  pixel.y = generante_random_number(min_y, max_y);

  return pixel;
}

int PixelsGenerator::find_generated_pixel(std::vector<ImageDimensions> pixels, int pixel_coordinate_x, int pixel_coordinate_y)
{
  int result = 0;

  for(std::vector<ImageDimensions>::iterator it = pixels.begin(); it != pixels.end(); it++)
  {
    if(pixel_coordinate_x == (*it).x && pixel_coordinate_y == (*it).y)
    {
      result = true;
      break;
    }
  }

  return result;
}

// Add this function to common code
int PixelsGenerator::generante_random_number(int min, int max)
{
  srand((unsigned) time(0));
  return (rand() % (max - min + 1)) + min;
}
