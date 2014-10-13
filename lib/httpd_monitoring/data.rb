module HttpdMonitoring
  # Store datas for 10s report and 2min alerts
  class Data
    attr_reader :hits_2min
    def initialize
      @data_10s = []
      @hits_2min = 0
    end

    def insert(data)
      update_data_2min(data)
      update_data_10s(data)
    end

    def update_data_2min(_data)
    end

    def update_data_10s(_data)
    end

    def select_data_10s
      temp = @data_10s.dup
      @data_10s = []
      temp
    end

    def hits_reached?
      false
    end
  end
end
