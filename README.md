# mruby on ESP32 - Post temperature to a Thingspeak Channel

## Before anything

First things first, get the simple examples from
[mruby-esp32/mruby-esp32](https://github) working. They will give you the
familiarity needed to work with mruby on the ESP32 (and the ESP-IDF toolchain
as well).

Many thanks to mr. Yamamoto Masaya for the answers on the mruby-esp32 repo
issues pages.

## Getting started

You will need to recursively clone this project with the recursive flag
because it includes mruby as a submodule:

```
git clone --recursive https://github.com/donatoaz/mruby-esp32.git
```

Do not forget to change the `thingspeak_temperature.rb` file to adjust to your
local wifi AP SSID and key.

Also, define an environment variable `THINGSPEAK_API_KEY` containing your
Thingspeak API **write** key.

To compile:

```
export THINGSPEAK_API_KEY=MYKEY
make menuconfig
make flash monitor
```

## wifi\_example\_mrb.rb stack overflow

If you experience a stack overflow during execution of the WiFi example, please
adjust the stack size on file `main/mruby_main.c` from 8192 to 16384.

```
void app_main()
{
  nvs_flash_init();
  xTaskCreate(&mruby_task, "mruby_task", 16384, NULL, 5, NULL);
}

```

Also adjust the configured stack size using `make menuconfig` from the default
one (which may be either 2048 or 4096) to 16384.

```
make menuconfig
Component config ---> ESP32-specific ---> Event loop task stack size
```

References: Issue [#11](https://github.com/mruby-esp32/mruby-esp32/issues/11)
and
[mruby-esp32\/mruby-socket](https://github.com/donatoaz/mruby-socket)

---

The clean command will clean both the ESP32 build and the mruby build:

```
make clean
```

