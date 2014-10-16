require_relative '../spec_helper'

describe HttpdMonitoring::Printer do
  let(:printer) { HttpdMonitoring::Printer.new }
  let(:time) { Time.now }
  let(:datas) do
    result = {}
    result[:sections] = [['/t', 250]]
    result[:ips] = [['10.10.10.10', 250]]
    result[:traffic] = 1_024
    result
  end

  describe '#print_nothing' do
    it 'prints that there is no traffic' do
      expect(lambda { printer.print_nothing }).to output(/No traffic/).to_stdout
    end
  end

  describe '#print_report' do
    it 'prints report from datas' do
      expect(lambda { printer.print_report(datas) }).to output(
        /\/t -> 250.+10\.10\.10\.10 -> 250.+Total traffic: 1.00 kiB/m).to_stdout
    end
  end

  describe '#print_alert' do
    it 'prints alert' do
      expect(lambda { printer.print_alert(10, time) }).to output(
        /alert - hits = 10, triggered at #{Regexp.quote(time.to_s)}/).to_stdout
    end

    it 'saves alert' do
      printer.print_alert(10, time)
      expect(printer.instance_variable_get(:@current_alert)).to eq([10, time])
    end
  end

  describe '#print_recover' do
    it 'prints recover' do
      expect(lambda { printer.print_recover(10, time) }).to output(
        /last 2 min hits = 10, recovered at #{Regexp.quote(time.to_s)}/).to_stdout
    end

    it 'saves recover' do
      printer.print_alert(10, time)
      n_time = time + 1
      printer.print_recover(10, n_time)
      expect(printer.instance_variable_get(:@current_alert)).to eq([])
      expect(printer.instance_variable_get(:@old_alerts)).to eq([[time, n_time]])
    end
  end
end
