require_relative '../spec_helper'

describe HttpdMonitoring::CLI do
  let(:cli) do
    allow(File).to receive(:file?).and_return(true)
    allow(File).to receive(:readable?).and_return(true)
    HttpdMonitoring::CLI.new(['-l', '10', 'a'])
  end

  it 'is instantiable' do
    expect(cli).to be_kind_of(HttpdMonitoring::CLI)
  end

  describe '#run' do
    it 'launches EventMachine' do
      expect(EventMachine).to receive(:run)
      cli.run
    end
  end
end
