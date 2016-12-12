record Squid::Meta,
  type  : UInt8,
  len   : Int32,
  value : Bytes do

  def self.from_reader(reader : BytesReader, clue : String)
    type  = reader.uint8("#{clue}.type")
    len   = reader.int32("#{clue}.length")
    value = reader.read(len, "#{clue}.value")
    new(type, len, value)
  end

  def self.type_name(type)
    LibSquid::StoreMetaType.from_value?(type).inspect
  end

  @_type : LibSquid::StoreMetaType?
  def type
    (@_type ||= LibSquid::StoreMetaType.from_value?(@type)).not_nil!
  end
  
  def type_name
    self.class.type_name(@type)
  end

  def str
    String.new(@value.pointer(len-1), len-1)   # last byte is null
  end

  def to_s(io)
    io << "#{type_name}(#{@len})"
  end
end
