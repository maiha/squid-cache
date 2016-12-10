record Squid::Meta,
  type  : UInt8,
  len   : Int32,
  value : Bytes do

  def self.from_io(io : IO)
    type  = io.read_bytes(UInt8)
    len   = io.read_bytes(Int32)
    value = Bytes.new(len)

    io.read_fully(value)
    new(type, len, value)
  end

  def self.type_name(type)
    LibSquid::StoreMetaType.from_value?(type).inspect
  end
  
  def type_name
    self.class.type_name(@type)
  end

  def to_s(io)
    io << "#{type_name}(#{@len})"
  end
end
