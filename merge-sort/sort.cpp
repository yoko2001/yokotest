#include <random>
#include <iostream>
#include <algorithm>
#include <assert.h>
#include <vector>
#include <chrono>
using namespace std;

void merge(int* array, int left, int middle, int right) {
    int n1 = middle - left + 1;
    int n2 = right - middle;

    // Create temp arrays
    int* L = new int[n1];
    int* R = new int[n2];

    // Copy data to temp arrays
    for (int i = 0; i < n1; i++)
        L[i] = array[left + i];
    for (int j = 0; j < n2; j++)
        R[j] = array[middle + 1 + j];

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
    delete[] L;
    delete[] R;
}

void mergeSort(int* array, int left, int right) {
    if (left < right) {
        int middle = left + (right - left) / 2;

        mergeSort(array, left, middle);
        mergeSort(array, middle + 1, right);

        merge(array, left, middle, right);
    }
}

int main()
{
    mt19937 random_gen(std::random_device{}());
    int array_size = (int)1e8;
    int *init_array = new int[array_size];
    int left = 0;
    int right = array_size - 1;  
    for(int i = 0; i < array_size; i++)
    {
        init_array[i] = random_gen();
    }
    auto start = std::chrono::high_resolution_clock::now();
    mergeSort(init_array, left, right);
    auto end = std::chrono::high_resolution_clock::now();
    assert(is_sorted(init_array, init_array + array_size));
    cout << "array is sorted" << endl;
    std::chrono::duration<double> duration = end - start;
    std::cout << "Execution time: " << duration.count() << " seconds" << std::endl;
    delete[] init_array;
    return 0;
}

