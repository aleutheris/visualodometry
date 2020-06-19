#include <iostream>

#include "json_bridge.hpp"
#include "pixels_generator.hpp"


int main(int argc, char *argv[])
{
  int error = 0;

  if(argc == 4)
  {
    json j;
    JsonBridge jb;
    PixelsGenerator pixelsgenerator;
    ImageDimensions image_dimensions;
    image_dimensions.x = atoi(argv[1]);
    image_dimensions.y = atoi(argv[2]);
    int number_of_pixels_to_generate = atoi(argv[3]);

    std::vector<ImageDimensions> pixels_local = pixelsgenerator.generate_simple(image_dimensions, number_of_pixels_to_generate);

    j = jb.to_json(pixels_local);

    std::cout << j.dump() << std::endl;

    error = 0;
  }
  else
  {
    error = 1;
  }

  return error;
}
