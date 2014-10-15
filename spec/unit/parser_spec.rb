require_relative '../spec_helper'

describe HttpdMonitoring::Parser do
  describe '#parse_w3c' do
    it 'parses correct w3c line' do
      time = Time.now.round(0) # Round time to nearest second
      line = "64.242.88.10 - - [#{time.strftime('%d/%b/%Y:%H:%M:%S %z')}] "\
              "\"GET /twiki/bin/edit/?topic=Variables HTTP/1.1\" 401 846"
      hash_result = {
        host: '64.242.88.10',
        date: time,
        path: '/twiki',
        bytes: 846
      }
      expect(HttpdMonitoring::Parser.parse_w3c(line)).to eq(hash_result)
    end

    it 'returns nil when unable to recognize w3c line' do
      expect(HttpdMonitoring::Parser.parse_w3c('')).to be_nil
    end
  end

  describe '#parse_time' do
    it 'parses correct w3c time' do
      time = Time.now.round(0)
      expect(HttpdMonitoring::Parser.parse_time(
        time.strftime('%d/%b/%Y:%H:%M:%S %z'))).to eq(time)
    end

    it 'returns nil when unable to recognize w3c time' do
      expect(HttpdMonitoring::Parser.parse_time('')).to be_nil
    end
  end
end
