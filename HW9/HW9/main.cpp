#include <pthread.h>
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <utility>

// создание буфера и счётчика к нему
int buffer[10];
int index = 0;

pthread_mutex_t mutex; // мьютекс
pthread_cond_t not_full; // условная переменная для райтера
pthread_cond_t has_two; // условная переменная для сумматора

// дочерняя функция для потоков райтеров
void *Writer(void *param) {
    int params = *((int *)param); // индекс
    while (1) {
        // генерация добавляемого числа
        int num_to_add = rand() % 20 + 1;
        pthread_mutex_lock(&mutex); // блокировка доступа
        // больше двух элементов - ждём сумматора
        while (index >= 2) {
            pthread_cond_wait(&not_full, &mutex);
        }
        // записывание в общий буффер нового числа
        buffer[index] = num_to_add;
        // вывод инфы о действии райтера на консоль
        printf("Writer %d: writes value = %d to cell [%d]\n", params, num_to_add, index++);
        // разрешение доступа другим
        pthread_mutex_unlock(&mutex);
        // предупреждение сумматора, что буфер не пуст
        pthread_cond_broadcast(&has_two);
        // пауза потока на рандомное число
        int pause = rand() % 7 + 1;
        usleep(pause);
    }
}

// дочерняя функция сумматора
void *Summator(void *param) {
    int params = *((int *)param); // индекс
    while (1) {
        // блокировка доступа
        pthread_mutex_lock(&mutex);
        // меньше двух элементов - пауза сумматору
        while (index == 0 || index == 1) {
            pthread_cond_wait(&has_two, &mutex);
        }
        // создание пары из элемов и их сумма
        std::pair<int, int> addendums = {buffer[--index], buffer[--index]};
        int sum = addendums.first + addendums.second;
        // сигнал райтеру пополнить буфер
        pthread_cond_broadcast(&not_full);
        // остановка от переполнения буфера числами
        while (index >= 10) {
            pthread_cond_wait(&not_full, &mutex);
        }
        // сумму в буфер
        buffer[index] = sum;
        // вывод инфы о пакости сумматора на консоль
        printf("Summator %d: writes value <%d = %d + %d> to cell [%d]\n", params, sum, addendums.first, addendums.second, index++);
        // разблокировка
        pthread_mutex_unlock(&mutex);
        // сигнал буфер не пуст
        pthread_cond_broadcast(&has_two);
        // пауза для потока на рандомное время
        int pause = rand() % 7 + 1;
        usleep(pause);
    }
}

int main() {
    // создание мьютекса и двух условных перемнных
    pthread_mutex_init(&mutex, NULL) ;
    pthread_cond_init(&not_full, NULL) ;
    pthread_cond_init(&has_two, NULL) ;

    // лист потоков райтеров создаём и сами потоки
    pthread_t writers[20];
    int iter_writers[20];
    for (int i = 0; i < 20; ++i) {
        iter_writers[i] = i + 1;
        pthread_create(&writers[i], NULL, Writer, (void *)(iter_writers + i));
    }

    // лист потоков сумматоров создаём и сами потоки
    pthread_t summators[10];
    int iter_summators[10];
    for (int i = 0; i < 10; ++i) {
        iter_summators[i] = i + 1;
        pthread_create(&summators[i], NULL, Summator, (void *)(iter_summators + i));
    }

    // конец
    pthread_exit(NULL);
}
