#include "json_bridge.hpp"


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
