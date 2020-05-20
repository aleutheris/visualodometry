#include <cstdlib>


#include "pixels_generator_cbridge.h"
#include "pixels_generator.hpp"

#ifdef __cplusplus
extern "C" {
#endif


void pixelsgenerator_generate_simple(int* image_dimensions_array,
                                     int number_of_pixels_to_generate,
                                     int* pixels_coordinates)
{
  PixelsGenerator pixelsgenerator;
  std::vector<ImageDimensions> pixels_coordinates_cpp;
  ImageDimensions image_dimensions_struct;
  int* pixels_coordinates_x = pixels_coordinates;
  int* pixels_coordinates_y = pixels_coordinates + number_of_pixels_to_generate;


  image_dimensions_struct.x = image_dimensions_array[image_x_index];
  image_dimensions_struct.y = image_dimensions_array[image_y_index];

  pixels_coordinates_cpp = pixelsgenerator.generate_simple(image_dimensions_struct, number_of_pixels_to_generate);

  for(std::vector<ImageDimensions>::iterator it = pixels_coordinates_cpp.begin(); it != pixels_coordinates_cpp.end(); it++)
  {
    *pixels_coordinates_x = (*it).x;
    *pixels_coordinates_y = (*it).y;

    pixels_coordinates_x++;
    pixels_coordinates_y++;
  }
}


#ifdef __cplusplus
}
#endif
