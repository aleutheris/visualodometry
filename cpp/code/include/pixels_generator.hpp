#ifndef __pixels_generator_h__
#define __pixels_generator_h__

#include <vector>

typedef struct _ImageDimensions
{
  int x;
  int y;
} ImageDimensions;


class PixelsGenerator
{
public:
  PixelsGenerator();
  ~PixelsGenerator();
  std::vector<ImageDimensions> generate_simple(ImageDimensions image_dimensions, int number_of_pixels);

  int find_generated_pixel(std::vector<ImageDimensions> pixels, int pixel_coordinate_x, int pixel_coordinate_y);

  //TODO: remove
  int get_sum(int min, int max);

private:
  std::vector<ImageDimensions> _pixels_generated_simple;
};

#endif
