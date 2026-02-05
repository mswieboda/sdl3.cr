@[Link("SDL3")]
lib LibSDL3
  # SDL_init.h
  alias InitFlags = UInt32

  SDL_INIT_VIDEO = 0x00000020_u32

  fun init = SDL_Init(flags : InitFlags) : Bool
  fun quit = SDL_Quit

  # SDL_video.h
  alias Window = Void
  alias WindowFlags = UInt64

  SDL_WINDOWPOS_UNDEFINED = 0x1FFF0000_u32
  SDL_WINDOWPOS_CENTERED = 0x2FFF0000_u32

  fun create_window = SDL_CreateWindow(title : UInt8*, w : Int32, h : Int32, flags : WindowFlags) : Window*
  fun destroy_window = SDL_DestroyWindow(window : Window*)

  # SDL_render.h
  alias Renderer = Void

  fun create_renderer = SDL_CreateRenderer(window : Window*, name : UInt8*) : Renderer*
  fun destroy_renderer = SDL_DestroyRenderer(renderer : Renderer*)
  fun set_render_draw_color = SDL_SetRenderDrawColor(renderer : Renderer*, r : UInt8, g : UInt8, b : UInt8, a : UInt8) : Bool
  fun render_clear = SDL_RenderClear(renderer : Renderer*) : Bool
  fun render_present = SDL_RenderPresent(renderer : Renderer*) : Bool

  # SDL_events.h
  alias EventType = UInt32
  alias JoystickID = Int32
  alias Keycode = Int32
  alias Keymod = UInt16
  alias Scancode = Int32
  alias MouseID = UInt32
  alias MouseButtonFlags = UInt32
  alias TouchID = Int64
  alias FingerID = Int64

  SDL_EVENT_QUIT = 0x100_u32
  SDL_EVENT_WINDOW_CLOSE_REQUESTED = 0x20B_u32

  struct CommonEvent
    type : EventType
    reserved : UInt32
    timestamp : UInt64
  end

  struct DisplayEvent
    type : EventType
    reserved : UInt32
    timestamp : UInt64
    display_id : UInt32
    data1 : Int32
    data2 : Int32
  end

  struct WindowEvent
    type : EventType
    reserved : UInt32
    timestamp : UInt64
    window_id : UInt32
    data1 : Int32
    data2 : Int32
  end

  struct KeyboardDeviceEvent
    type : EventType
    reserved : UInt32
    timestamp : UInt64
    which : UInt32
  end

  struct KeyboardEvent
    type : EventType
    reserved : UInt32
    timestamp : UInt64
    window_id : UInt32
    which : UInt32
    scancode : Scancode
    key : Keycode
    mod : Keymod
    raw : UInt16
    down : Bool
    repeat : Bool
  end

  struct TextEditingEvent
    type : EventType
    reserved : UInt32
    timestamp : UInt64
    window_id : UInt32
    text : UInt8*
    start : Int32
    length : Int32
  end

  struct TextEditingCandidatesEvent
    type : EventType
    reserved : UInt32
    timestamp : UInt64
    window_id : UInt32
    candidates : UInt8**
    num_candidates : Int32
    selected_candidate : Int32
    horizontal : Bool
    padding1 : UInt8
    padding2 : UInt8
    padding3 : UInt8
  end

  struct TextInputEvent
    type : EventType
    reserved : UInt32
    timestamp : UInt64
    window_id : UInt32
    text : UInt8*
  end

  struct MouseDeviceEvent
    type : EventType
    reserved : UInt32
    timestamp : UInt64
    which : UInt32
  end

  struct MouseMotionEvent
    type : EventType
    reserved : UInt32
    timestamp : UInt64
    window_id : UInt32
    which : MouseID
    state : MouseButtonFlags
    x : Float32
    y : Float32
    xrel : Float32
    yrel : Float32
  end

  struct MouseButtonEvent
    type : EventType
    reserved : UInt32
    timestamp : UInt64
    window_id : UInt32
    which : MouseID
    button : UInt8
    down : Bool
    clicks : UInt8
    padding : UInt8
    x : Float32
    y : Float32
  end

  struct MouseWheelEvent
    type : EventType
    reserved : UInt32
    timestamp : UInt64
    window_id : UInt32
    which : MouseID
    x : Float32
    y : Float32
    direction : UInt32
    mouse_x : Float32
    mouse_y : Float32
    integer_x : Int32
    integer_y : Int32
  end

  struct JoyDeviceEvent
    type : EventType
    reserved : UInt32
    timestamp : UInt64
    which : JoystickID
  end

  struct JoyAxisEvent
    type : EventType
    reserved : UInt32
    timestamp : UInt64
    which : JoystickID
    axis : UInt8
    padding1 : UInt8
    padding2 : UInt8
    padding3 : UInt8
    value : Int16
    padding4 : UInt16
  end

  struct JoyBallEvent
    type : EventType
    reserved : UInt32
    timestamp : UInt64
    which : JoystickID
    ball : UInt8
    padding1 : UInt8
    padding2 : UInt8
    padding3 : UInt8
    xrel : Int16
    yrel : Int16
  end

  struct JoyHatEvent
    type : EventType
    reserved : UInt32
    timestamp : UInt64
    which : JoystickID
    hat : UInt8
    value : UInt8
    padding1 : UInt8
    padding2 : UInt8
  end

  struct JoyButtonEvent
    type : EventType
    reserved : UInt32
    timestamp : UInt64
    which : JoystickID
    button : UInt8
    down : Bool
    padding1 : UInt8
    padding2 : UInt8
  end

  struct JoyBatteryEvent
    type : EventType
    reserved : UInt32
    timestamp : UInt64
    which : JoystickID
    state : Int32
    percent : Int32
  end

  struct GamepadDeviceEvent
    type : EventType
    reserved : UInt32
    timestamp : UInt64
    which : JoystickID
  end

  struct GamepadAxisEvent
    type : EventType
    reserved : UInt32
    timestamp : UInt64
    which : JoystickID
    axis : UInt8
    padding1 : UInt8
    padding2 : UInt8
    padding3 : UInt8
    value : Int16
    padding4 : UInt16
  end

  struct GamepadButtonEvent
    type : EventType
    reserved : UInt32
    timestamp : UInt64
    which : JoystickID
    button : UInt8
    down : Bool
    padding1 : UInt8
    padding2 : UInt8
  end

  struct GamepadTouchpadEvent
    type : EventType
    reserved : UInt32
    timestamp : UInt64
    which : JoystickID
    touchpad : Int32
    finger : Int32
    x : Float32
    y : Float32
    pressure : Float32
  end

  struct GamepadSensorEvent
    type : EventType
    reserved : UInt32
    timestamp : UInt64
    which : JoystickID
    sensor : Int32
    data : Float32[3]
    sensor_timestamp : UInt64
  end

  struct AudioDeviceEvent
    type : EventType
    reserved : UInt32
    timestamp : UInt64
    which : UInt32
    recording : Bool
    padding1 : UInt8
    padding2 : UInt8
    padding3 : UInt8
  end

  struct CameraDeviceEvent
    type : EventType
    reserved : UInt32
    timestamp : UInt64
    which : UInt32
  end

  struct SensorEvent
    type : EventType
    reserved : UInt32
    timestamp : UInt64
    which : Int32
    data : Float32[6]
    sensor_timestamp : UInt64
  end

  struct QuitEvent
    type : EventType
    reserved : UInt32
    timestamp : UInt64
  end

  struct UserEvent
    type : UInt32
    reserved : UInt32
    timestamp : UInt64
    window_id : UInt32
    code : Int32
    data1 : Void*
    data2 : Void*
  end

  struct TouchFingerEvent
    type : EventType
    reserved : UInt32
    timestamp : UInt64
    touch_id : TouchID
    finger_id : FingerID
    x : Float32
    y : Float32
    dx : Float32
    dy : Float32
    pressure : Float32
    window_id : UInt32
  end

  struct PinchFingerEvent
    type : EventType
    reserved : UInt32
    timestamp : UInt64
    scale : Float32
    window_id : UInt32
  end

  struct PenProximityEvent
    type : EventType
    reserved : UInt32
    timestamp : UInt64
    window_id : UInt32
    which : UInt32
  end

  struct PenTouchEvent
    type : EventType
    reserved : UInt32
    timestamp : UInt64
    window_id : UInt32
    which : UInt32
    pen_state : UInt32
    x : Float32
    y : Float32
    eraser : Bool
    down : Bool
  end

  struct PenMotionEvent
    type : EventType
    reserved : UInt32
    timestamp : UInt64
    window_id : UInt32
    which : UInt32
    pen_state : UInt32
    x : Float32
    y : Float32
  end

  struct PenButtonEvent
    type : EventType
    reserved : UInt32
    timestamp : UInt64
    window_id : UInt32
    which : UInt32
    pen_state : UInt32
    x : Float32
    y : Float32
    button : UInt8
    down : Bool
  end

  struct PenAxisEvent
    type : EventType
    reserved : UInt32
    timestamp : UInt64
    window_id : UInt32
    which : UInt32
    pen_state : UInt32
    x : Float32
    y : Float32
    axis : UInt32
    value : Float32
  end

  struct RenderEvent
    type : EventType
    reserved : UInt32
    timestamp : UInt64
    window_id : UInt32
  end

  struct DropEvent
    type : EventType
    reserved : UInt32
    timestamp : UInt64
    window_id : UInt32
    x : Float32
    y : Float32
    source : UInt8*
    data : UInt8*
  end

  struct ClipboardEvent
    type : EventType
    reserved : UInt32
    timestamp : UInt64
    owner : Bool
    num_mime_types : Int32
    mime_types : UInt8**
  end

  union Event
    type : UInt32
    common : CommonEvent
    display : DisplayEvent
    window : WindowEvent
    kdevice : KeyboardDeviceEvent
    key : KeyboardEvent
    edit : TextEditingEvent
    edit_candidates : TextEditingCandidatesEvent
    text : TextInputEvent
    mdevice : MouseDeviceEvent
    motion : MouseMotionEvent
    button : MouseButtonEvent
    wheel : MouseWheelEvent
    jdevice : JoyDeviceEvent
    jaxis : JoyAxisEvent
    jball : JoyBallEvent
    jhat : JoyHatEvent
    jbutton : JoyButtonEvent
    jbattery : JoyBatteryEvent
    gdevice : GamepadDeviceEvent
    gaxis : GamepadAxisEvent
    gbutton : GamepadButtonEvent
    gtouchpad : GamepadTouchpadEvent
    gsensor : GamepadSensorEvent
    adevice : AudioDeviceEvent
    cdevice : CameraDeviceEvent
    sensor : SensorEvent
    quit : QuitEvent
    user : UserEvent
    tfinger : TouchFingerEvent
    pinch : PinchFingerEvent
    pproximity : PenProximityEvent
    ptouch : PenTouchEvent
    pmotion : PenMotionEvent
    pbutton : PenButtonEvent
    paxis : PenAxisEvent
    render : RenderEvent
    drop : DropEvent
    clipboard : ClipboardEvent
    padding : UInt8[128]
  end

  fun poll_event = SDL_PollEvent(event : Event*) : Bool

