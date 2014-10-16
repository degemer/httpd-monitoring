module HttpdMonitoring
  # Parse and generate ready-to-print data for report
  class Reporter
    def initialize(data, printer, limit_print)
      @data = data
      @printer = printer
      @limit_print = limit_print
    end

    def report
      datas = @data.select_data_10s
      if datas[:traffic] != 0
        @printer.print_report(analyse_data(datas))
      else
        @printer.print_nothing
      end
    end

    protected

    def analyse_data(data)
      sections_sorted = data[:sections].sort_by { |_section, hits| hits }.reverse!
      ips_sorted = data[:ips].sort_by { |_ip, traffic| traffic }.reverse!
      { ips: ips_sorted[0...@limit_print],
        sections: sections_sorted[0...@limit_print],
        traffic: data[:traffic] }
    end
  end
end
