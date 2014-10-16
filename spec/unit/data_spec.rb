require_relative '../spec_helper'

describe HttpdMonitoring::Data do
  let(:datas) do
    result = {}
    result[:host] = '64.242.88.10'
    result[:date] = Time.now.round(0)
    result[:path] = '/sec'
    result[:bytes] = 200
    result
  end
  let(:data) { HttpdMonitoring::Data.new }

  describe '#insert' do
    it 'updates all 10s datas'

    it 'updates all 2min datas'
  end

  describe '#select_data_10s' do
    it 'returns all 10s datas'

    it 'clears all 10s datas'
  end
end
