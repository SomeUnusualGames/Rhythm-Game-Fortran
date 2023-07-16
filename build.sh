#!/usr/bin/env bash

if [[ -f URG ]]; then
  rm URG
fi

scripts=(raylib.f90 map.f90)
for s in ${scripts[@]}; do
  gfortran -fno-range-check -c $s
done
gfortran -fno-range-check -o URG main.f90 -B. -lraylib -lGL -lm -pthread -ldl
if [[ -f URG ]]; then
  ./URG
else
  echo Compilation error
fi