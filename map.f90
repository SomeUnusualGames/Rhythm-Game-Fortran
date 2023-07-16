module Map
  use raylib
  implicit none

  ! A beat represents a note (arrow to press)
  type beat
    integer :: dir
    real :: timer, onset
    type(rectangle) :: dest_rect
    logical :: active, inserted
  end type beat

  ! The four bars that will contain the notes
  type bar
    type(rectangle) :: rect
    type(color) :: col
    type(beat), dimension(:), allocatable :: beat_arr
  end type bar

  type message
    character(len=100) :: text
    integer :: pos_x, pos_y
    type(color) :: col
    logical :: active
  end type message

  type music_playing
    type(bar), dimension(4) :: beat_bars
    type(message), dimension(5) :: accuracy_text
    type(color), dimension(4) :: arrow_colors
    type(music) :: song
    logical :: playing, played_song
    real :: start_time, current_time, timer_offset, note_offset, note_speed
  end type music_playing

  type(texture) :: beat_img
  type(music_playing) :: current_music
contains
  subroutine init_map()
    implicit none
    integer :: i
    beat_img = load_texture("assets/graphics/arrows.png" // char(0))
    do i = 1, size(current_music%beat_bars)
      current_music%beat_bars(i)%rect = rectangle(50, (350+70*i), get_screen_width()-20, 50)
      current_music%beat_bars(i)%col = color(255, 0, 0, 120)
    end do
    do i = 1, size(current_music%arrow_colors)
      current_music%arrow_colors(i) = color(255, 255, 255, 255)
    end do
    current_music%playing = .false.
    current_music%played_song = .false.
    current_music%start_time = 0.0
    current_music%current_time = 0.0
    current_music%timer_offset = 4.0

    ! Note speed
    current_music%note_offset = 4.0
    current_music%note_speed = (get_screen_width()-20) / current_music%note_offset
  end subroutine

  subroutine unload_map()
    implicit none
    call unload_texture(beat_img)
    !call unload_music_stream(current_music%song)
  end subroutine

  subroutine start_playing()
    implicit none
    current_music%playing = .true.
    current_music%start_time = get_time()
  end subroutine

  subroutine load_map(map_path, wav_path)
    implicit none
    character(len=*), intent(in) :: map_path
    character(len=*), intent(in) :: wav_path
    real :: time
    integer :: index, stat, i, key_to_press
    integer, dimension(4) :: direction_size
    integer, dimension(4) :: direction_index
    direction_size = (/0, 0, 0, 0/)
    direction_index = (/1, 1, 1, 1/)

    current_music%song = load_music_stream(wav_path)
    current_music%song%looping = .false.

    ! Get the number of directions to allocate the size of the arrays
    open(unit=10, file=map_path)
    do
      read(10, *) time, index
      ! for some reason fortran sigsegv's when reaching the eof
      ! and all of the "solutions" i found online don't work, so
      ! i have to hardcode an eof value
      if (index .eq. -1) exit
      direction_size(index+1) = direction_size(index+1) + 1
    end do
    do i = 1, size(current_music%beat_bars)
      allocate(current_music%beat_bars(i)%beat_arr(direction_size(i)))
    end do
    rewind(10)
    do
      read(10, *) time, index
      if (index .eq. -1) exit
      select case (index)
      case (1)
        key_to_press = KEY_UP
      case (3)
        key_to_press = KEY_LEFT
      case default
        key_to_press = index + 262
      end select
      current_music%beat_bars(index+1)%beat_arr(direction_index(index+1)) = beat( &
        key_to_press, 0.0, time+current_music%timer_offset, &
        rectangle(get_screen_width()-20, 350+(70*(index+1)), 50, 50), .false., .false. &
      )
      direction_index(index+1) = direction_index(index+1) + 1
    end do
    close(10)
  end subroutine

  subroutine insert_message(text, col)
    implicit none
    type(color), intent(in) :: col
    character(len=*), intent(in) :: text
    integer :: i
    do i = 1, size(current_music%accuracy_text)
      if (.not. current_music%accuracy_text(i)%active) then
        current_music%accuracy_text(i)%text = text // char(0)
        current_music%accuracy_text(i)%active = .true.
        current_music%accuracy_text(i)%pos_x = 50
        current_music%accuracy_text(i)%pos_y = 300
        current_music%accuracy_text(i)%col = col
        exit
      end if
    end do
  end subroutine

  function get_color(dir) result(res)
    implicit none
    integer, intent(in) :: dir
    type(color) :: res
    select case (dir)
    case (1)
      res = color(0, 255, 0, 255)
    case (2)
      res = color(255, 0, 0, 255)
    case (3)
      res = color(0, 0, 255, 255)
    case default
      res = color(255, 255, 0, 255)
    end select
  end function

  subroutine check_key_pressed()
    implicit none
    logical, dimension(4) :: bar_pressed
    integer :: i, n, key_to_press
    real :: onset, time_diff, current_time
    bar_pressed = (/.false., .false., .false., .false./)
    do i = 1, size(current_music%beat_bars)
      do n = 1, size(current_music%beat_bars(i)%beat_arr)
        if (current_music%beat_bars(i)%beat_arr(n)%active) then
          onset = current_music%beat_bars(i)%beat_arr(n)%onset
          key_to_press = current_music%beat_bars(i)%beat_arr(n)%dir
          time_diff = current_music%current_time - onset
          if (is_key_pressed(key_to_press) .and. .not. bar_pressed(i)) then
            bar_pressed(i) = .true.
            ! TODO: are these values good? Needs more playtesting
            if (time_diff .ge. -0.17 .and. time_diff .le. -0.12) then
              call insert_message("Perfect!", color(0, 255, 0, 255))
              current_music%beat_bars(i)%beat_arr(n)%active = .false.
              current_music%arrow_colors(i) = get_color(i)
            else if (time_diff .ge. -0.18 .and. time_diff .le. -0.09) then
              call insert_message("Good!", color(50, 150, 50, 255))
              current_music%beat_bars(i)%beat_arr(n)%active = .false.
              current_music%arrow_colors(i) = get_color(i)
            else if (time_diff .ge. -0.19 .and. time_diff .le. -0.07) then
              call insert_message("Eh", color(255, 255, 0, 255))
              current_music%beat_bars(i)%beat_arr(n)%active = .false.
              current_music%arrow_colors(i) = get_color(i)
            else if (time_diff .ge. -0.2 .and. time_diff .le. -0.02) then
              call insert_message("Miss", color(255, 0, 0, 255))
              current_music%beat_bars(i)%beat_arr(n)%active = .false.
            end if
          end if
        end if
      end do
    end do
  end subroutine

  subroutine update_map()
    implicit none
    type(beat) :: note
    real :: time_apperance, note_dist
    integer :: i, n, key_to_press
    real :: onset, time_diff, current_time

    current_music%current_time = get_time() - current_music%start_time

    if (.not. is_music_stream_playing(current_music%song) .and. current_music%played_song) then
      current_music%playing = .false.
      return
    end if
    if (is_music_stream_playing(current_music%song)) then
      call update_music_stream(current_music%song)
    end if
    if ( &
      .not. is_music_stream_playing(current_music%song) .and. &
      current_music%current_time .ge. current_music%timer_offset .and. &
      .not. current_music%played_song &
    ) then
      current_music%played_song = .true.
      call play_music_stream(current_music%song)
    end if
    
    call check_key_pressed()

    do i = 1, size(current_music%beat_bars)
      do n = 1, size(current_music%beat_bars(i)%beat_arr)
        note = current_music%beat_bars(i)%beat_arr(n)
        time_apperance = note%onset - current_music%current_time
        if (time_apperance .lt. 0) cycle
        if (time_apperance .le. current_music%note_offset) then
          if (.not. current_music%beat_bars(i)%beat_arr(n)%inserted) then
            current_music%beat_bars(i)%beat_arr(n)%active = .true.
          end if
          current_music%beat_bars(i)%beat_arr(n)%inserted = .true.
          current_music%beat_bars(i)%beat_arr(n)%timer = time_apperance
        else if (time_apperance .gt. current_music%note_offset) then
          exit
        end if
      end do
      do n = 1, size(current_music%beat_bars(i)%beat_arr)
        if (current_music%beat_bars(i)%beat_arr(n)%active) then
          ! speed = distance/time
          ! speed is predefined and time is known -> distance = time * speed
          note_dist = current_music%beat_bars(i)%beat_arr(n)%timer * current_music%note_speed
          current_music%beat_bars(i)%beat_arr(n)%dest_rect%x = note_dist
          if (note_dist .lt. 10) then
            call insert_message("Miss", color(255, 0, 0, 255))
            current_music%beat_bars(i)%beat_arr(n)%active = .false.
          end if
        end if
      end do
    end do
  end subroutine

  subroutine draw_map()
    implicit none
    integer :: i, n, dir
    real :: angle
    do i = 1, size(current_music%beat_bars)
      call draw_rectangle_rec(current_music%beat_bars(i)%rect, current_music%beat_bars(i)%col)
      select case (i)
      case (1)
        angle = 90.0
      case (2)
        angle = 0.0 !-90.0
      case (3)
        angle = 180.0
      case default
        angle = -90.0 !0.0
      end select
      !call draw_rectangle_rec(rectangle(80, 373+70*i+2, 50, 50), color(255, 255, 255, 255))
      call draw_texture_pro( &
        beat_img, &
        rectangle(200, 0, 50, 50), &
        rectangle(80, 373+70*i+2, 50, 50), &
        vector2(25, 25), &
        angle, &
        current_music%arrow_colors(i) &
      )
      if (current_music%arrow_colors(i)%r .ne. -1) current_music%arrow_colors(i)%r = current_music%arrow_colors(i)%r + 15
      if (current_music%arrow_colors(i)%g .ne. -1) current_music%arrow_colors(i)%g = current_music%arrow_colors(i)%g + 15
      if (current_music%arrow_colors(i)%b .ne. -1) current_music%arrow_colors(i)%b = current_music%arrow_colors(i)%b + 15
      do n = 1, size(current_music%beat_bars(i)%beat_arr)
        if (current_music%beat_bars(i)%beat_arr(n)%active) then
          dir = current_music%beat_bars(i)%beat_arr(n)%dir - 262
          !call draw_rectangle_rec(current_music%beat_bars(i)%beat_arr(n)%dest_rect, color(255, 255, 255, 255))
          call draw_texture_pro( &
            beat_img, &
            rectangle(50*dir, 0, 50, 50), &
            current_music%beat_bars(i)%beat_arr(n)%dest_rect, &
            vector2(0, 0), &
            0.0, &
            color(255, 255, 255, 255) &
          )
        end if
      end do
    end do
    do i = 1, size(current_music%accuracy_text)
      if (current_music%accuracy_text(i)%active) then
        call draw_text( &
          current_music%accuracy_text(i)%text, &
          current_music%accuracy_text(i)%pos_x, &
          current_music%accuracy_text(i)%pos_y, &
          80, &
          current_music%accuracy_text(i)%col &
        )
        current_music%accuracy_text(i)%pos_y = current_music%accuracy_text(i)%pos_y - 2
        if (current_music%accuracy_text(i)%pos_y .lt. 250) then
          current_music%accuracy_text(i)%active = .false.
        end if
      end if
    end do
  end subroutine

end module Map