module HttpdMonitoring
  # Command line parsing
  class Options
    attr_accessor :path

    def initialize(args)
      @args = args
      @options = {}
      init_parser
      begin
        @parser.parse!(args)
      rescue OptionParser::InvalidOption => e
        abort e.to_s
      end
      help if @options[:help]
      version if @options[:version]
      @path = @args.first
      check_valid_args
    end

    def threshold
      @options[:threshold]
    end

    protected

    def init_parser
      @parser = OptionParser.new do |opts|
        opts.banner = 'Usage: httpd-monitoring -l LIMIT [w3c-log-file]'
        opts.on('-l', '--limit LIMIT',
                'Trigger alert last 2 minutes hits are above LIMIT') do |l|
          @options[:threshold] = l.to_i
        end
        opts.on('-V', '--version',
                'Display the httpd-monitoring version') do |_v|
          @options[:version] = true
        end
        opts.on('-h', '--help',
                'Display this help') do |_h|
          @options[:help] = true
        end
      end
    end

    def check_valid_args
      abort 'LIMIT must be given' unless @options[:threshold]
      abort 'No path given' unless @path
      abort "#{@path} is not a file" unless File.file?(@path)
    end

    def help
      print @parser.help
      exit
    end

    def version
      print "httpd-monitoring #{HttpdMonitoring::VERSION}\n"
      exit
    end
  end
end
