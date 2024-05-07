#include <random>
#include <iostream>
#include <algorithm>
#include <assert.h>
#include <vector>
#include <chrono>
#include <sys/mman.h>

using namespace std;
#define PAGESIZE 4096
#define __USE_MADVISE__

// void va_range_lowprio(char* base, size_t size){
//     madvise(base, size, 27);
// }
// void array_range_highprio(int* array, int left, int right) {
//     int* left_ptr = &array[left];
//     int* right_ptr = &array[right];
//     char* front = reinterpret_cast<char*>(((unsigned long)left_ptr + PAGESIZE >> 12 ) << 12);
//     char* end = reinterpret_cast<char*>(((unsigned long)right_ptr >> 12 ) << 12);
//     return va_range_lowprio(front, (size_t)(front - end));
// }

void merge(int* array, int left, int middle, int right, int* swap) {
    int n1 = middle - left + 1;
    int n2 = right - middle;

    // Create temp arrays
    int* L = swap;
    int* R = &array[n1];
    // Copy data to temp arrays
    for (int i = 0; i < n1; i++)
        L[i] = array[left + i];
    // cout << "merge: " << left << "-" << middle << "-" << right << endl; 
    // Merge the temp arrays back into array[left..right]
    int i = 0;
    int j = 0;
    int k = left;
    while (i < n1 && j < n2) {
        if (L[i] <= R[j]) {
            array[k] = L[i];
            i++;
        } else {
            array[k] = R[j];
            j++;
        }
        k++;
    }
    // cout << "main merge ok" << endl;
    // Copy the remaining elements of L, if any
    while (i < n1) {
        array[k] = L[i];
        i++;
        k++;
    }

    // Copy the remaining elements of R, if any
    while (j < n2) {
        array[k] = R[j];
        j++;
        k++;
    }

    // Free the memory allocated for temp arrays
    // delete[] L;
}

void mergeSort(int* array, int left, int right, int* swap) {
    bool usemad = false;
    if (right - left > 50) {
        int middle = left + (right - left) / 2;
#ifdef __USE_MADVISE__
        if (right - left > 1e8) 
            usemad = true;
#endif
        if (usemad){
            int _start = (middle / 1024) * 1024;
            if (madvise((array + _start), ((right - middle) * 4 / PAGESIZE) * PAGESIZE, 27)){
                exit(-1);
            }
        }
        mergeSort(array, left, middle, swap);
        if (usemad){
            int _start = (left / 1024) * 1024;
            if (madvise(array + _start ,  ((middle - left) * 4 / PAGESIZE) * PAGESIZE, 27)){
                exit(-1);
            }
            _start = (middle / 1024) * 1024;
            if (madvise((array + _start), ((right - middle) * 4 / PAGESIZE) * PAGESIZE, 26)){
                exit(-1);
            }
        }
        mergeSort(array, middle + 1, right, swap);
        if (usemad){
            int _start = (left / 1024) * 1024;
            if (madvise(array + _start ,  ((middle - left) * 4 / PAGESIZE) * PAGESIZE, 26)){
                exit(-1);
            }
        }
        merge(array, left, middle, right, swap);
#ifdef __USE_MADVISE__
        if (usemad){
            if (madvise(swap + left ,  ((middle - left) * 4 / PAGESIZE) * PAGESIZE, 27)){
                exit(-1);
            }            
        }
#endif
    }
    else {
        sort(array + left, array+right+1);
    }
}

int main()
{
    mt19937 random_gen(std::random_device{}());
    int array_size = (((int)2048e5 * 4 / PAGESIZE) * PAGESIZE) / 4;
    void* base, *base_tmp;
    posix_memalign(&base,PAGESIZE, array_size*4+PAGESIZE);
    posix_memalign(&base_tmp,PAGESIZE, array_size*2+PAGESIZE); //swap space
    int *init_array = (int*)base;
    int *swap_array = (int*)base_tmp;
    int left = 0;
    int right = array_size - 1;  
    int _start = 0;
    cout << array_size << " " << _start << " " << swap_array << " " << swap_array + _start << endl;

    for (int i = 0; i < array_size / 2; i++){
        swap_array[i] = 0;
    }
    // _start = ((array_size / 4) / PAGESIZE) * PAGESIZE;
#ifdef __USE_MADVISE__
    _start = 0;
    if (madvise(swap_array + _start ,  ((array_size) * 2 / PAGESIZE) * PAGESIZE, 27)){
        exit(-1);
    }
#endif
    for(int i = 0; i < array_size; i++)
    {
        init_array[i] = random_gen();
    }
    cout << "array starts sorting" << endl;
    auto start = std::chrono::high_resolution_clock::now();
    mergeSort(init_array, left, right, swap_array);
    auto end = std::chrono::high_resolution_clock::now();
    assert(is_sorted(init_array, init_array + array_size));
    cout << "array is sorted" << endl;
    std::chrono::duration<double> duration = end - start;
    std::cout << "Execution time: " << duration.count() << " seconds" << std::endl;
    // delete[] init_array;
    return 0;
}

