require "../../spec_helper"

describe SDL3::IOStream do
  it "should create from memory" do
    file = "./assets/img/player.png"
    bytes = File.read(file).to_slice
    size = bytes.size

    iostream = SDL3::IOStream.from_memory(bytes, size)
    iostream.should be_a(SDL3::IOStream)
    iostream.not_nil!.close.should be_true
  end
end
