class Squid::StoreMeta
  alias Type = LibSquid::StoreMetaType

  def self.load_file(filename : String)
    file = File.open(filename)
    bytes = Bytes.new(5)
    file.read(bytes)
    ptr = bytes.pointer(5).as(Pointer(LibSquid::StoreMeta))
    src = FromFile.new(filename)
    new(ptr.value, src)
  ensure
    file.try(&.close)
  end

  def self.from_io(io : IO, clue : String = "(raw bytes)")
    # main header
    type = io.read_bytes(UInt8)
    max  = io.read_bytes(UInt32)

    # sub headers
    read_size = 5
    subs = [] of Meta
    while read_size < max
      sub = Meta.from_io(io)
      subs << sub
      read_size += (5 + sub.len)
    end
    
    new(type, max, subs, clue)
  end

  def initialize(@type : UInt8, @len : UInt32, @subs : Array(Meta), @clue : String)
  end

  def type_name
    Meta.type_name(@type)
  end

  def to_s(io)
    io << "#{@clue}: #{type_name}(#{@len})"
  end

  def inspect(io)
    to_s(io)
    @subs.each_with_index do |sub, i|
      io << "\n  #{i}: #{sub}"
    end
  end
end

  
