require "http/client"

class Squid::StoreMeta
  def self.from_io(io : IO, clue : String = "(raw bytes)") : Try(StoreMeta)
    reader = BytesReader.new(io, clue)
    try = Try(StoreMeta).try {
      # main header
      type = reader.uint8("file type")
      max  = reader.uint32("file length")
      # sub headers
      read_size = 5
      subs = [] of Meta
      index = 0
      while read_size < max
        sub = Meta.from_reader(reader, "meta(#{index})")
        subs << sub
        read_size += (5 + sub.len)
        index += 1
      end
      new(type, max, subs, clue)
    }
  end

  def initialize(@type : UInt8, @len : UInt32, @subs : Array(Meta), @clue : String)
  end

  def url?
    @subs.find(&.type.url?).try(&.str)
  end

  def type_name
    Meta.type_name(@type)
  end

  def http_response : Try(HTTP::Client::Response)
    Try(HTTP::Client::Response).try {
      bytesize = File.size(@clue)
      bytes = Bytes.new(bytesize - @len)
      File.open(@clue) do |file|
        file.seek(@len)
        HTTP::Client::Response.from_io(file)
      end
    }
  end

  def http_response : Try(HTTP::Client::Response)
    Try(HTTP::Client::Response).try {
      bytesize = File.size(@clue)
      bytes = Bytes.new(bytesize - @len)
      File.open(@clue) do |file|
        file.seek(@len)
        HTTP::Client::Response.from_io(file)
      end
    }
  end

  def read_bytes : Try(Bytes)
    Try(Bytes).try {
      bytesize = File.size(@clue)
      bytes = Bytes.new(bytesize - @len)
      File.open(@clue) do |file|
        file.seek(@len)
        file.read_fully(bytes)
        bytes
      end
    }
  end

  def to_s(io)
    if url = url?
      io << "#{@clue}: #{url}"
    else
      io << "#{@clue}: #{type_name}(#{@len})"
    end
  end

  def inspect(io)
    to_s(io)
    @subs.each_with_index do |sub, i|
      next unless sub.valid?
      io << "\n  #{i}: #{sub}"
    end
  end
end

  
