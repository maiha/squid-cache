class Squid::Program
  include Enumerable(Try(StoreMeta))
  
  def initialize(@dir : String, @verbose : Bool = false)
  end

  def get(url)
    try = find_by_url(url).flat_map(&.read_bytes)
    try = try.flat_map{|i| extract_body(i)} if !@verbose
    if try.success?
      bytes = try.get
      STDOUT.write bytes
    else
      STDERR.puts "HTTP/1.1 404 Not Found\r\n\r\n#{try.failed.value.message}"
    end
  end

  def check
    grep(Failure(StoreMeta)).each do |try|
      STDERR.puts try.failed.value.message
    end
  end

  def keys
    each do |try|
      case try
      when Success(StoreMeta)
        meta = try.get
        meta.url?.try{|url| puts url}
      end        
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

  def foreach
    each do |try|
      if try.success?
        yield(try.get)
      end
    end
  end

  private def find_by_url(url) : Try(StoreMeta)
    url = url.chomp("/")
    foreach do |meta|
      next if meta.url?.try(&.chomp("/")) != url
      return Try(StoreMeta).try {meta}
    end
    Try(StoreMeta).try {raise "Not Found: #{url}"}
  end

  private def extract_body(bytes) : Try(Bytes)
    seek_response_body(bytes).map{|pos|
      bytes[pos, bytes.size - pos]
    }
  end

  private def seek_response_body(bytes) : Try(Int32)
    cr = 13_u8
    lf = 10_u8
    bytes.each_with_index do |v, i|
      next if i < 5
      next if v != lf
      if (bytes[i-1] == lf) || (bytes[i-1] == cr && bytes[i-2] == lf && bytes[i-3] == cr)
        return Try(Int32).try{ i+1 }
      end
    end
    Try(Int32).try { raise "not found" }
  end
end
