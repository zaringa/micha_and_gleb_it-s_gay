# Ассемблируем файл
avr-as -mmcu=atmega328p -o for_miu.o for_miu.asm

# Линкуем объектный файл
avr-gcc -mmcu=atmega328p -o for_miu.elf for_miu.o

# Создаем файл прошивки в формате HEX
avr-objcopy -O ihex for_miu.elf for_miu.hex

avrdude -c usbtiny -p m328p -U flash:w:for_miu.hex:i

-c usbtiny — это тип программатора (замените на ваш тип программатора).
-p m328p — это модель микроконтроллера (ATmega328P).
-U flash:w:led_control.hex:i — команда для записи файла HEX в флеш-память.
