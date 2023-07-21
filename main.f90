! gfortran -fno-range-check -o game main.f90 -B. -lraylib -lopengl32 -lgdi32 -lwinmm -lshell32
! -fno-range-check -> Disable overflow checking. This is necessary
! for raylib color() struct, since its values are [0, 255], but Fortran's
! c_int8_t are [-128, 127], it order for this mismatch to work it is necessary to
! overflow.
! NOTE: Fortran strings are not zero terminated(!), so when passing it
! to a C function append char(0) to it.

include "raylib.f90"
include "map.f90"

program RhythmGame
  use raylib
  use map
  implicit none

  call init_window(1280, 720, "Fortran Rhythm Game" // char(0))
  call set_target_fps(60)

  call init_audio_device()

  call init_map()
  !call load_map("maps/test_map.txt" // char(0), "assets/music/test.wav" // char(0))
  !call load_map("maps/gadget_map.txt" // char(0), "assets/music/test/gadget.wav" // char(0))
  !call load_map("maps/test2_map.txt" // char(0), "assets/music/test2.wav" // char(0))
  call load_map( &
    "maps/Sad_Scene_map.txt" // char(0), &
    "assets/music/Sad_Scene.mp3" // char(0) &
  )

  do while (.not. window_should_close())
    if (is_key_pressed(KEY_SPACE) .and. .not. current_music%playing) then
      call start_playing()
    end if

    if (current_music%playing) then
      call update_map()
    end if

    call begin_drawing()
    call clear_background(color(0, 0, 0, 255))
    call draw_map()
    call draw_fps(0, 0)
    call end_drawing()
  end do

  call unload_map()
  call close_audio_device()
  call close_window()

end program RhythmGame