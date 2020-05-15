#include <cstdlib>


#include "pixels_generator_cbridge.h"
#include "pixels_generator.hpp"

#ifdef __cplusplus
extern "C" {
#endif

#include "cbridge.h"

static PixelsGenerator* pixelsgenerator_instance = NULL;

int** pixelsgenerator_generate_simple(int* image_dimensions_array,
                                      int number_of_pixels_to_generate)
{
  std::vector<ImageDimensions> pixels_coordinates_cpp;
  ImageDimensions image_dimensions_struct;
  image_dimensions_struct.x = image_dimensions_array[0];
  image_dimensions_struct.y = image_dimensions_array[1];

  pixels_coordinates_cpp = pixelsgenerator_instance->generate_simple(image_dimensions_struct, number_of_pixels_to_generate);

  //const int size = pixels_coordinates_cpp.size();
  int** pixels_coordinates_c = create_multi_array(2, 600*600);

  int i = 0;
  for(std::vector<ImageDimensions>::iterator it = pixels_coordinates_cpp.begin(); it != pixels_coordinates_cpp.end(); it++)
  {
    pixels_coordinates_c[0][i] = (*it).x;
    pixels_coordinates_c[1][i] = (*it).y;
    i++;
  }

  return pixels_coordinates_c;
}

int pixelsgenerator_get_sum(int min, int max)
{
  return pixelsgenerator_instance->get_sum(min, max);
}

#ifdef __cplusplus
}
#endif
