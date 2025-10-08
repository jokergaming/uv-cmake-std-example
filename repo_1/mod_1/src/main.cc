#include <iostream>
#include <mod_1_1/mod_1_1.hh>
#include <mod_1_1/mod_1_1_extra.hh>
#include <mod_1_2/mod_1_2.hh>

#include <mod_2/mod_2.hh>

int main()
{
    std::cout << "Executing mod_1" << std::endl;
    print_mod_1_1();
    print_mod_1_2();
    std::cout << "Done mod_1" << std::endl;

    std::cout << "Executing repo_2" << std::endl;
    print_mod_2();
    std::cout << "Done repo_2" << std::endl;
    return 0;
}
