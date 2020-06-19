#include "json_bridge.hpp"

//TODO: remove
#include <iostream>


JsonBridge::JsonBridge(){}

JsonBridge::~JsonBridge(){}

//template <class T>
//T JsonBridge::to_json(T t)
//{
//  return t + 1;
//}
//
//template int JsonBridge::to_json<int>(int);

json JsonBridge::to_json(ImageDimensions imagedimensions)
{
  json result;
  result["x"] = imagedimensions.x;
  result["y"] = imagedimensions.y;
  return result;
}

json JsonBridge::to_json(std::vector<ImageDimensions> pixels)
{
  json result;
  json element;
  std::vector<json> pixels_json;

  for(std::vector<ImageDimensions>::iterator it = pixels.begin(); it != pixels.end(); it++)
  {
    element = to_json(*it);
    pixels_json.push_back(element);
  }

  result["pixels"] = pixels_json;

  return result;
}
