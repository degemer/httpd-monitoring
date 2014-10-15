module HttpdMonitoring
  # Handle output format (except log)
  class Printer
    def initialize
      @old_alerts = []
      @before_reminder = 3
      @current_alert = []
    end

    def print_nothing
      print_final_report "No traffic\n"
    end

    def print_report(datas)
      report = "Most frequented sections:\n"
      datas[:sections].each do |section, hits|
        report += "    #{section} -> #{hits} hits\n"
      end
      report += "Most active visitors:\n"
      datas[:ips].each do |ip, hits|
        report += "    #{ip} -> #{hits} hits\n"
      end
      report += "Total traffic: #{convert_to_human(datas[:traffic])}\n"
      print_final_report report
    end

    def print_alert(hits, time)
      print "High traffic generated an alert - hits = #{hits},"\
            " triggered at #{time}\n".red
      @current_alert = [hits, time]
      @before_reminder = 3
    end

    def print_recover(hits, time)
      print_final "Recover from alert - last 2 min hits = #{hits},"\
                  " recovered at #{time}\n".green
      @old_alerts.push([@current_alert[1], time])
      @before_reminder = 3
      @current_alert = []
    end

    protected

    def print_final_report(report)
      print_final '-' * 36 + "\nReport at #{Time.now}:\n" + report
    end

    def print_final(s)
      unless @old_alerts.empty? && @current_alert.empty?
        if @before_reminder != 0
          @before_reminder -= 1
        else
          @before_reminder = 3
          s += alert_history
        end
      end
      print s
    end

    def convert_to_human(bytes)
      Filesize.from(bytes.to_s + ' B').pretty
    end

    def alert_history
      hist = ''
      @old_alerts.each do |s, e|
        hist += "Old alert: triggered at #{s}, recovered at #{e}\n".light_white
      end
      unless @current_alert.empty?
        hist += "Current alert : hits = #{@current_alert[0]},"\
             " triggered at #{@current_alert[1]}\n".red
      end
      hist
    end
  end
end
