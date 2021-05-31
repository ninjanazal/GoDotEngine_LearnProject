#include "test.h"

using namespace godot;

void Test::_register_methods() {
    register_method("_process", &Test::_process);
}

void Test::_init() {
    time_passed = 0.0;

    this->smp = new sample();
}

void Test::_process(float delta) {
    time_passed += delta;
    Vector2 new_position =
        Vector2(10.0 + (10.0 * sin(time_passed * 2.0)), 10.0 + (10.0 * cos(time_passed * 1.5)));

    this->smp->print();
    set_position(new_position);
}