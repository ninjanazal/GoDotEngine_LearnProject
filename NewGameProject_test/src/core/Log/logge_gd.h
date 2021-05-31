#ifndef LOGGE_GD_H
#define LOGGE_GD_H

#include <Godot.hpp>

namespace TestApi {
class logge_gd {
   private:
   public:
    logge_gd(){};
    ~logge_gd(){};

    void print() {
        godot::Godot::print("this is a test print");
    }
};

}  // namespace TestApi

#endif