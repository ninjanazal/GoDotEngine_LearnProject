#ifndef TEST_H
#define TEST_H

#include <Godot.hpp>
#include <Sprite.hpp>

#include "sample.h"

namespace godot {
class Test : public Sprite {
    GODOT_CLASS(Test, Sprite)

   private:
    float time_passed;
    sample* smp;

   public:
    static void _register_methods();

    Test(){};
    ~Test(){};

    void _init();

    void _process(float delta);
};
}  // namespace godot
#endif