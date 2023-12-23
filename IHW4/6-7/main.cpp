#include <iostream>
#include <pthread.h>
#include <vector>
#include <algorithm>
#include <unistd.h>

// глоабльные переменные: количество ридеров, райтеров и размер датабазы
int readers_num;
int writers_num;
const int db_size = 10;

// вещи, необходимые для потоков
// мьютекс, чтоб контролировать доступ к БД
pthread_mutex_t availabitity_mutex = PTHREAD_MUTEX_INITIALIZER;
// чтоб разрешать параллельный доступ к БД для нескольких ридеров и запрещать параллели при записи, блокировка чтения и записи
pthread_rwlock_t rwlock = PTHREAD_RWLOCK_INITIALIZER;
// условная переменная для ридеров
pthread_cond_t for_readers = PTHREAD_COND_INITIALIZER;

// составная часть БД: некое что-то, что хранит индекс и значение
struct Record{
    int index;
    int value;
};

// сама БД рекорд сущностей
std::vector<Record> database(db_size);

// для контроля ридеров
int reader_counter = 0;

// дочерняя функция для потока по типу ридера
void* Reader(void* arg) {
    int reader_id = *((int*)arg); // индекс потока

    // локальный генератор, чтоб у потоков были разные рандомные значения
    time_t timer;
    int local_seed = time(&timer) + reader_id;
    srand(local_seed);

    while (true) {
        // рандомная пауза для потока
        usleep(200000 + rand() % 200000);

        // блокировка чтения, чтоб обеспечить параллельное чтение
        pthread_rwlock_rdlock(&rwlock);

        // рандомный выбор ячейки и её значение
        int index = rand() % db_size;
        int value = database[index].value;

        // БД в наших руках пока не наступит очередь нашего ридера писать в консоль
        // шаманство с reader_id и reader_counter как раз предназначено для
        // менеджмента вывода данных в консоль ридерами
        // потому что до создания этой системы менеджмента, так как потоки
        // параллельные и работают параллельно, происходили случаи, когда
        // на одной строчке пытались написать протоколы несколько ридеров
        // и пот итогу в строке было понамешано несколько выводов разных потоков
        // и это было невозможно читать
        pthread_mutex_lock(&availabitity_mutex);
        while (reader_id != reader_counter) {
            pthread_cond_wait(&for_readers, &availabitity_mutex);
        }
        // инфа о пакостях ридера в консоль
        std::cout << "Reader " << reader_id << ": Read record at index " << index << " = " << value << std::endl;

        // продолжение менеджмента ридеров
        if (++reader_counter >= readers_num) {
            reader_counter = 0; // Reset reader counter
        }
        // уведомляем других ридеров
        pthread_cond_broadcast(&for_readers);
        // открываем доступ к БД
        pthread_mutex_unlock(&availabitity_mutex);
        // снимаем рид-онли блокировки
        pthread_rwlock_unlock(&rwlock); // Release read lock
        // обнуление каунтера ридеров, чтоб они снова могли писать в консоли
        if (reader_id == readers_num - 1) {
            reader_counter = 0;
        }
    }
    return nullptr;
}

// дочерняя функция для потоков по типу райтера
void* Writer(void* arg) {
    int writer_id = *((int*)arg); // индекс потока

    // настройка локального генератора, чтоб для каждого потока были свои рандомные значения
    time_t timer;
    int local_seed = time(&timer)+writer_id;
    srand(local_seed);

    while (true) {
        // пауза потока райтера
        usleep(300000 + rand() % 300000);

        // эксклюзивный исключительный доступ одного потока райтера к БД
        pthread_mutex_lock(&availabitity_mutex);

        // обновление значения в рандомном рекорде
        int index = rand() % db_size;
        int new_value = rand() % 100;
        int old_value = database[index].value;
        database[index].value = new_value;

        // протокол пакости райдера в консоль
        std::cout << "Writer " << writer_id << ": Updated record at index " << index << " from " << old_value << " to " << new_value << std::endl;

        // открытие доступа к БД
        pthread_mutex_unlock(&availabitity_mutex);
    }
    return nullptr;
}

int main(int argc, char* argv[]) {
    // общий сид для генерации рандомов
    srand(time(nullptr));

    // ввод данных из командной строки
    if (argc < 2) {
        std::cout << "incorrect input";
        return 0;
    }
    readers_num = std::stoi(argv[1]);
    writers_num = std::stoi(argv[2]);

    // создание потоков ридеров
    std::vector<pthread_t> reader_threads(readers_num);
    std::vector<int> reader_iter(readers_num);
    for (int i = 0; i < readers_num; i++) {
        reader_iter[i] = i;
        pthread_create(&reader_threads[i], NULL, Reader, &reader_iter[i]);
    }

    // создание потоков райтеров
    std::vector<pthread_t> writer_threads(writers_num);
    std::vector<int> writer_iter(writers_num);
    for (int i = 0; i < writers_num; i++) {
        writer_iter[i] = i;
        pthread_create(&writer_threads[i], NULL, Writer, &writer_iter[i]);
    }

    // пока все ридеры не отработают
    for (int i = 0; i < readers_num; i++) {
        pthread_join(reader_threads[i], NULL);
    }

    // пока все райтеры не отработают
    for (int i = 0; i < writers_num; i++) {
        pthread_join(writer_threads[i], NULL);
    }

    // конец
    return 0;
}
