require_relative '../spec_helper'

describe HttpdMonitoring::Reporter do
  let(:data) { HttpdMonitoring::Data.new }
  let(:printer) { HttpdMonitoring::Printer.new }
  let(:reporter) { HttpdMonitoring::Reporter.new(data, printer, 1) }
  let(:fake_datas) do
    result = {}
    result[:sections] = { '/t' => 250, '/y' => 10 }
    result[:ips] = { '10.10.10.10' => 250, 'dns' => 20 }
    result[:traffic] = 10_000
    result
  end
  let(:fake_result) do
    result = {}
    result[:sections] = [['/t', 250]]
    result[:ips] = [['10.10.10.10', 250]]
    result[:traffic] = 10_000
    result
  end

  before(:all) { $stdout = StringIO.new }
  after(:all) { $stdout = STDOUT }

  describe '#report' do
    it 'gets data from Data' do
      allow(data).to receive(:select_data_10s).and_return(traffic: 0)
      expect(data).to receive(:select_data_10s)
      reporter.report
    end

    it 'calls print_nothing when nothing happened' do
      allow(data).to receive(:select_data_10s).and_return(traffic: 0)
      expect(printer).to receive(:print_nothing)
      reporter.report
    end

    it 'parse data and send them to Printer' do
      allow(data).to receive(:select_data_10s).and_return(fake_datas)
      expect(printer).to receive(:print_report).with(fake_result)
      reporter.report
    end
  end
end
