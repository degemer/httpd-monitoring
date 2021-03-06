module HttpdMonitoring
  # Handle output format (except log)
  class Printer
    REMINDER_DELAY  = 3
    def initialize
      @old_alerts = []
      @before_reminder = REMINDER_DELAY
      @current_alert = []
    end

    # Print that nothing happened
    def print_nothing
      print_final_report "No traffic\n"
    end

    # Generate report string from prepared datas and print it
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

    # Print alert and stock it
    def print_alert(hits, time)
      print "High traffic generated an alert - hits = #{hits},"\
            " triggered at #{time}\n".red
      @current_alert = [hits, time]
      @before_reminder = REMINDER_DELAY
    end

    # Print recover, cancel last alert and stock it
    def print_recover(hits, time)
      print_final "Recover from alert - last 2 min hits = #{hits},"\
                  " recovered at #{time}\n".green
      @old_alerts.push([@current_alert[1], time])
      @before_reminder = REMINDER_DELAY
      @current_alert = []
    end

    private

    # Add a header to all report
    def print_final_report(report)
      print_final '-' * 36 + "\nReport at #{Time.now}:\n" + report
    end

    # Add regularly alerts history to report to keep alerts always visible
    def print_final(s)
      unless @old_alerts.empty? && @current_alert.empty?
        if @before_reminder != 0
          @before_reminder -= 1
        else
          @before_reminder = REMINDER_DELAY
          s += alert_history
        end
      end
      print s
    end

    # Convert bytes to best unit
    def convert_to_human(bytes)
      Filesize.from(bytes.to_s + ' B').pretty
    end

    # Return alerts history (old and current alerts)
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
