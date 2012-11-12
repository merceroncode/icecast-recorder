require 'celluloid'

class Recorder
  include Celluloid
  include Celluloid::Logger

  attr_accessor :command, :filename, :audition_info, :recording

  def initialize(audition_info)
    debug "Recorder created"
    @recording = false
    @dir = "/home/exine"

    @audition_info = audition_info
    @filename = audition_info.datetime.strftime("%Y%m%dT%H%M%S%z") + 
      audition_info.presenter + audition_info.name + ".mp3"
  end

  def record
    debug "Starting recording..."
    if !@recording
      commandline = "mplayer -quiet -nocache -nolirc -prefer-ipv4 -dumpstream \"#{@audition_info.streamurl}\" -dumpfile \"#{@dir}/#{@filename}\""
      @command = IO.popen(commandline)
    
      @recording = true
      info "Recorder spawned, pid #{@command.pid}"
    end    
  end

  def stop
    if @recording
      Process.kill 'INT', @command.pid

      debug "Recorder #{@command.pid} terminated"
    end

    self.terminate
  end

end