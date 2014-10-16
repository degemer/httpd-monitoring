require_relative '../spec_helper'

describe HttpdMonitoring::Options do
  let(:good_options) { HttpdMonitoring::Options.new(['-l', '10', 'a']) }
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
    allow(File).to receive(:file?).and_return(false)
    expect { good_options }.to exit_with_code(1)
  end

  it 'does not exit when all args are ok' do
    allow(File).to receive(:file?).and_return(true)
    expect { good_options }.to output(/httpd-monitoring/).to_stdout
  end

  it 'prints summary when all args are given' do
    allow(File).to receive(:file?).and_return(true)
    expect(-> () { good_options }).to output(
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
end
