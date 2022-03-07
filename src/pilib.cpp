#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <math.h>
#include <stdint.h>
#include "pilib.h"
#define DEBUG 0

int * read_file(char file_name[50], int decimals, int pidecimals[]){
    int count_iterations = 0;
    FILE * file = fopen(file_name,"r");
    int x = fgetc(file);
    while(x!=EOF && count_iterations < decimals){
        //process
        pidecimals[count_iterations] = x;
        count_iterations++;
        //acquire next char
        x=fgetc(file);
    }
    fclose(file);
    return pidecimals;
}

int display_int_array_char(int * array, int array_size){
    for(int i=0; i<array_size; i++){
        printf("%c",array[i]);
    }
    printf("\n");
    return 0;
}

int display_int_array_int(int * array, int array_size){
    for(int i=0; i<array_size; i++){
        printf("%d",array[i]);
    }
    printf("\n");
    return 0;
}

void green(){
    printf("\033[0;32m");
}

void red(){
    printf("\033[0;31m");
}

void white(){
    printf("\033[0;37m");
}

int compare(int * calculated_pi, int * real_pi, int array_size){
    int digits_before_mistake = 0;
    int still_true = 1;
    for(int i=0; i<array_size; i++){
        if(calculated_pi[i] != real_pi[i]){
            red();
            still_true = 0;
        }
        else{
            if(still_true==1){ digits_before_mistake++;}
            green();
        }
        printf("%c",calculated_pi[i]);
    }
    white();
    printf("\n");
    if(still_true==1){
        return 0;                               // case where no mistake is detected 
    }
    return digits_before_mistake-1;             // -1 because of the '.'
}

int * multiply_array(int array [], int array_size, int coeff){
    for(int i=0; i<array_size; i++){
        array[i] = array[i]*coeff;
    }
    return array;
}

int * spigot_pi(int pidecimals[], int number_of_digits){
    int i, array_size, quotient, remainder, carry, nine_before, coeff_up, coeff_down;
    int quotients[number_of_digits];
    nine_before = 0;
    array_size = floor(10*number_of_digits/3);
    int A[array_size];
    carry = 0; quotient = 0; remainder = 0;
    
    for(int j=0; j<number_of_digits;j++){
        // init A array
        if(j==0){
            for (i=0; i<array_size; i++){
                A[i] = 2;
            }
        }
        multiply_array(A, array_size, 10);
        carry = 0; quotient = 0; remainder = 0;   

        for(int k=0; k<array_size; k++){
            i = array_size - k;
            if(i!=1){  
                coeff_up   = i-1;
                coeff_down = 2*i-1;
                quotient = (A[i-1]+carry) / coeff_down;
                remainder = (A[i-1]+carry) % coeff_down;
                carry = quotient*coeff_up;
                A[i-1] = remainder;
                if(DEBUG){
                    printf("i : %d | next A[i-1] : %d | coeff_up : %d | coeff_down : %d | quotient : %d | remainer : %d | carry : %d\n", i ,A[i-1] , coeff_up ,coeff_down ,quotient ,remainder ,carry );
                }
            }
            else{
                quotient = (A[i-1]+carry) / 10;
                remainder = (A[i-1]+carry) % 10;
                A[i-1] = remainder;
                if(DEBUG==1){
                    printf("i : %d | next A[i-1] : %d | quotient (donc digit) : %d\n\n", i, A[i-1], quotient);
                }
                if(quotient == 9){
                    nine_before++;
                    pidecimals[j] = quotient;
                }
                else if(quotient == 10){
                    pidecimals[j]=0;
                    for(int y=0; y<nine_before+1;y++){
                        if(pidecimals[j-y-1]!=9){
                            pidecimals[j-y-1]++;
                        }
                        else{
                            pidecimals[j-y-1]=0;
                        }
                    }
                }
                else{
                    pidecimals[j] = quotient;
                    nine_before = 0;
                }
            }
        }
    }
    return pidecimals;
}

int * adapt_for_compare(int calculated_pi[],int LENGTH){
    int temp_values[LENGTH];
    for(int i=0; i<LENGTH-1; i++){
        temp_values[i]=calculated_pi[i];
    }
    for(int i=0; i<LENGTH; i++){
        if(i==0){
            calculated_pi[0]=calculated_pi[0]+'0';
        }
        if(i==1){
            calculated_pi[1]='.';
        }
        if(i>=2){
            calculated_pi[i]=temp_values[i-1]+'0';
        }
    }
    return calculated_pi;
}

