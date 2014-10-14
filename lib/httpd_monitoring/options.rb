module HttpdMonitoring
  # Command line parsing
  class Options
    def initialize(_args)
    end

    def path
      'spec/temp.log'
    end

    def threshold
      20_000_000
    end
  end
end
