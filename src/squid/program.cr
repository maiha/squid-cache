class Squid::Program
  def initialize(@dir : String)
  end

  def list(verbose = false)
    Dir.glob(@dir + "/*/*/*") do |filename|
      File.open(filename) do |file|
        meta = StoreMeta.from_io(file, clue: filename)
        if verbose
          p meta
        else
          puts meta
        end
      end
    end
  end
end
