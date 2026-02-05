lib LibSDL3
  enum LogCategory
    APPLICATION
    ERROR
    ASSERT
    SYSTEM
    AUDIO
    VIDEO
    RENDER
    INPUT
    TEST
    GPU
    CUSTOM = 10
  end

  enum LogPriority
    INVALID
    TRACE
    VERBOSE
    DEBUG
    INFO
    WARN
    ERROR
    CRITICAL
    COUNT
  end

  fun log = SDL_Log(fmt : UInt8*, ...)
  fun set_log_priority = SDL_SetLogPriority(category : Int32, priority : LogPriority)
end

module SDL3
  def self.log(message : String)
    LibSDL3.log(message.to_unsafe)
  end

  def self.set_log_priority(category : LibSDL3::LogCategory, priority : LibSDL3::LogPriority)
    LibSDL3.set_log_priority(category.to_i, priority)
  end
end
