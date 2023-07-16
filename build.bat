@echo off
@del *.mod *.exe
set scripts=raylib.f90 map.f90
for %%s in (%scripts%) do (
	gfortran -fno-range-check -c %%s
)
gfortran -fno-range-check -o URG main.f90 -B. -lraylib -lopengl32 -lgdi32 -lwinmm -lshell32
@if exist URG.exe (
	@del *.o
	URG.exe
) else (
	@echo Compilation error
)