lib LibSDL3
  enum AppResult
    Continue = 0
    Success  = 1
    Failure  = 2
  end

  alias AppInit_func = (Void**, Int32, LibC::Char**) -> AppResult
  alias AppIterate_func = (Void*) -> AppResult
  alias AppEvent_func = (Void*, Event*) -> AppResult
  alias AppQuit_func = (Void*, AppResult) -> Void
end

lib LibSDL3
  fun set_app_metadata = SDL_SetAppMetadata(appname : LibC::Char*, appversion : LibC::Char*, appidentifier : LibC::Char*) : Bool
end
