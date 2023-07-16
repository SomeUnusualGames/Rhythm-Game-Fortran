# Rhythm-Game-Fortran

Source code for Rhythm Game made in Fortran.

Depends on:

- gfortran (`GNU Fortran (GCC) 13.1.0`)
- Raylib 4.0

To build, compile `raylib.f90` and `map.f90` files with `-fno-range-check`, then the main file:

Windows: `gfortran -fno-range-check -o URG main.f90 -B. -lraylib -lopengl32 -lgdi32 -lwinmm -lshell32`
Linux: `gfortran -fno-range-check -o URG main.f90 -B. -lraylib -lGL -lm -pthread -ldl`

or run `./build.bat` on Windows or `bash build.sh` on Linux.