module HttpdMonitoring
  # Store datas for 10s report and 2min alerts
  class Data
    attr_reader :traffic_2min
    def initialize
      @last_time = Time.at(0)
      @sections_10s = Hash.new(0)
      @traffic_10s = 0
      @ips_10s = Hash.new(0)
      @traffic_2min = 0
      @times_2min = Hash.new(0)
    end

    def insert(data)
      update_data_10s(data)
      update_data_2min(data)
    end

    def update_data_2min(data)
      delete_old_2min(data[:date]) if @last_time < data[:date]
      @times_2min[data[:date]] += data[:bytes]
      @traffic_2min += data[:bytes]
    end

    def delete_old_2min(date)
      @last_time = date
      @times_2min.each do |time, bytes|
        @traffic_2min -= bytes if time + 120 > date
      end
    end

    def update_data_10s(data)
      @sections_10s[data[:path]] += 1
      @ips_10s[data[:host]] += data[:bytes]
      @traffic_10s += data[:bytes]
    end

    def select_data_10s
      temp = {}
      temp[:sections] = @sections_10s.dup
      temp[:traffic] = @traffic_10s
      temp[:ips] = @ips_10s.dup
      @sections_10s = Hash.new(0)
      @traffic_10s = 0
      @ips_10s = Hash.new(0)
      temp
    end
  end
end
