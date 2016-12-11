class Squid::Program
  include Enumerable(Try(StoreMeta))
  
  def initialize(@dir : String, @verbose : Bool = false)
  end

  def check
    grep(Failure(StoreMeta)).each do |try|
      STDERR.puts try.failed.value.message
    end
  end

  def list
    each do |try|
      case try
      when Success(StoreMeta)
        meta = try.get
        puts @verbose ? meta.inspect : meta.to_s
      when Failure(StoreMeta)
        if @verbose
          STDERR.puts "ERR: #{try.to_s}"
        end
      end
    end
  end

  def each
    Dir.glob(@dir + "/*/*/*") do |filename|
      File.open(filename) do |file|
        meta = StoreMeta.from_io(file, clue: filename)
        yield(meta)
      end
    end
  end
end
