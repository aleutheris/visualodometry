#ifndef __generator_h__
#define __generator_h__


class Generator
{
public:
  Generator(int min, int max);
  Generator();
  ~Generator();
  int add_range(int min, int max);
  int get_number();

  //TODO: remove
  int get_sum(int min, int max);

private:
  int _min = 0;
  int _max = 0;
};

#endif
