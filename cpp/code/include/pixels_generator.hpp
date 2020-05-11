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
  std::vector<ImageDimensions> generate_simple(ImageDimensions image_dimensions, int number_of_pixels);

  int find_generated_pixel(std::vector<ImageDimensions> pixels, int pixel_coordinate_x, int pixel_coordinate_y);

private:
  std::vector<ImageDimensions> _pixels_generated_simple;
};
