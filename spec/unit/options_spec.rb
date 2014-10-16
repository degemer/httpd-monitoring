require_relative '../spec_helper'

describe HttpdMonitoring::Options do
  let(:options) do
    HttpdMonitoring::Options.new(['-l', '10', 'a', '-d', '-p', '2'])
  end
  let(:bad_options) do
    allow(File).to receive(:file?).and_return(false)
    options
  end
  let(:good_options) do
    allow(File).to receive(:file?).and_return(true)
    allow(File).to receive(:readable?).and_return(true)
    options
  end
  let(:standard_options) do
    allow(File).to receive(:file?).and_return(true)
    allow(File).to receive(:readable?).and_return(true)
    HttpdMonitoring::Options.new(['-l', '10', 'a'])
  end

  it 'aborts when limit is not given' do
    expect { HttpdMonitoring::Options.new([]) }.to exit_with_code(1)
  end

  it 'aborts when limit is not an integer' do
    expect { HttpdMonitoring::Options.new(['-l', 'd']) }.to exit_with_code(1)
  end

  it 'aborts when log file is not given' do
    expect { HttpdMonitoring::Options.new(['-l', '10']) }.to exit_with_code(1)
  end

  it 'aborts when log file is not a file' do
    expect { bad_options }.to exit_with_code(1)
  end

  it 'aborts when log file is not readable' do
    allow(File).to receive(:file?).and_return(true)
    allow(File).to receive(:readable?).and_return(false)
    expect { options }.to exit_with_code(1)
  end

  it 'does not exit when all args are ok' do
    expect { good_options }.to output(/httpd-monitoring/).to_stdout
  end

  it 'prints summary when all args are given' do
    expect(lambda { good_options }).to output(
      "httpd-monitoring started on file a with limit 10\n").to_stdout
  end

  it 'prints help when asked' do
    expect(lambda do
             begin
               HttpdMonitoring::Options.new(['-h'])
             rescue SystemExit => e
               print "Exited #{e.status}"
             end
           end).to output(/Display this help.+Exited 0/m).to_stdout
  end

  it 'prints version when asked' do
    expect(lambda do
             begin
               HttpdMonitoring::Options.new(['-v'])
             rescue SystemExit => e
               print "Exited #{e.status}"
             end
           end).to output(/httpd-monitoring.+Exited 0/m).to_stdout
  end

  describe '#limit_print' do
    it 'returns limit' do
      expect(good_options.limit_print).to eq(2)
    end

    it 'returns default limit when none is given' do
      expect(standard_options.limit_print).to eq(3)
    end
  end

  describe '#debug?' do
    it 'returns true if debug' do
      allow(File).to receive(:file?).and_return(true)
      expect(good_options.debug?).to be_truthy
    end

    it 'returns false if no debug' do
      allow(File).to receive(:file?).and_return(true)
      expect(standard_options.debug?).to be_falsey
    end
  end
end
