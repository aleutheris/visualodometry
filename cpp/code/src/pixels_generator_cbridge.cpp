#include <cstdlib>


#include "pixels_generator_cbridge.h"
#include "pixels_generator.hpp"

#ifdef __cplusplus
extern "C" {
#endif

#include "cbridge.h"

//TODO: create a create and destroy methods
static PixelsGenerator pixelsgenerator;

int** pixelsgenerator_generate_simple(int* image_dimensions_array,
                                      int number_of_pixels_to_generate)
{
  std::vector<ImageDimensions> pixels_coordinates_cpp;
  ImageDimensions image_dimensions_struct;

  image_dimensions_struct.x = image_dimensions_array[x_index];
  image_dimensions_struct.y = image_dimensions_array[y_index];

  pixels_coordinates_cpp = pixelsgenerator.generate_simple(image_dimensions_struct, number_of_pixels_to_generate);

  const int size = pixels_coordinates_cpp.size();
  int** pixels_coordinates_c = create_multi_array(number_of_dimensions, size);

  int i = 0;
  for(std::vector<ImageDimensions>::iterator it = pixels_coordinates_cpp.begin(); it != pixels_coordinates_cpp.end(); it++)
  {
    pixels_coordinates_c[x_index][i] = (*it).x;
    pixels_coordinates_c[y_index][i] = (*it).y;
    i++;
  }

  return pixels_coordinates_c;
}

int pixelsgenerator_get_sum(int min, int max)
{
  return pixelsgenerator.get_sum(min, max);
}

#ifdef __cplusplus
}
#endif
