#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <math.h>
#include "pilib.h"
#include <iostream>
#include <chrono>
#include <unistd.h>

#define LENGTH 1000  // LENGTH = decimals +2 (because "3." is 2 digits)


int main(int argc, char * argv[]){
    char file_name[50] = "pi1M.txt";
    int real_pi[LENGTH];
    int calculated_pi[LENGTH];
    for (int i=0; i<LENGTH; i++){
        calculated_pi[i] = 0;
    }
    // reading file containing real digits of pi (from the internet)
    read_file(file_name,LENGTH,real_pi);
    
    // display real digits of pi
    printf("Real digits of PI       : ");
    display_int_array_char(real_pi,LENGTH);

    // calculation of pi   
    auto start = std::chrono::steady_clock::now();
    spigot_pi(calculated_pi,LENGTH); 
    auto end = std::chrono::steady_clock::now();

    // adapt calculated_pi array
    adapt_for_compare(calculated_pi,LENGTH);

    // display calculated digits of PI with colorful comparison
    printf("Calculated digits of PI : ");
    int digits_before_mistake = compare(calculated_pi,real_pi,LENGTH);
    if (digits_before_mistake == 0){
        printf("Every digit has the good value !\n");
    }
    else{
        printf("Digits before mistake   : %d\n", digits_before_mistake);
    }
    std::cout << "Elapsed time in milliseconds: "
        << std::chrono::duration_cast<std::chrono::milliseconds>(end - start).count()
        << " ms" << std::endl;
    return 0;
}