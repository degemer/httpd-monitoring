require_relative '../spec_helper'

describe HttpdMonitoring::Data do
  before(:all) { @time = Time.now.round(0) }
  let(:datas) do
    result = {}
    result[:host] = '64.242.88.10'
    result[:date] = @time
    result[:path] = '/sec'
    result[:bytes] = 200
    result
  end
  let(:data) { HttpdMonitoring::Data.new }

  describe '#insert' do
    it 'updates all 10s datas' do
      data.insert(datas)
      expect(data.instance_variable_get(:@sections_10s)).to eq('/sec' => 1)
      expect(data.instance_variable_get(:@traffic_10s)).to eq(200)
      expect(data.instance_variable_get(:@ips_10s)).to eq('64.242.88.10' => 1)
    end

    it 'updates all 2min datas' do
      data.insert(datas)
      expect(data.instance_variable_get(:@last_time)).to eq(@time)
      expect(data.instance_variable_get(:@hits_2min)).to eq(1)
      expect(data.instance_variable_get(:@times_2min)).to eq(@time => 1)
    end
  end

  describe '#select_data_10s' do
    it 'returns all 10s datas' do
      data.insert(datas)
      expect(data.select_data_10s).to eq(
        sections: { '/sec' => 1 },
        traffic: 200,
        ips: { '64.242.88.10' => 1 }
      )
    end

    it 'clears all 10s datas' do
      data.insert(datas)
      data.select_data_10s
      expect(data.instance_variable_get(:@sections_10s)).to eq({})
      expect(data.instance_variable_get(:@traffic_10s)).to eq(0)
      expect(data.instance_variable_get(:@ips_10s)).to eq({})
    end
  end

  describe '#delete_old_2min' do
    it 'clears data > 2 min' do
      data.insert(datas)
      datas[:date] += 60
      data.insert(datas)
      new_time = @time + 121
      data.instance_eval { delete_old_2min(new_time) }
      expect(data.instance_variable_get(:@hits_2min)).to eq(1)
      expect(data.instance_variable_get(:@times_2min)).to eq(@time + 60 => 1)
    end
  end
end
