require "../squid"
require "opts"
require "shard"

class Main
  include Opts

  VERSION = Shard.version
  PROGRAM = Shard.program

  option dir     : String , "-d cache_dir", "cache dir", "/var/spool/squid"
  option verbose : Bool   , "-v", "Verbose output", false
  option version : Bool   , "--version", "Print the version and exit", false
  option help    : Bool   , "--help"   , "Output this help and exit" , false

  USAGE = <<-EOF
    {{program}} version {{version}}

    Usage: {{program}} <command>

    Options:
    {{options}}

    Commands:
      list         print all cache etnry
    EOF

  def run
    cmd = args.shift { die "command not found!" }
    prog = Squid::Program.new(dir)
    case cmd
    when "list" then prog.list(verbose)
    else
      die "command not supported: #{cmd} "
    end
  end
end

Main.run
