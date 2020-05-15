#ifndef __pixels_generator_cbridge_h__
#define __pixels_generator_cbridge_h__


#ifdef __cplusplus
extern "C" {
#endif

int** pixelsgenerator_generate_simple(int* image_dimensions_array,
                                      int number_of_pixels_to_generate);

int pixelsgenerator_get_sum(int min, int max);

#ifdef __cplusplus
}
#endif

#endif
