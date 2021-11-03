#include <iostream>
#include <vector>
#include <algorithm> 

void output_vector(const std::string& title, const std::vector<int32_t>& vec) {
    std::cout << title << std::endl;

    // Iterate over items and print them to console 
    for (int32_t number:vec) {
        std::cout << "Number: " << number << std::endl;
    }
}

int main()
{
    std::cout << "C++: Lambda expresssions" << std::endl;

    // Create Vector 
    std::vector<int32_t> vec = { 100, 77, 345, 10, 50};
    
    output_vector("Before erase", vec);

    // TODO: Erase with condition: Number > ??? 
    int32_t max = 60;

    vec.erase(
        std::remove_if(vec.begin(), vec.end(),

        [max](int32_t number) { return (number > max); }
        )
        , vec.end()
     );
    output_vector("After erase", vec);

    return 0; 
}