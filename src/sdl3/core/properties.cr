# Crystal bindings for SDL3_properties
# Docs: https://wiki.libsdl.org/SDL3/CategoryProperties

lib LibSDL3
  alias PropertiesID = UInt32

  enum PropertyType
    Invalid
    Pointer
    String
    Number
    Float
    Boolean
  end

  fun get_global_properties = SDL_GetGlobalProperties : PropertiesID
  fun create_properties = SDL_CreateProperties : PropertiesID
  fun copy_properties = SDL_CopyProperties(src : PropertiesID, dst : PropertiesID) : Bool
  fun lock_properties = SDL_LockProperties(props : PropertiesID) : Bool
  fun unlock_properties = SDL_UnlockProperties(props : PropertiesID) : Void

  alias CleanupPropertyCallback = (Void*, Void* ->)
  fun set_pointer_property_with_cleanup = SDL_SetPointerPropertyWithCleanup(props : PropertiesID, name : UInt8*, value : Void*, cleanup : CleanupPropertyCallback, userdata : Void*) : Bool
  fun set_pointer_property = SDL_SetPointerProperty(props : PropertiesID, name : UInt8*, value : Void*) : Bool
  fun set_string_property = SDL_SetStringProperty(props : PropertiesID, name : UInt8*, value : UInt8*) : Bool
  fun set_number_property = SDL_SetNumberProperty(props : PropertiesID, name : UInt8*, value : Int64) : Bool
  fun set_float_property = SDL_SetFloatProperty(props : PropertiesID, name : UInt8*, value : Float32) : Bool
  fun set_boolean_property = SDL_SetBooleanProperty(props : PropertiesID, name : UInt8*, value : Bool) : Bool
  fun has_property = SDL_HasProperty(props : PropertiesID, name : UInt8*) : Bool
  fun get_property_type = SDL_GetPropertyType(props : PropertiesID, name : UInt8*) : PropertyType
  fun get_pointer_property = SDL_GetPointerProperty(props : PropertiesID, name : UInt8*, default_value : Void*) : Void*
  fun get_string_property = SDL_GetStringProperty(props : PropertiesID, name : UInt8*, default_value : UInt8*) : UInt8*
  fun get_number_property = SDL_GetNumberProperty(props : PropertiesID, name : UInt8*, default_value : Int64) : Int64
  fun get_float_property = SDL_GetFloatProperty(props : PropertiesID, name : UInt8*, default_value : Float32) : Float32
  fun get_boolean_property = SDL_GetBooleanProperty(props : PropertiesID, name : UInt8*, default_value : Bool) : Bool
  fun clear_property = SDL_ClearProperty(props : PropertiesID, name : UInt8*) : Bool

  alias EnumeratePropertiesCallback = (Void*, PropertiesID, UInt8* ->)
  fun enumerate_properties = SDL_EnumerateProperties(props : PropertiesID, callback : EnumeratePropertiesCallback, userdata : Void*) : Bool
  fun destroy_properties = SDL_DestroyProperties(props : PropertiesID) : Void
end
