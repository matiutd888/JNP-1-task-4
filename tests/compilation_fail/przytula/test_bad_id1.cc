#include "computer.h"
#include <array>
#include <iostream>

/*
 * Tests by Wojciech Przytuła
 * All rights left
 * */

using test_machine = Computer<4, int>;

// tests that should not compile (i.e. template parsing error):

using test_bad_id1 = Program<
Label<Id("%")>>;

int main() {

}