module HttpdMonitoring
  # Command line parsing
  class Options
    def initialize(_args)
    end

    def path
      'spec/temp.log'
    end

    def threshold
      1000
    end
  end
end
