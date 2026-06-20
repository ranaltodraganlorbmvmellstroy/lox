#include <iostream>
#include <cstring>

int main() {
    // Выделяем память. 5 строк по 16 байт = 80 байт.
    // Это гарантирует, что в стандартном hex-редакторе арт не "поедет".
    const size_t ART_SIZE = 80;
    unsigned char* memory_canvas = new unsigned char[ART_SIZE];

    // Шестнадцатеричный паттерн, рисующий "HSE" (символами '*' и пробелами)
    // Каждая строка ровно 16 байт (0x10)
    const unsigned char hex_payload[ART_SIZE] = {
        // H   H SSS EEEEE (Row 1)
        0x2A, 0x20, 0x20, 0x20, 0x2A, 0x20, 0x2A, 0x2A, 0x2A, 0x20, 0x2A, 0x2A, 0x2A, 0x2A, 0x2A, 0x20,
        // H   H S   E     (Row 2)
        0x2A, 0x20, 0x20, 0x20, 0x2A, 0x20, 0x2A, 0x20, 0x20, 0x20, 0x2A, 0x20, 0x20, 0x20, 0x20, 0x20,
        // HHHHH SSS EEEE  (Row 3)
        0x2A, 0x2A, 0x2A, 0x2A, 0x2A, 0x20, 0x2A, 0x2A, 0x2A, 0x20, 0x2A, 0x2A, 0x2A, 0x2A, 0x20, 0x20,
        // H   H   S E     (Row 4)
        0x2A, 0x20, 0x20, 0x20, 0x2A, 0x20, 0x20, 0x20, 0x2A, 0x20, 0x2A, 0x20, 0x20, 0x20, 0x20, 0x20,
        // H   H SSS EEEEE (Row 5)
        0x2A, 0x20, 0x20, 0x20, 0x2A, 0x20, 0x2A, 0x2A, 0x2A, 0x20, 0x2A, 0x2A, 0x2A, 0x2A, 0x2A, 0x20
    };

    // Аккуратно заполняем выделенную память нашим паттерном
    std::memcpy(memory_canvas, hex_payload, ART_SIZE);

    std::cout << "[+] Память выделена по адресу: " << (void*)memory_canvas << std::endl;
    std::cout << "[+] Шестнадцатеричный арт загружен." << std::endl;
    std::cout << "[!] Инициирую Segmentation fault для сброса core dump..." << std::endl;

    // Намеренно провоцируем Segfault. 
    // Делаем указатель volatile, чтобы компилятор не вырезал этот код при оптимизации (-O2/-O3).
    volatile int* crash_pointer = nullptr;
    *crash_pointer = 0xDEADBEEF; 

    // До этого места выполнение никогда не дойдет.
    // Утечка memory_canvas останется в дампе.
    delete[] memory_canvas; 
    return 0;
}
