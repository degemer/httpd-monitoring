# Class for test purpose : write a w3c log file
class TestLog
  def self.run(scenario, threshold)
    log_file = File.dirname(__FILE__) + '/temp.log'
    FileUtils.touch(log_file)
    thread = Thread.current
    Thread.new do
      TestLog.new(log_file).start(scenario)
      thread.exit
    end
    HttpdMonitoring::CLI.new(['-d', '-l', threshold.to_s, log_file]).run
  end

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

  def start(scenario)
    scenario.each do |sleep_time|
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
    get_random(@ips)
  end

  def log_name
    get_random(@names, '-', 10)
  end

  def log_user
    get_random(@users, '-', 10)
  end

  def log_date
    "[#{Time.now.strftime('%d/%b/%Y:%H:%M:%S %z')}]"
  end

  def log_request
    "\"#{log_method} #{log_path} #{log_protocol}\""
  end

  def log_method
    get_random(@methods, 'GET', 10)
  end

  def log_path
    get_random(@paths)
  end

  def log_protocol
    get_random(@protocols)
  end

  def log_status
    get_random(@status, '200', 100)
  end

  def log_bytes
    @rand.rand(0...(2000))
  end

  def get_random(array, default = nil, proba = 0)
    return default if default && @rand.rand(proba) < proba - 1
    array[@rand.rand(0...(array.size - 1))]
  end
end
