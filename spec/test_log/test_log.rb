# Class for test purpose : write a w3c log file
class TestLog
  def initialize(logfile)
    @logfile = File.open(logfile, 'a')
    # Remove Ruby buffer
    @logfile.sync = true

    @rand = Random.new
    @ips = %w(127.0.0.1 192.168.0.1 12.2.12.0 128.0.1.127)
    @names = %w(jane joe-jj test)
    @users = @names
    @methods = %w(POST HEAD PUT DELETE OPTIONS TRACE CONNECT)
    @paths = %w(/ /user /user/create /user/delete /user/list
                /user/edit /home /admin /admin/parameters)
    @protocols = %w(HTTP/1.0 HTTP/1.1)
    @status = %w(404 403 418 301)
  end

  def start
    [1, 0.1, 0.01, 0, 0.1, 0.1].each do |sleep_time|
      launch_scenario(sleep_time, 10)
    end
  end

  protected

  def launch_scenario(sleep_time, duration)
    start_time = Time.now
    while Time.now < start_time + duration
      @logfile.puts log_line
      sleep(sleep_time)
    end
  end

  def log_line
    "#{log_host} #{log_name} #{log_user} #{log_date} "\
    "#{log_request} #{log_status} #{log_bytes}"
  end

  def log_host
    @ips[@rand.rand(0...(@ips.length - 1))]
  end

  def log_name
    return '-' if @rand.rand(3) < 2
    @names[@rand.rand(0...(@names.size - 1))]
  end

  def log_user
    return '-' if @rand.rand(3) < 2
    @users[@rand.rand(0...(@users.size - 1))]
  end

  def log_date
    "[#{Time.now.strftime('%d/%b/%Y:%H:%M:%S %z')}]"
  end

  def log_request
    "\"#{log_method} #{log_path} #{log_protocol}\""
  end

  def log_method
    return 'GET' if @rand.rand(3) < 2
    @methods[@rand.rand(0...(@methods.size - 1))]
  end

  def log_path
    @paths[@rand.rand(0...(@paths.size - 1))]
  end

  def log_protocol
    @protocols[@rand.rand(0...(@protocols.size - 1))]
  end

  def log_status
    return '200' if @rand.rand(10) < 9
    @status[@rand.rand(0...(@status.size - 1))]
  end

  def log_bytes
    @rand.rand(0...(2000))
  end
end
