lib LibSDL3
  # SDL_version.h
  struct Version
    major : UInt8
    minor : UInt8
    patch : UInt8
  end

  fun get_version = SDL_GetVersion(ver : Version*)
  fun get_revision = SDL_GetRevision() : LibC::Char*
  fun get_revision_number = SDL_GetRevisionNumber() : LibC::Int
end

module SDL3
  def self.version
    ver = uninitialized LibSDL3::Version
    LibSDL3.get_version(pointerof(ver))
    ver
  end

  def self.revision
    String.new(LibSDL3.get_revision)
  end

  def self.revision_number
    LibSDL3.get_revision_number
  end
end
