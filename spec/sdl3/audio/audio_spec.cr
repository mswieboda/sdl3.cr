describe "SDL3 Audio" do
  before_each do
    SDL3.init(LibSDL3::SDL_INIT_AUDIO)
  end

  after_each do
    SDL3.quit
  end

  it "gets the number of audio drivers" do
    num_drivers = LibSDL3.get_num_audio_drivers
    num_drivers.should be >= 0
  end

  it "gets audio driver names" do
    num_drivers = LibSDL3.get_num_audio_drivers
    num_drivers.times do |i|
      driver_name = LibSDL3.get_audio_driver(i)
      driver_name.should_not be_nil
      String.new(driver_name).should_not be_empty
    end
  end

  it "gets current audio driver name" do
    current_driver = LibSDL3.get_current_audio_driver
    if current_driver
      String.new(current_driver).should_not be_empty
    end
  end

  it "gets audio playback devices" do
    count = uninitialized LibC::Int
    device_ids_ptr = LibSDL3.get_audio_playback_devices(pointerof(count))

    if device_ids_ptr
      count.should be >= 0
      LibSDL3.free(device_ids_ptr)
    else
      count.should eq(0)
    end
  end

  it "gets audio recording devices" do
    count = uninitialized LibC::Int
    device_ids_ptr = LibSDL3.get_audio_recording_devices(pointerof(count))

    if device_ids_ptr
      count.should be >= 0
      LibSDL3.free(device_ids_ptr)
    else
      count.should eq(0)
    end
  end

  it "loads and frees a WAV file" do
    # Assuming "assets/sfx/sample.wav" exists from previous steps
    path = "assets/sfx/sample.wav"
    spec = uninitialized LibSDL3::AudioSpec
    audio_buf = Pointer(UInt8).null
    audio_len = 0_u32

    success = LibSDL3.load_wav(path, pointerof(spec), pointerof(audio_buf), pointerof(audio_len))
    success.should be_true

    if success
      audio_buf.should_not be_nil
      audio_len.should be > 0

      # Check some properties of the loaded spec
      spec.format.should_not eq(LibSDL3::AudioFormatEnum::Unknown)
      spec.channels.should be >= 1
      spec.freq.should be > 0

      LibSDL3.free(audio_buf)
    end
  end
end
