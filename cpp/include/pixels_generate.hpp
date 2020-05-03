
typedef struct _ImageDimensions
{
  int x;
  int y;
} ImageDimensions;


class PixelsGenerate
{
public:
  int get_sum(int number1, int number2);
  int generate_simple(ImageDimensions image_dimensions, int number_of_pixels);
};
