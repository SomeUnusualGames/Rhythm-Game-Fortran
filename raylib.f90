module raylib
    use :: iso_c_binding
    implicit none

    type, bind(c) :: vector2
        real(c_float) :: x
        real(c_float) :: y
    end type vector2

    type, bind(c) :: vector3
        real(c_float) :: x
        real(c_float) :: y
        real(c_float) :: z
    end type vector3

    type, bind(c) :: vector4
        real(c_float) :: x
        real(c_float) :: y
        real(c_float) :: z
        real(c_float) :: w
    end type vector4

    type, bind(c) :: matrix
        real(c_float) :: m0,  m1,  m2,  m3
        real(c_float) :: m4,  m5,  m6,  m7
        real(c_float) :: m8,  m9,  m10, m11
        real(c_float) :: m12, m13, m14, m15
    end type matrix
    
    type, bind(c) :: color
        integer(c_int8_t) :: r
        integer(c_int8_t) :: g
        integer(c_int8_t) :: b
        integer(c_int8_t) :: a
    end type color
    
    type, bind(c) :: rectangle
        real(c_float) :: x
        real(c_float) :: y
        real(c_float) :: width
        real(c_float) :: height
    end type rectangle

    type, bind(c) :: image
        type(c_ptr) :: data
        integer(c_int) :: width
        integer(c_int) :: height
        integer(c_int) :: mipmaps
        integer(c_int) :: format
    end type image

    type, bind(c) :: texture
        integer(c_int) :: id
        integer(c_int) :: width
        integer(c_int) :: height
        integer(c_int) :: mipmaps
        integer(c_int) :: format
    end type texture
    
    type, bind(c) :: render_texture
        integer(c_int) :: id
        type(texture) :: texture
        type(texture) :: depth
    end type render_texture

    type, bind(c) :: n_patch_info
        type(rectangle) :: source
        integer(c_int) :: left
        integer(c_int) :: top
        integer(c_int) :: right
        integer(c_int) :: bottom
        integer(c_int) :: layout
    end type n_patch_info

    type, bind(c) :: char_info
        integer(c_int) :: value
        integer(c_int) :: offset_x
        integer(c_int) :: offset_y
        integer(c_int) :: advance_x
        type(image) :: image
    end type char_info

    ! todo: font

    type, bind(c) :: camera3d
        type(vector3) :: position
        type(vector3) :: terget
        type(vector3) :: up
        real(c_float) :: fovy
        integer(c_int) :: projection
    end type camera3d

    type, bind(c) :: camera2d
        type(vector2) :: offset
        type(vector2) :: terget
        real(c_float) :: rotation
        real(c_float) :: zoom
    end type camera2d

    ! todo mesh
    ! todo shader

    type, bind(c) :: material_map
        type(texture) :: texture
        type(color) :: color
        real(c_float) :: value
    end type material_map

    ! todo material

    type, bind(c) :: transform
        type(vector3) :: translation
        type(vector4) :: rotation
        type(vector3) :: scale
    end type transform

    type, bind(c) :: bone_info
        character(c_char), dimension(32) :: name
        integer(c_int) :: parent
    end type bone_info

    ! todo model
    ! todo model_animation

    type, bind(c) :: ray
        type(vector3) :: position
        type(vector3) :: direction
    end type ray

    type, bind(c) :: ray_hit_info
        logical(c_bool) :: hit
        real(c_float) :: distance
        type(vector3) :: position
        type(vector3) :: normal
    end type ray_hit_info

    type, bind(c) :: bounding_box
        type(vector3) :: min
        type(vector3) :: max
    end type bounding_box

    type, bind(c) :: wave
        integer(c_int) :: sample_count
        integer(c_int) :: sample_rate
        integer(c_int) :: sample_size
        integer(c_int) :: channels
        type(c_ptr) :: data
    end type wave

    type, bind(c) :: audio_stream
        type(c_ptr) :: buffer
        integer(c_int) :: sample_rate
        integer(c_int) :: sample_size
        integer(c_int) :: channels
    end type audio_stream

    type, bind(c) :: sound
        type(audio_stream) :: stream
        integer(c_int) :: sample_count
    end type sound

    type, bind(c) :: music
        type(audio_stream) :: stream
        integer(c_int) :: frame_count
        logical(c_bool) :: looping
        
        integer(c_int) :: ctx_type
        type(c_ptr) :: ctx_data
    end type music

    type, bind(c) :: vr_device_info
        integer(c_int) :: h_resolution
        integer(c_int) :: v_resolution
        real(c_float) :: h_screen_size
        real(c_float) :: v_screen_size
        real(c_float) :: v_screen_center
        real(c_float) :: eye_to_screen_distance
        real(c_float) :: lens_separation_distance
        real(c_float) :: interpupillary_distance
        real(c_float), dimension(4) :: lens_distortion_values
        real(c_float), dimension(4) :: chroma_ab_correction
    end type vr_device_info

    type, bind(c) :: vr_stereo_config
        type(matrix), dimension(2) :: projection
        type(matrix), dimension(2) :: view_offset
        real(c_float), dimension(2) :: left_lens_center
        real(c_float), dimension(2) :: right_lens_center
        real(c_float), dimension(2) :: left_screen_center
        real(c_float), dimension(2) :: right_screen_center
        real(c_float), dimension(2) :: scale
        real(c_float), dimension(2) :: scale_in
    end type vr_stereo_config

    ! ConfigFlags
    integer(c_int) :: flag_vsync_hint         = 64   ! Set to try enabling V-Sync on GPU
    integer(c_int) :: flag_fullscreen_mode    = 2    ! Set to run program in fullscreen
    integer(c_int) :: flag_window_resizable   = 4    ! Set to allow resizable window
    integer(c_int) :: flag_window_undecorated = 8    ! Set to disable window decoration (frame and buttons)
    integer(c_int) :: flag_window_hidden      = 128   ! Set to hide window
    integer(c_int) :: flag_window_minimized   = 512  ! Set to minimize window (iconify)
    integer(c_int) :: flag_window_maximized   = 1024  ! Set to maximize window (expanded to monitor)
    integer(c_int) :: flag_window_unfocused   = 4096  ! Set to window non focused
    integer(c_int) :: flag_window_topmost     = 1000 ! Set to window always on top
    integer(c_int) :: flag_window_always_run  = 256  ! Set to allow windows running while minimized
    integer(c_int) :: flag_window_transparent = 16   ! Set to allow transparent framebuffer
    integer(c_int) :: flag_window_highdpi     = 8192 ! Set to support HighDPI
    integer(c_int) :: flag_window_mouse_passthrough = 16384 ! Set to support mouse passthrough, only supported when FLAG_WINDOW_UNDECORATED
    integer(c_int) :: flag_msaa_4x_hint        = 32   ! Set to try enabling MSAA 4X
    integer(c_int) :: flag_interlaced_hint     = 65536 ! Set to try enabling interlaced video format (for V3D)

    ! Trace log level
    integer(c_int) :: LOG_ALL     = 0
    integer(c_int) :: LOG_TRACE   = 1
    integer(c_int) :: LOG_DEBUG   = 2
    integer(c_int) :: LOG_INFO    = 3
    integer(c_int) :: LOG_WARNING = 4
    integer(c_int) :: LOG_ERROR   = 5
    integer(c_int) :: LOG_FATAL   = 6
    integer(c_int) :: LOG_NONE    = 7
    ! Keyboard keys
    integer(c_int) :: KEY_NULL            = 0
    ! Alphanumeric keys
    integer(c_int) :: KEY_APOSTROPHE      = 39
    integer(c_int) :: KEY_COMMA           = 44
    integer(c_int) :: KEY_MINUS           = 45
    integer(c_int) :: KEY_PERIOD          = 46
    integer(c_int) :: KEY_SLASH           = 47
    integer(c_int) :: KEY_ZERO            = 48
    integer(c_int) :: KEY_ONE             = 49
    integer(c_int) :: KEY_TWO             = 50
    integer(c_int) :: KEY_THREE           = 51
    integer(c_int) :: KEY_FOUR            = 52
    integer(c_int) :: KEY_FIVE            = 53
    integer(c_int) :: KEY_SIX             = 54
    integer(c_int) :: KEY_SEVEN           = 55
    integer(c_int) :: KEY_EIGHT           = 56
    integer(c_int) :: KEY_NINE            = 57
    integer(c_int) :: KEY_SEMICOLON       = 59
    integer(c_int) :: KEY_EQUAL           = 61
    integer(c_int) :: KEY_A               = 65
    integer(c_int) :: KEY_B               = 66
    integer(c_int) :: KEY_C               = 67
    integer(c_int) :: KEY_D               = 68
    integer(c_int) :: KEY_E               = 69
    integer(c_int) :: KEY_F               = 70
    integer(c_int) :: KEY_G               = 71
    integer(c_int) :: KEY_H               = 72
    integer(c_int) :: KEY_I               = 73
    integer(c_int) :: KEY_J               = 74
    integer(c_int) :: KEY_K               = 75
    integer(c_int) :: KEY_L               = 76
    integer(c_int) :: KEY_M               = 77
    integer(c_int) :: KEY_N               = 78
    integer(c_int) :: KEY_O               = 79
    integer(c_int) :: KEY_P               = 80
    integer(c_int) :: KEY_Q               = 81
    integer(c_int) :: KEY_R               = 82
    integer(c_int) :: KEY_S               = 83
    integer(c_int) :: KEY_T               = 84
    integer(c_int) :: KEY_U               = 85
    integer(c_int) :: KEY_V               = 86
    integer(c_int) :: KEY_W               = 87
    integer(c_int) :: KEY_X               = 88
    integer(c_int) :: KEY_Y               = 89
    integer(c_int) :: KEY_Z               = 90
    ! Function keys
    integer(c_int) :: KEY_SPACE           = 32
    integer(c_int) :: KEY_ESCAPE          = 256
    integer(c_int) :: KEY_ENTER           = 257
    integer(c_int) :: KEY_TAB             = 258
    integer(c_int) :: KEY_BACKSPACE       = 259
    integer(c_int) :: KEY_INSERT          = 260
    integer(c_int) :: KEY_DELETE          = 261
    integer(c_int) :: KEY_RIGHT           = 262
    integer(c_int) :: KEY_LEFT            = 263
    integer(c_int) :: KEY_DOWN            = 264
    integer(c_int) :: KEY_UP              = 265
    integer(c_int) :: KEY_PAGE_UP         = 266
    integer(c_int) :: KEY_PAGE_DOWN       = 267
    integer(c_int) :: KEY_HOME            = 268
    integer(c_int) :: KEY_END             = 269
    integer(c_int) :: KEY_CAPS_LOCK       = 280
    integer(c_int) :: KEY_SCROLL_LOCK     = 281
    integer(c_int) :: KEY_NUM_LOCK        = 282
    integer(c_int) :: KEY_PRINT_SCREEN    = 283
    integer(c_int) :: KEY_PAUSE           = 284
    integer(c_int) :: KEY_F1              = 290
    integer(c_int) :: KEY_F2              = 291
    integer(c_int) :: KEY_F3              = 292
    integer(c_int) :: KEY_F4              = 293
    integer(c_int) :: KEY_F5              = 294
    integer(c_int) :: KEY_F6              = 295
    integer(c_int) :: KEY_F7              = 296
    integer(c_int) :: KEY_F8              = 297
    integer(c_int) :: KEY_F9              = 298
    integer(c_int) :: KEY_F10             = 299
    integer(c_int) :: KEY_F11             = 300
    integer(c_int) :: KEY_F12             = 301
    integer(c_int) :: KEY_LEFT_SHIFT      = 340
    integer(c_int) :: KEY_LEFT_CONTROL    = 341
    integer(c_int) :: KEY_LEFT_ALT        = 342
    integer(c_int) :: KEY_LEFT_SUPER      = 343
    integer(c_int) :: KEY_RIGHT_SHIFT     = 344
    integer(c_int) :: KEY_RIGHT_CONTROL   = 345
    integer(c_int) :: KEY_RIGHT_ALT       = 346
    integer(c_int) :: KEY_RIGHT_SUPER     = 347
    integer(c_int) :: KEY_KB_MENU         = 348
    integer(c_int) :: KEY_LEFT_BRACKET    = 91
    integer(c_int) :: KEY_BACKSLASH       = 92
    integer(c_int) :: KEY_RIGHT_BRACKET   = 93
    integer(c_int) :: KEY_GRAVE           = 96
    ! Keypad keys
    integer(c_int) :: KEY_KP_0            = 320
    integer(c_int) :: KEY_KP_1            = 321
    integer(c_int) :: KEY_KP_2            = 322
    integer(c_int) :: KEY_KP_3            = 323
    integer(c_int) :: KEY_KP_4            = 324
    integer(c_int) :: KEY_KP_5            = 325
    integer(c_int) :: KEY_KP_6            = 326
    integer(c_int) :: KEY_KP_7            = 327
    integer(c_int) :: KEY_KP_8            = 328
    integer(c_int) :: KEY_KP_9            = 329
    integer(c_int) :: KEY_KP_DECIMAL      = 330
    integer(c_int) :: KEY_KP_DIVIDE       = 331
    integer(c_int) :: KEY_KP_MULTIPLY     = 332
    integer(c_int) :: KEY_KP_SUBTRACT     = 333
    integer(c_int) :: KEY_KP_ADD          = 334
    integer(c_int) :: KEY_KP_ENTER        = 335
    integer(c_int) :: KEY_KP_EQUAL        = 336
    ! Android key buttons
    integer(c_int) :: KEY_BACK            = 4
    integer(c_int) :: KEY_MENU            = 82
    integer(c_int) :: KEY_VOLUME_UP       = 24
    integer(c_int) :: KEY_VOLUME_DOWN     = 25
    ! Mouse buttons
    integer(c_int) :: MOUSE_LEFT_BUTTON   = 0
    integer(c_int) :: MOUSE_RIGHT_BUTTON  = 1
    integer(c_int) :: MOUSE_MIDDLE_BUTTON = 2
    ! Mouse cursor
    integer(c_int) :: MOUSE_CURSOR_DEFAULT       = 0
    integer(c_int) :: MOUSE_CURSOR_ARROW         = 1
    integer(c_int) :: MOUSE_CURSOR_IBEAM         = 2
    integer(c_int) :: MOUSE_CURSOR_CROSSHAIR     = 3
    integer(c_int) :: MOUSE_CURSOR_POINTING_HAND = 4
    integer(c_int) :: MOUSE_CURSOR_RESIZE_EW     = 5
    integer(c_int) :: MOUSE_CURSOR_RESIZE_NS     = 6
    integer(c_int) :: MOUSE_CURSOR_RESIZE_NWSE   = 7
    integer(c_int) :: MOUSE_CURSOR_RESIZE_NESW   = 8
    integer(c_int) :: MOUSE_CURSOR_RESIZE_ALL    = 9
    integer(c_int) :: MOUSE_CURSOR_NOT_ALLOWED   = 10
    ! Gamepad buttons
    integer(c_int) :: GAMEPAD_BUTTON_UNKNOWN = 0
    ! This is normally a DPAD
    integer(c_int) :: GAMEPAD_BUTTON_LEFT_FACE_UP    = 1
    integer(c_int) :: GAMEPAD_BUTTON_LEFT_FACE_RIGHT = 2
    integer(c_int) :: GAMEPAD_BUTTON_LEFT_FACE_DOWN  = 3
    integer(c_int) :: GAMEPAD_BUTTON_LEFT_FACE_LEFT  = 4
    ! This normally corresponds with PlayStation and Xbox controllers
    ! XBOX: [Y,X,A,B]
    ! PS3: [Triangle,Square,Cross,Circle]
    ! No support for 6 button controllers though..
    integer(c_int) :: GAMEPAD_BUTTON_RIGHT_FACE_UP    = 5
    integer(c_int) :: GAMEPAD_BUTTON_RIGHT_FACE_RIGHT = 6
    integer(c_int) :: GAMEPAD_BUTTON_RIGHT_FACE_DOWN  = 7
    integer(c_int) :: GAMEPAD_BUTTON_RIGHT_FACE_LEFT  = 8
    integer(c_int) :: GAMEPAD_BUTTON_LEFT_TRIGGER_1   = 9
    integer(c_int) :: GAMEPAD_BUTTON_LEFT_TRIGGER_2   = 10
    integer(c_int) :: GAMEPAD_BUTTON_RIGHT_TRIGGER_1  = 11
    integer(c_int) :: GAMEPAD_BUTTON_RIGHT_TRIGGER_2  = 12
    integer(c_int) :: GAMEPAD_BUTTON_MIDDLE_LEFT      = 13 ! PS3 Select
    integer(c_int) :: GAMEPAD_BUTTON_MIDDLE           = 14 ! PS Button/XBOX Button
    integer(c_int) :: GAMEPAD_BUTTON_MIDDLE_RIGHT     = 15 ! PS3 Start
    ! These are the joystick press in buttons
    integer(c_int) :: GAMEPAD_BUTTON_LEFT_THUMB       = 16
    integer(c_int) :: GAMEPAD_BUTTON_RIGHT_THUMB      = 17
    ! Gamepad axis
    integer(c_int) :: GAMEPAD_AXIS_LEFT_X = 0
    integer(c_int) :: GAMEPAD_AXIS_LEFT_Y = 1
    integer(c_int) :: GAMEPAD_AXIS_RIGHT_X = 2
    integer(c_int) :: GAMEPAD_AXIS_RIGHT_Y = 3
    integer(c_int) :: GAMEPAD_AXIS_LEFT_TRIGGER = 4       ! [1..-1] (pressure-level)
    integer(c_int) :: GAMEPAD_AXIS_RIGHT_TRIGGER = 5      ! [1..-1] (pressure-level)
    ! Material map index
    integer(c_int) :: MATERIAL_MAP_ALBEDO     = 0
    integer(c_int) :: MATERIAL_MAP_DIFFUSE    = 0 ! same as MATERIAL_MAP_ALBEDO
    integer(c_int) :: MATERIAL_MAP_METALNESS  = 1
    integer(c_int) :: MATERIAL_MAP_SPECULAR   = 1 ! same as MATERIAL_MAP_METALNESS
    integer(c_int) :: MATERIAL_MAP_NORMAL     = 2
    integer(c_int) :: MATERIAL_MAP_ROUGHNESS  = 3
    integer(c_int) :: MATERIAL_MAP_OCCLUSION  = 4
    integer(c_int) :: MATERIAL_MAP_EMISSION   = 5
    integer(c_int) :: MATERIAL_MAP_HEIGHT     = 6
    integer(c_int) :: MATERIAL_MAP_BRDG       = 7
    integer(c_int) :: MATERIAL_MAP_CUBEMAP    = 8        ! NOTE: Uses GL_TEXTURE_CUBE_MAP
    integer(c_int) :: MATERIAL_MAP_IRRADIANCE = 9        ! NOTE: Uses GL_TEXTURE_CUBE_MAP
    integer(c_int) :: MATERIAL_MAP_PREFILTER  = 10       ! NOTE: Uses GL_TEXTURE_CUBE_MAP
    ! Shader location index
    integer(c_int) :: SHADER_LOC_VERTEX_POSITION   = 0
    integer(c_int) :: SHADER_LOC_VERTEX_TEXCOORD01 = 1
    integer(c_int) :: SHADER_LOC_VERTEX_TEXCOORD02 = 2
    integer(c_int) :: SHADER_LOC_VERTEX_NORMAL     = 3
    integer(c_int) :: SHADER_LOC_VERTEX_TANGENT    = 4
    integer(c_int) :: SHADER_LOC_VERTEX_COLOR      = 5
    integer(c_int) :: SHADER_LOC_MATRIX_MVP        = 6
    integer(c_int) :: SHADER_LOC_MATRIX_VIEW       = 7
    integer(c_int) :: SHADER_LOC_MATRIX_PROJECTION = 8
    integer(c_int) :: SHADER_LOC_MATRIX_MODEL      = 9
    integer(c_int) :: SHADER_LOC_MATRIX_NORMAL     = 10
    integer(c_int) :: SHADER_LOC_VECTOR_VIEW       = 11
    integer(c_int) :: SHADER_LOC_COLOR_DIFFUSE     = 12
    integer(c_int) :: SHADER_LOC_COLOR_SPECULAR    = 13
    integer(c_int) :: SHADER_LOC_COLOR_AMBIENT     = 14
    integer(c_int) :: SHADER_LOC_MAP_ALBEDO        = 15
    integer(c_int) :: SHADER_LOC_MAP_DIFFUSE       = 15 ! same as SHADER_LOC_MAP_ALBEDO
    integer(c_int) :: SHADER_LOC_MAP_METALNESS     = 16
    integer(c_int) :: SHADER_LOC_MAP_SPECULAR      = 16 ! same as SHADER_LOC_MAP_METALNESS
    integer(c_int) :: SHADER_LOC_MAP_NORMAL        = 17
    integer(c_int) :: SHADER_LOC_MAP_ROUGHNESS     = 18
    integer(c_int) :: SHADER_LOC_MAP_OCCLUSION     = 19
    integer(c_int) :: SHADER_LOC_MAP_EMISSION      = 20
    integer(c_int) :: SHADER_LOC_MAP_HEIGHT        = 21
    integer(c_int) :: SHADER_LOC_MAP_CUBEMAP       = 22
    integer(c_int) :: SHADER_LOC_MAP_IRRADIANCE    = 23
    integer(c_int) :: SHADER_LOC_MAP_PREFILTER     = 24
    integer(c_int) :: SHADER_LOC_MAP_BRDF          = 25
    ! Shader uniform data type
    integer(c_int) :: SHADER_UNIFORM_FLOAT     = 0
    integer(c_int) :: SHADER_UNIFORM_VEC2      = 1
    integer(c_int) :: SHADER_UNIFORM_VEC3      = 2
    integer(c_int) :: SHADER_UNIFORM_VEC4      = 3
    integer(c_int) :: SHADER_UNIFORM_INT       = 4
    integer(c_int) :: SHADER_UNIFORM_IVEC2     = 5
    integer(c_int) :: SHADER_UNIFORM_IVEC3     = 6
    integer(c_int) :: SHADER_UNIFORM_IVEC4     = 7
    integer(c_int) :: SHADER_UNIFORM_SAMPLER2D = 8
    ! Pixel formats
    integer(c_int) :: PIXELFORMAT_UNCOMPRESSED_GRAYSCALE    = 1  ! 8 bit per pixel (no alpha)
    integer(c_int) :: PIXELFORMAT_UNCOMPRESSED_GRAY_ALPHA   = 2  ! 8*2 bpp (2 channels)
    integer(c_int) :: PIXELFORMAT_UNCOMPRESSED_R5G6B5       = 3  ! 16 bpp
    integer(c_int) :: PIXELFORMAT_UNCOMPRESSED_R8G8B8       = 4  ! 24 bpp
    integer(c_int) :: PIXELFORMAT_UNCOMPRESSED_R5G5B5A1     = 5  ! 16 bpp (1 bit alpha)
    integer(c_int) :: PIXELFORMAT_UNCOMPRESSED_R4G4B4A4     = 6  ! 16 bpp (4 bit alpha)
    integer(c_int) :: PIXELFORMAT_UNCOMPRESSED_R8G8B8A8     = 7  ! 32 bpp
    integer(c_int) :: PIXELFORMAT_UNCOMPRESSED_R32          = 8  ! 32 bpp (1 channel - float)
    integer(c_int) :: PIXELFORMAT_UNCOMPRESSED_R32G32B32    = 9  ! 32*3 bpp (3 channels - float)
    integer(c_int) :: PIXELFORMAT_UNCOMPRESSED_R32G32B32A32 = 10 ! 32*4 bpp (4 channels - float)
    integer(c_int) :: PIXELFORMAT_COMPRESSED_DXT1_RGB       = 11 ! 4 bpp (no alpha)
    integer(c_int) :: PIXELFORMAT_COMPRESSED_DXT1_RGBA      = 12 ! 4 bpp (1 bit alpha)
    integer(c_int) :: PIXELFORMAT_COMPRESSED_DXT3_RGBA      = 13 ! 8 bpp
    integer(c_int) :: PIXELFORMAT_COMPRESSED_DXT5_RGBA      = 14 ! 8 bpp
    integer(c_int) :: PIXELFORMAT_COMPRESSED_ETC1_RGB       = 15 ! 4 bpp
    integer(c_int) :: PIXELFORMAT_COMPRESSED_ETC2_RGB       = 16 ! 4 bpp
    integer(c_int) :: PIXELFORMAT_COMPRESSED_ETC2_EAC_RGBA  = 17 ! 8 bpp
    integer(c_int) :: PIXELFORMAT_COMPRESSED_PVRT_RGB       = 18 ! 4 bpp
    integer(c_int) :: PIXELFORMAT_COMPRESSED_PVRT_RGBA      = 19 ! 4 bpp
    integer(c_int) :: PIXELFORMAT_COMPRESSED_ASTC_4x4_RGBA  = 20 ! 8 bpp
    integer(c_int) :: PIXELFORMAT_COMPRESSED_ASTC_8x8_RGBA  = 21 ! 2 bpp
    ! Texture parameters: filter mode
    integer(c_int) :: TEXTURE_FILTER_POINT           = 0 ! No filter, just pixel aproximation
    integer(c_int) :: TEXTURE_FILTER_BILINEAR        = 1 ! Linear filtering
    integer(c_int) :: TEXTURE_FILTER_TRILINEAR       = 2 ! Trilinear filtering (linear with mipmaps)
    integer(c_int) :: TEXTURE_FILTER_ANISOTROPIC_4X  = 3 ! Anisotropic filtering 4x
    integer(c_int) :: TEXTURE_FILTER_ANISOTROPIC_8X  = 4 ! Anisotropic filtering 8x
    integer(c_int) :: TEXTURE_FILTER_ANISOTROPIC_16X = 5 ! Anisotropic filtering 16x
    ! Texture parameters: wrap mode
    integer(c_int) :: TEXTURE_WRAP_REPEAT        = 0 ! Repeats texture in tiled mode
    integer(c_int) :: TEXTURE_WRAP_CLAMP         = 1 ! Clamps texture to edge pixel in tiled mode
    integer(c_int) :: TEXTURE_WRAP_MIRROR_REPEAT = 2 ! Mirrors and repeats the texture in tiled mode
    integer(c_int) :: TEXTURE_WRAP_MIRROR_CLAMP  = 3 ! Mirrors and clamps to border the texture in tiled mode
    ! Cubemap layouts
    integer(c_int) :: CUBEMAP_LAYOUT_AUTO_DETECT         = 0 ! Automatically detect layout type
    integer(c_int) :: CUBEMAP_LAYOUT_LINE_VERTICAL       = 1 ! Layout is defined by a vertical line with faces
    integer(c_int) :: CUBEMAP_LAYOUT_LINE_HORIZONTAL     = 2 ! Layout is defined by an horizontal line with faces
    integer(c_int) :: CUBEMAP_LAYOUT_CROSS_THREE_BY_FOUR = 3 ! Layout is defined by a 3x4 cross with cubemap faces
    integer(c_int) :: CUBEMAP_LAYOUT_CROSS_FOUR_BY_THREE = 4 ! Layout is defined by a 4x3 cross with cubemap faces
    integer(c_int) :: CUBEMAP_LAYOUT_PANORAMA            = 5 ! Layout is defined by a panorama image (equirectangular map)
    ! Font type, defines generation method
    integer(c_int) :: FONT_DEFAULT = 0 ! Default font generation, anti-aliased
    integer(c_int) :: FONT_BITMAP  = 1 ! Bitmap font generation, no anti-aliasing
    integer(c_int) :: FONT_SDF     = 2 ! SDF font generation, requires external shader
    ! Color blending modes (pre-defined)
    integer(c_int) :: BLEND_ALPHA           = 0 ! Blend textures considering alpha (default)
    integer(c_int) :: BLEND_ADDITIVE        = 1 ! Blend textures adding colors
    integer(c_int) :: BLEND_MULTIPLIED      = 2 ! Blend textures multiplying colors
    integer(c_int) :: BLEND_ADD_COLORS      = 3 ! Blend textures adding colors (alternative)
    integer(c_int) :: BLEND_SUBTRACT_COLORS = 4 ! Blend textures subtracting colors (alternative)
    integer(c_int) :: BLEND_CUSTOM          = 5 ! Belnd textures using custom src/dst factors (use rlSetBlendMode())
    ! Gestures
    integer(c_int) :: GESTURE_NONE        = 0
    integer(c_int) :: GESTURE_TAP         = 1
    integer(c_int) :: GESTURE_DOUBLETAP   = 2
    integer(c_int) :: GESTURE_HOLD        = 4
    integer(c_int) :: GESTURE_DRAG        = 8
    integer(c_int) :: GESTURE_SWIPE_RIGHT = 16
    integer(c_int) :: GESTURE_SWIPE_LEFT  = 32
    integer(c_int) :: GESTURE_SWIPE_UP    = 64
    integer(c_int) :: GESTURE_SWIPE_DOWN  = 128
    integer(c_int) :: GESTURE_PINCH_IN    = 256
    integer(c_int) :: GESTURE_PINCH_OUT   = 512
    ! Camera system modes
    integer(c_int) :: CAMERA_CUSTOM       = 0
    integer(c_int) :: CAMERA_FREE         = 1
    integer(c_int) :: CAMERA_ORBITAL      = 2
    integer(c_int) :: CAMERA_FIRST_PERSON = 3
    integer(c_int) :: CAMERA_THIRD_PERSON = 4
    ! Camera projection
    integer(c_int) :: CAMERA_PERSPECTIVE  = 0
    integer(c_int) :: CAMERA_ORTHOGRAPHIC = 1
    ! N-patch layout
    integer(c_int) :: NPATCH_NINE_PATCH             = 0 ! Npatch layout: 3x3 tiles
    integer(c_int) :: NPATCH_THREE_PATCH_VERTICAL   = 1 ! Npatch layout: 1x3 tiles
    integer(c_int) :: NPATCH_THREE_PATCH_HORIZONTAL = 2 ! Npatch layout: 3x1 tiles

    ! todo: Callbacks
    ! typedef void (*TraceLogCallback)(int logLevel, const char *text, va_list args);  // Logging: Redirect trace log messages
    ! typedef unsigned char* (*LoadFileDataCallback)(const char* fileName, unsigned int* bytesRead);      // FileIO: Load binary data
    ! typedef bool (*SaveFileDataCallback)(const char *fileName, void *data, unsigned int bytesToWrite);  // FileIO: Save binary data
    ! typedef char *(*LoadFileTextCallback)(const char* fileName);                // FileIO: Load text data
    ! typedef bool (*SaveFileTextCallback)(const char *fileName, char *text);     // FileIO: Save text data

    interface
        ! Window-related functions
        subroutine init_window (width, height, title) bind (c, name="InitWindow")
            import :: c_char
            import :: c_int
            integer(c_int), intent(in), value :: width
            integer(c_int), intent(in), value :: height
            character(c_char), dimension(*), intent(in) :: title
        end subroutine init_window

        subroutine set_config_flags(flags) bind (c, name="SetConfigFlags")
            import :: c_int
            integer(c_int), intent(in), value :: flags
        end subroutine set_config_flags

        subroutine set_target_fps (fps) bind (c, name="SetTargetFPS")
            import :: c_int
            integer(c_int), intent(in), value :: fps
        end subroutine set_target_fps

        function get_frame_time () result (res) bind (c, name="GetFrameTime")
            import :: c_float
            real(c_float) :: res
        end function get_frame_time

        function window_should_close () result (res) bind (c, name="WindowShouldClose")
            import :: c_bool
            logical(c_bool) :: res
        end function window_should_close

        subroutine close_window() bind (c, name="CloseWindow")
        end subroutine close_window

        function is_window_ready () result (res) bind (c, name="IsWindowReady")
            import :: c_bool
            logical(c_bool) :: res
        end function is_window_ready

        function is_window_fullscreen () result (res) bind (c, name="IsWindowFullscreen")
            import :: c_bool
            logical(c_bool) :: res
        end function is_window_fullscreen

        function is_window_hidden () result (res) bind (c, name="IsWindowHidden")
            import :: c_bool
            logical(c_bool) :: res
        end function is_window_hidden

        function is_window_minimized () result (res) bind (c, name="IsWindowMinimized")
            import :: c_bool
            logical(c_bool) :: res
        end function is_window_minimized

        function is_window_maximized () result (res) bind (c, name="IsWindowMaximized")
            import :: c_bool
            logical(c_bool) :: res
        end function is_window_maximized

        function is_window_focused () result (res) bind (c, name="IsWindowFocused")
            import :: c_bool
            logical(c_bool) :: res
        end function is_window_focused

        function is_window_resized () result (res) bind (c, name="IsWindowResized")
            import :: c_bool
            logical(c_bool) :: res
        end function is_window_resized

        function is_window_state (flags) result (res) bind (c, name="IsWindowState")
            import :: c_bool
            import :: c_int
            integer(c_int), intent(in), value :: flags
            logical(c_bool) :: res
        end function is_window_state

        function get_screen_width () result(res) bind (c, name="GetScreenWidth")
            import :: c_int
            integer(c_int) :: res
        end function get_screen_width

        function get_screen_height () result(res) bind (c, name="GetScreenHeight")
            import :: c_int
            integer(c_int) :: res
        end function get_screen_height

        subroutine set_window_state (flags) bind (c, name="SetWindowState")
            import :: c_int
            integer(c_int), intent(in), value :: flags
        end subroutine set_window_state

        subroutine clear_window_state (flags) bind (c, name="ClearWindowState")
            import :: c_int
            integer(c_int), intent(in), value :: flags
        end subroutine clear_window_state

        subroutine toggle_fullscreen () bind (c, name="ToggleFullscreen")
        end subroutine toggle_fullscreen
 
        subroutine maximize_window () bind (c, name="MaximizeWindow")
        end subroutine maximize_window
        
        subroutine minimize_window () bind (c, name="MinimizeWindow")
        end subroutine minimize_window

        subroutine restore_window () bind (c, name="RestoreWindow")
        end subroutine restore_window

        subroutine set_window_icon(image_) bind (c, name="SetWindowIcon")
            import :: image
            type(image), intent(in), value :: image_
        end subroutine set_window_icon

        subroutine set_window_title(title) bind (c, name="SetWindowTitle")
            import :: c_char
            character(c_char), dimension(*), intent(in) :: title
        end subroutine set_window_title

        subroutine set_window_position(x, y) bind (c, name="SetWindowPosition")
            import :: c_int
            integer(c_int), intent(in), value :: x
            integer(c_int), intent(in), value :: y
        end subroutine set_window_position

        subroutine set_window_monitor(monitor) bind (c, name="SetWindowMonitor")
            import :: c_int
            integer(c_int), intent(in), value :: monitor
        end subroutine set_window_monitor

        subroutine set_window_min_size(width, height) bind (c, name="SetWindowMinSize")
            import :: c_int
            integer(c_int), intent(in), value :: width
            integer(c_int), intent(in), value :: height
        end subroutine set_window_min_size

        subroutine set_window_size(width, height) bind (c, name="SetWindowSize")
            import :: c_int
            integer(c_int), intent(in), value :: width
            integer(c_int), intent(in), value :: height
        end subroutine set_window_size

        function get_window_handle() result(res) bind (c, name="GetWindowHandel")
            import :: c_ptr
            type(c_ptr) :: res
        end function get_window_handle

        function get_window_width() result(res) bind (c, name="GetWindowWidth")
            import :: c_int
            integer(c_int) :: res
        end function get_window_width

        function get_window_height() result(res) bind (c, name="GetWindowHeight")
            import :: c_int
            integer(c_int) :: res
        end function get_window_height

        function get_monitor_count() result(res) bind (c, name="GetMonitorCount")
            import :: c_int
            integer(c_int) :: res
        end function get_monitor_count

        function get_current_monitor() result(res) bind (c, name="GetCurrentMonitor")
            import :: c_int
            integer(c_int) :: res
        end function get_current_monitor

        function get_monitor_position (monitor) result (res) bind (c, name="GetMonitorPosition")
            import :: vector2
            import :: c_int
            integer(c_int), intent(in), value :: monitor
            type(vector2) :: res
        end function get_monitor_position

        function get_monitor_width (monitor) result (res) bind (c, name="GetMonitorWidth")
            import :: c_int
            integer(c_int), intent(in), value :: monitor
            integer(c_int) :: res
        end function get_monitor_width

        function get_monitor_height (monitor) result (res) bind (c, name="GetMonitorHeight")
            import :: c_int
            integer(c_int), intent(in), value :: monitor
            integer(c_int) :: res
        end function get_monitor_height

        function get_monitor_physical_width (monitor) result (res) bind (c, name="GetMonitorPhysicalWidth")
            import :: c_int
            integer(c_int), intent(in), value :: monitor
            integer(c_int) :: res
        end function get_monitor_physical_width

        function get_monitor_physical_height (monitor) result (res) bind (c, name="GetMonitorPhysicalHeight")
            import :: c_int
            integer(c_int), intent(in), value :: monitor
            integer(c_int) :: res
        end function get_monitor_physical_height

        function get_monitor_refresh_rate (monitor) result (res) bind (c, name="GetMonitorRefreshRate")
            import :: c_int
            integer(c_int), intent(in), value :: monitor
            integer(c_int) :: res
        end function get_monitor_refresh_rate

        function get_window_position () result (res) bind (c, name="GetWindowPosition")
            import :: vector2
            type(vector2) :: res
        end function get_window_position

        function get_window_scale_dpi () result (res) bind (c, name="GetWindowScaleDPI")
            import :: vector2
            type(vector2) :: res
        end function get_window_scale_dpi

        function get_time () result (res) bind (c, name="GetTime")
            import :: c_double
            real(c_double) :: res
        end function get_time

        ! function get_monitor_name (monitor) result (res) bind (c, name="GetMonitorName")
        !     import :: c_int
        !     import :: c_char
        !     integer(c_int), intent(in), value :: monitor
        !     character(c_char), dimension(*) :: res
        ! end function get_monitor_name

        subroutine set_clipboard_text (text) bind (c, name="SetClipboardText")
            import :: c_char
            character(c_char), dimension(*) :: text
        end subroutine set_Clipboard_Text

        ! function get_clipboard_text () result (res) bind (c, name="GetClipboardText")
        !     import :: c_char
        !     integer(c_int), intent(in), value :: monitor
        !     character(c_char), dimension(*) :: res
        ! end function get_clipboard_text

        ! Cursor-related functions
        subroutine show_cursor () bind (c, name="ShowCursor")
        end subroutine show_cursor

        subroutine hide_cursor () bind (c, name="HideCursor")
        end subroutine hide_cursor

        function is_cursor_hidden () result (res) bind (c, name="IsCursorHidden")
            import :: c_bool
            logical(c_bool) :: res
        end function is_cursor_hidden

        subroutine enable_cursor () bind (c, name="EnableCursor")
        end subroutine enable_cursor

        subroutine disable_cursor () bind (c, name="DisableCursor")
        end subroutine disable_cursor

        function is_cursor_on_screen () result (res) bind (c, name="IsCursorOnScreen")
            import :: c_bool
            logical(c_bool) :: res
        end function is_cursor_on_screen

        function is_key_pressed (key) result (res) bind (c, name="IsKeyPressed")
            import :: c_int
            import :: c_bool
            integer(c_int), intent(in), value :: key
            logical(c_bool) :: res
        end function is_key_pressed

        subroutine draw_fps (posX, posY) bind (c, name="DrawFPS")
            import :: c_int
            integer(c_int), intent(in), value :: posX
            integer(c_int), intent(in), value :: posY
        end subroutine draw_fps

        subroutine begin_drawing () bind (c, name="BeginDrawing")
        end subroutine begin_drawing

        subroutine clear_background (color_) bind (c, name="ClearBackground")
            import :: color
            type(color), intent(in), value :: color_
        end subroutine clear_background

        subroutine end_drawing () bind (c, name="EndDrawing")
        end subroutine end_drawing

        subroutine init_audio_device () bind (c, name="InitAudioDevice")
        end subroutine init_audio_device

        subroutine close_audio_device () bind (c, name="CloseAudioDevice")
        end subroutine close_audio_device

        function load_music_stream (file_name) result (res) bind (c, name="LoadMusicStream")
            import :: music
            import :: c_char
            character(c_char), dimension(*), intent(in) :: file_name
            type(music) :: res
        end function load_music_stream

        function load_sound (file_name) result (res) bind (c, name="LoadSound")
            import :: sound
            import :: c_char
            character(c_char), dimension(*), intent(in) :: file_name
            type(sound) :: res
        end function load_sound

        subroutine play_sound (sound_) bind (c, name="PlaySound")
            import :: sound
            type(sound), intent(in), value :: sound_
        end subroutine play_sound

        subroutine play_music_stream(music_) bind (c, name="PlayMusicStream")
            import :: music
            type(music), intent(in), value :: music_
        end subroutine play_music_stream

        function is_music_ready(music_) result (res) bind (c, name="IsMusicReady")
            import :: music
            import :: c_bool
            type(music), intent(in), value :: music_
            logical(c_bool) :: res
        end function is_music_ready

        subroutine play_audio_stream(stream) bind (c, name="PlayAudioStream")
            import :: audio_stream
            type(audio_stream), intent(in), value :: stream
        end subroutine play_audio_stream

        subroutine update_audio_stream(stream) bind (c, name="UpdateAudioStream")
            import :: audio_stream
            type(audio_stream), intent(in), value :: stream
        end subroutine update_audio_stream

        subroutine update_music_stream(music_) bind (c, name="UpdateMusicStream")
            import :: music
            type(music), intent(in), value :: music_
        end subroutine update_music_stream

        function is_music_stream_playing(music_) result (res) bind (c, name="IsMusicStreamPlaying")
            import :: music
            import :: c_bool
            type(music), intent(in), value :: music_
            logical(c_bool) :: res
        end function is_music_stream_playing

        subroutine unload_music_stream (music_) bind (c, name="UnloadMusicStream")
            import :: music
            type(music), intent(in), value :: music_
        end subroutine unload_music_stream

        subroutine draw_text (text, posX, posY, fontSize, color_) bind (c, name="DrawText")
            import :: c_char
            import :: c_int
            import :: color
            character(c_char), dimension(*), intent(in) :: text
            integer(c_int), intent(in), value :: posX
            integer(c_int), intent(in), value :: posY
            integer(c_int), intent(in), value :: fontSize
            type(color), intent(in), value :: color_
        end subroutine draw_text

        subroutine draw_circle (centerX, centerY, radius, color_) bind (c, name="DrawCircle")
            import :: c_int
            import :: c_float
            import :: color
            integer(c_int), intent(in), value :: centerX
            integer(c_int), intent(in), value :: centerY
            real(c_float), intent(in), value :: radius
            type(color), intent(in), value :: color_
        end subroutine draw_circle

        subroutine draw_rectangle_rec (rec, color_) bind (c, name="DrawRectangleRec")
            import :: rectangle
            import :: color
            type(rectangle), intent(in), value :: rec
            type(color), intent(in), value :: color_
        end subroutine draw_rectangle_rec

        subroutine draw_rectangle_gradient_ex(rec, col1, col2, col3, col4) bind (c, name="DrawRectangleGradientEx")
            import :: rectangle
            import :: color
            type(rectangle), intent(in), value :: rec
            type(color), intent(in), value :: col1
            type(color), intent(in), value :: col2
            type(color), intent(in), value :: col3
            type(color), intent(in), value :: col4           
        end subroutine draw_rectangle_gradient_ex

        subroutine draw_rectangle_lines_ex (rec, line_thick, color_) bind (c, name="DrawRectangleLinesEx")
            import :: rectangle
            import :: c_float
            import :: color
            type(rectangle), intent(in), value :: rec
            real(c_float), intent(in), value :: line_thick
            type(color), intent(in), value :: color_
        end subroutine draw_rectangle_lines_ex

        function load_texture(file_name) result (res) bind (c, name="LoadTexture")
            import :: c_char
            import :: texture
            character(c_char), dimension(*), intent(in) :: file_name
            type(texture) :: res
        end function load_texture

        subroutine unload_texture(texture_) bind (c, name="UnloadTexture")
            import :: texture
            type(texture), intent(in) :: texture_
        end subroutine unload_texture

        subroutine draw_texture_pro (texture_, source, dest, origin, rotation, tint) bind (c, name="DrawTexturePro")
            import :: texture
            import :: rectangle
            import :: vector2
            import :: c_float
            import :: color
            type(texture), intent(in), value :: texture_
            type(rectangle), intent(in), value :: source
            type(rectangle), intent(in), value :: dest
            type(vector2), intent(in), value :: origin
            real(c_float), intent(in), value :: rotation
            type(color), intent(in), value :: tint
        end subroutine draw_texture_pro

        function measure_text (text, font_size) result (res) bind (c, name="MeasureText")
            import :: c_char
            import :: c_int
            character(c_char), dimension(*), intent(in) :: text
            integer(c_int), intent(in), value :: font_size
            integer(c_int) :: res
        end function measure_text

        function fade (color_, alpha) result (res) bind (c, name="Fade")
            import :: color
            import :: c_float
            type(color), intent(in), value :: color_
            real(c_float), intent(in), value :: alpha
            type(color) :: res
        end function fade

    end interface
end module raylib