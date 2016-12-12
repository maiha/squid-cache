record Squid::Meta,
  type_value : UInt8,
  len : Int32,
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

  # @type : LibSquid::StoreMetaType?
  def valid?
    valid.success?
  end

  def valid : Try(Bool)
    Try(Bool).try {
      type                      # raise if bound error
      true
    }
  end

  def type
    LibSquid::StoreMetaType.from_value(@type_value)
  end
  
  def type?
    LibSquid::StoreMetaType.from_value?(@type_value)
  end
  
  def str
    String.new(@value.pointer(len-1), len-1)   # last byte is null
  end

  def to_s(io)
    case type?.inspect
    when "URL"
      io << str
    else
      io << "#{type?.inspect}(#{@len})"
    end
  end
end
