
class Generator
{
public:
  Generator(int min, int max);
  Generator();
  ~Generator();
  int add_range(int min, int max);
  int get_number();

private:
  int _min = 0;
  int _max = 0;
};
