class BytesReader
  class ReadError < Exception
  end

  property pos

  def initialize(@io : IO, clue : String, @pos : Int32 = 0)
    @clue = clue.empty? ? "" : "#{clue}:"
  end

  def read(size : Int32, clue = nil)
    slice = Bytes.new(size)
    read_bytes(size, clue) do
      @io.read_fully(slice)
    end
    slice
  end

  macro read_method(klass, bytesize)
    def {{klass.stringify.downcase.id}}(clue = nil)
      read_bytes({{bytesize}}, clue||"") do
        @io.read_bytes({{klass}})
      end
    end
  end

  read_method Int8   , 1
  read_method UInt8  , 1
  read_method Int16  , 2
  read_method UInt16 , 2
  read_method Int32  , 4
  read_method UInt32 , 4
  read_method Int64  , 8
  read_method UInt64 , 8

  protected def read_bytes(size : Int32, clue : String)
    yield.tap{ @pos += size }
  rescue err
    clue = "[#{clue}]" if !clue.empty?
    msg = "#{@clue}#{clue}(reading #{size} bytes from #{@pos}) #{err}"
    raise ReadError.new(msg)
  end
end
