#include <vector>

typedef struct _ImageDimensions
{
  int x;
  int y;
} ImageDimensions;


class PixelsGenerator
{
public:
  int get_sum(int number1, int number2);
  int generate_simple(ImageDimensions image_dimensions, int number_of_pixels);

  ImageDimensions generate_pixel(ImageDimensions& pixel, int min_x, int max_x, int min_y, int max_y);
  int find_generated_pixel(std::vector<ImageDimensions> pixels, int pixel_coordinate_x, int pixel_coordinate_y);
  int generante_random_number(int min, int max);

private:
  std::vector<ImageDimensions> _pixels_generated_simple;
};