end

# A friendly Crystal wrapper
module SDL3
  extend self

  def init(flags : LibSDL3::InitFlags)
    unless LibSDL3.init(flags)
      raise "Failed to initialize SDL"
    end
  end

  def quit
    LibSDL3.quit
  end

  class Window
    @ptr : LibSDL3::Window*

    def initialize(title : String, w : Int32, h : Int32, flags : LibSDL3::WindowFlags)
      ptr = LibSDL3.create_window(title.to_unsafe, w, h, flags)
      raise "Failed to create window" if ptr.null?
      @ptr = ptr
    end

    def destroy
      LibSDL3.destroy_window(@ptr)
    end

    def to_unsafe
      @ptr
    end
  end

  class Renderer
    @ptr : LibSDL3::Renderer*

    def initialize(window : Window, name : String? = nil)
      name_ptr = name.is_a?(String) ? name.to_unsafe : Pointer(UInt8).null
      ptr = LibSDL3.create_renderer(window.to_unsafe, name_ptr)
      raise "Failed to create renderer" if ptr.null?
      @ptr = ptr
    end

    def destroy
      LibSDL3.destroy_renderer(@ptr)
    end

    def to_unsafe
      @ptr
    end

    def draw_color=(color : Tuple(UInt8, UInt8, UInt8, UInt8))
      LibSDL3.set_render_draw_color(@ptr, color[0], color[1], color[2], color[3])
    end

    def clear
      LibSDL3.render_clear(@ptr)
    end

    def present
      LibSDL3.render_present(@ptr)
    end
  end

  def poll_event(event : LibSDL3::Event*)
    LibSDL3.poll_event(event)
  end
end