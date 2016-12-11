class Squid::Error < Exception
end

class Squid::ReadError < Squid::Error
  def initialize(@clue : String, @message : String)
    super("#{@clue}: #{@message}")
  end
end
