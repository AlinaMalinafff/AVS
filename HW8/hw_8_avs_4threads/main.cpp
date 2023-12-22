#include <iostream>
#include <vector>
// многопоточная программа, вычисляющую векторное произведение
// для двух векторов одинаковой длины
// Каждый вектор содержит не менее 10000000 чисел с плавающей точкой двойной точности (double)
// Для выполнения программы использовать не менее четырех потоков
// Зафиксировать время выполнения программы и сравнить его с временем выполнения той же программы в однопоточном режиме.

const unsigned int vector_size = 10000000;

std::vector<double> A;
std::vector<double> B;

//const int number_of_threads = 1;
const int number_of_threads = 4;

void* func(void* param) {
    unsigned int shift = vector_size / number_of_threads; // Смещение в потоке для начала массива
    int p = (*(int*)param)*shift;
    double *sum = new double;
    for(unsigned int i = p ; i < p+shift ; i++) {
        A.push_back(i + 1);
        B.push_back(vector_size - i);
        *sum+= A[i] * B[i];
    }
    return (void*)sum;
}

int main() {
    double final_result = 0.0;

    pthread_t thread[number_of_threads];
    int number[number_of_threads];
    double *iter_result;

    clock_t time_start = clock();
    for (int i = 0; i < number_of_threads; ++i) {
        number[i] = i;
        pthread_create(&thread[i], nullptr, func, (void*)(number+i));
    }
    for (int i = 0; i < number_of_threads; ++i) {
        pthread_join(thread[i], (void**)&iter_result);
        final_result += *iter_result;
    }
    clock_t time_stop = clock();
    auto final_time = time_stop - time_start;
    std::cout << "result from formula: " << final_result <<
        ", it took time: " << final_time;
}
