#ifndef __pixels_generator_h__
#define __pixels_generator_h__

#include <vector>

typedef struct _ImageDimensions
{
  int x;
  int y;
} ImageDimensions;

bool operator==(const ImageDimensions& imagedimensions1, const ImageDimensions& imagedimensions2);


const int x_index = 0;
const int y_index = 1;
const int number_of_dimensions = 2;


class PixelsGenerator
{
public:
  PixelsGenerator();
  ~PixelsGenerator();
  std::vector<ImageDimensions> generate_simple(ImageDimensions image_dimensions, int number_of_pixels);
  std::vector<ImageDimensions> get_pixels_generated_simple();

  int find_generated_pixel(std::vector<ImageDimensions> pixels, int pixel_coordinate_x, int pixel_coordinate_y);

  //TODO: remove
  int get_sum(int min, int max);

private:
  std::vector<ImageDimensions> _pixels_generated_simple;
};

#endif
