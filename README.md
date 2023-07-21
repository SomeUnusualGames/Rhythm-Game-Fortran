# Rhythm-Game-Fortran

Source code for Rhythm Game made in Fortran.

This implementation was based on [renpy-rhythm](https://github.com/RuolinZheng08/renpy-rhythm) made by [Lynn Zheng](https://github.com/RuolinZheng08)

Depends on:

- gfortran (`GNU Fortran (GCC) 13.1.0`)
- Raylib 4.0

Watch on Youtube (click the image):

[![Watch on Youtube](https://img.youtube.com/vi/qkTcjQCzwHc/0.jpg)](https://www.youtube.com/watch?v=qkTcjQCzwHc)

## Build

To build, compile `raylib.f90` and `map.f90` files with `-fno-range-check`, then the main file:

Windows: `gfortran -fno-range-check -o URG main.f90 -B. -lraylib -lopengl32 -lgdi32 -lwinmm -lshell32`

Linux: `gfortran -fno-range-check -o URG main.f90 -B. -lraylib -lGL -lm -pthread -ldl`

or simply run `build.bat` (Windows) or `bash build.sh` (Linux)

## Attribution

"Sad Scene" song by [Destructo20](https://freesound.org/people/Destructo20/sounds/667648/) - CC0