require_relative '../spec_helper'

describe HttpdMonitoring::Processor do
  let(:data) { HttpdMonitoring::Data.new }
  let(:printer) { HttpdMonitoring::Printer.new }
  let(:logger) { Logger.new($stdout) }
  let(:processor) { HttpdMonitoring::Processor.new(data, printer, logger, 10) }
  let(:time) { Time.now.round(0) }
  let(:line) do
    "64.242.88.10 - - [#{time.strftime('%d/%b/%Y:%H:%M:%S %z')}] "\
    "\"GET /twiki/bin/edit/?topic=Variables HTTP/1.1\" 401 846"
  end

  describe '#process' do
    it 'warn if parse failed' do
      expect(logger).to receive(:warn)
      processor.process('')
    end

    it 'insert data in Data if parse succeed' do
      expect(data).to receive(:insert)
      processor.process(line)
    end

    it 'triggers alert when threshold is reached' do
      allow(data).to receive(:hits_2min).and_return(11)
      expect(printer).to receive(:print_alert).with(11, time)
      processor.process(line)
    end

    it 'does not trigger alert when threshold is not reached' do
      allow(data).to receive(:hits_2min).and_return(9)
      expect(printer).to_not receive(:print_alert)
      processor.process(line)
    end

    it 'recovers alert when hits go under threshold' do
      allow(data).to receive(:hits_2min).and_return(11)
      processor.process(line)
      allow(data).to receive(:hits_2min).and_return(9)
      expect(printer).to receive(:print_recover).with(9, time)
      processor.process(line)
    end

    it 'does not recover alert when hits do notgo under threshold' do
      allow(data).to receive(:hits_2min).and_return(9)
      expect(printer).to_not receive(:print_recover)
      processor.process(line)
    end
  end
end
