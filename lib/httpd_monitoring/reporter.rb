module HttpdMonitoring
  # Print a report to console when asked
  class Reporter
    def initialize(data)
      @data = data
    end

    def report
      datas = @data.select_data_10s
      if datas[:traffic] != 0
        print_beautiful(analyse_data(datas))
      else
        print_nothing
      end
    end

    def alert(hits, time)
      print "High traffic generated an alert - hits = #{convert_to_human(hits)},"\
            " triggered at #{time}\n".red
    end

    def recover(hits, time)
      print "Recover form alert - lat 2 min hits = #{convert_to_human(hits)},"\
            " recovered at #{time}\n".green
    end

    protected

    def analyse_data(data)
      sections_sorted = data[:sections].sort_by { |_section, hits| hits }.reverse!
      ips_sorted = data[:ips].sort_by { |_ip, traffic| traffic }.reverse!
      { ips: ips_sorted[0..3],
        sections: sections_sorted[0..3],
        traffic: data[:traffic] }
    end

    def print_beautiful(datas)
      final_report = '-' * 36 + "\nReport at #{Time.now}:\n"
      final_report += "Most frequented sections:\n"
      datas[:sections].each do |section, hits|
        final_report += "    #{section} -> #{hits} hits\n"
      end
      final_report += "Most active visitors:\n"
      datas[:ips].each do |ip, traffic|
        final_report += "    #{ip} -> #{convert_to_human(traffic)}\n"
      end
      final_report += "Total traffic: #{convert_to_human(datas[:traffic])}\n"
      print final_report
    end

    def print_nothing
      print "#{Time.now}: no traffic\n"
    end

    def convert_to_human(bytes)
      Filesize.from(bytes.to_s + ' B').pretty
    end
  end
end
