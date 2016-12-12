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
      check        print broken cache
      list         print all cache entry
      keys         print all url
    EOF

  def run
    cmd = args.shift { die "command not found!" }
    prog = Squid::Program.new(dir, verbose)
    case cmd
    when "check"  then prog.check
    when "keys"   then prog.keys
    when "list"   then prog.list
    else
      die "command not supported: #{cmd} "
    end
  end
end

Main.run
