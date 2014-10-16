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
      rescue OptionParser::InvalidOption, OptionParser::InvalidArgument => e
        abort e.to_s
      end
      help if @options[:help]
      version if @options[:version]
      @path = @args.first
      check_valid_args
      print_summary
    end

    def threshold
      @options[:threshold]
    end

    def debug?
      @options[:debug]
    end

    def limit_print
      @options[:limit_print] ? @options[:limit_print] : 3
    end

    protected

    # rubocop:disable Metrics/MethodLength
    # Use ruby OptionParser to get command args
    def init_parser
      @parser = OptionParser.new do |opts|
        opts.banner = 'Usage: httpd-monitoring -l LIMIT [w3c-log-file]'
        opts.on('-l', '--limit LIMIT', Integer,
                'Trigger alert last 2 minutes hits are above LIMIT') do |l|
          @options[:threshold] = l
        end
        opts.on('-p', '--print PRINT_LIMIT', Integer,
                'Choose how many sections will be displayed') do |p|
          @options[:limit_print] = p
        end
        opts.on('-V', '--version',
                'Display the httpd-monitoring version') do |_v|
          @options[:version] = true
        end
        opts.on('-h', '--help',
                'Display this help') do |_h|
          @options[:help] = true
        end
        opts.on('-d', '--debug',
                'Enable debug log') do |_d|
          @options[:debug] = true
        end
      end
    end

    # Check that httpd-monitoring can run without problem
    def check_valid_args
      abort 'LIMIT must be given' unless @options[:threshold]
      abort 'No file given' unless @path
      abort "#{@path} is not a file" unless File.file?(@path)
      abort "#{@path} is not readable" unless File.readable?(@path)
    end

    # Print help and exit
    def help
      print @parser.help
      exit
    end

    # Print version and exit
    def version
      print "httpd-monitoring #{HttpdMonitoring::VERSION}\n"
      exit
    end

    # Print what httpd-monitoring is doing
    def print_summary
      print "httpd-monitoring started on file #{path} "\
            "with limit #{@options[:threshold]}\n"
    end
  end
end
