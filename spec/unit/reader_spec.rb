require_relative '../spec_helper'

describe HttpdMonitoring::Reader do
  let(:data) { HttpdMonitoring::Data.new }
  let(:printer) { HttpdMonitoring::Printer.new }
  let(:logger) { Logger.new($stdout) }
  let(:alarm) { HttpdMonitoring::Alarm.new(data, printer, logger, 10) }
  let(:reader) { HttpdMonitoring::Reader.new(__FILE__, alarm) }

  it 'is instantiable' do
    expect(reader).to be_kind_of(HttpdMonitoring::Reader)
  end
end
