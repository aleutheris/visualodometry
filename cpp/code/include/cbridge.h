#ifndef __cbridge_h__
#define __cbridge_h__


int* create_array(int m);
int** create_multi_array(int m, int n);

void destroy_array(int* array);
void destroy_multi_array(int** multi_array, int length1);


#endif
