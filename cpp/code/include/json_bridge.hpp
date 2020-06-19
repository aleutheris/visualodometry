#ifndef __json_bridge_h__
#define __json_bridge_h__

#include "json.hpp"
#include "pixels_generator.hpp"

using json = nlohmann::json;


class JsonBridge
{
public:
  JsonBridge();
  ~JsonBridge();

  json to_json(ImageDimensions imagedimensions);
  json to_json(std::vector<ImageDimensions> imagepixels);
};

#endif
