require "../../spec_helper"
require "../../../src/sdl3"

describe SDL3 do
  it "creates and destroys properties" do
    props = LibSDL3.create_properties
    props.should_not eq(0)
    LibSDL3.destroy_properties(props)
  end

  it "sets and gets a boolean property" do
    props = LibSDL3.create_properties
    LibSDL3.set_boolean_property(props, "test_bool", true).should be_true
    LibSDL3.get_boolean_property(props, "test_bool", false).should be_true
    LibSDL3.clear_property(props, "test_bool").should be_true
    LibSDL3.destroy_properties(props)
  end

  it "sets and gets a string property" do
    props = LibSDL3.create_properties
    test_string = "Hello, properties!"
    LibSDL3.set_string_property(props, "test_string", test_string).should be_true
    retrieved_string = LibSDL3.get_string_property(props, "test_string", "default")
    String.new(retrieved_string).should eq(test_string)
    LibSDL3.clear_property(props, "test_string").should be_true
    LibSDL3.destroy_properties(props)
  end

  it "sets and gets a number property" do
    props = LibSDL3.create_properties
    test_number = 12345_i64
    LibSDL3.set_number_property(props, "test_number", test_number).should be_true
    LibSDL3.get_number_property(props, "test_number", 0_i64).should eq(test_number)
    LibSDL3.clear_property(props, "test_number").should be_true
    LibSDL3.destroy_properties(props)
  end

  it "sets and gets a float property" do
    props = LibSDL3.create_properties
    test_float = 3.14159_f32
    LibSDL3.set_float_property(props, "test_float", test_float).should be_true
    LibSDL3.get_float_property(props, "test_float", 0.0_f32).should be_close(test_float, 0.00001)
    LibSDL3.clear_property(props, "test_float").should be_true
    LibSDL3.destroy_properties(props)
  end

  it "gets global properties" do
    global_props = LibSDL3.get_global_properties
    global_props.should_not eq(0)
    # Don't destroy global properties
  end
end
