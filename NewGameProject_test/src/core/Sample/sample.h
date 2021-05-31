#ifndef SAMPLE_H
#define SAMPLE_H

#include "logge_gd.h"

namespace godot {
class sample {
   private:
    TestApi::logge_gd* log;

   public:
    sample() { log = new TestApi::logge_gd(); };
    ~sample(){};

    void print();
};
}  // namespace godot

#endif