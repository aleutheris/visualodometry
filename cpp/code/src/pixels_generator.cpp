#include "generator.hpp"
#include "pixels_generator.hpp"


// Within the margin there will not be pixels generated
const int margin_size = 3;


PixelsGenerator::PixelsGenerator(){}

PixelsGenerator::~PixelsGenerator(){}

std::vector<ImageDimensions> PixelsGenerator::generate_simple(ImageDimensions image_dimensions,
                                                              int number_of_pixels_to_generate)
{
  int image_generation_x = image_dimensions.x - (margin_size * 2);
  int image_generation_y = image_dimensions.y - (margin_size * 2);
  int image_generation_min_x = 0;
  int image_generation_min_y = 0;
  int image_generation_max_x = image_generation_x;
  int image_generation_max_y = image_generation_y;
  ImageDimensions pixel_aux = {0, 0};
  Generator generator_x;
  Generator generator_y;

  if(number_of_pixels_to_generate > 0 && image_generation_x >=0 && image_generation_y >=0)
  {
    /* Makes sure that the number of pixels to generate is not higher *
     * than the number of the image available pixels                  */
    if(number_of_pixels_to_generate < image_generation_x * image_generation_y)
    {
      for(int i = 0; i < number_of_pixels_to_generate; i++)
      {
        do
        {
          pixel_aux.x = generator_x.add_range(image_generation_min_x, image_generation_max_x);
          pixel_aux.y = generator_y.add_range(image_generation_min_y, image_generation_max_y);
        } while(find_generated_pixel(this->_pixels_generated_simple, pixel_aux.x, pixel_aux.y) > 0);

        this->_pixels_generated_simple.push_back(pixel_aux);
      }
    }
  }

  return this->_pixels_generated_simple;
}

std::vector<ImageDimensions> PixelsGenerator::get_pixels_generated_simple()
{
  return this->_pixels_generated_simple;
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

bool operator==(const ImageDimensions& imagedimensions1, const ImageDimensions& imagedimensions2)
{
  bool result = true;

  result &= imagedimensions1.x == imagedimensions2.x;
  result &= imagedimensions1.y == imagedimensions2.y;

  return result;
}

//TODO: REMOVE
int PixelsGenerator::get_sum(int min, int max)
{
  return min+max;
}
