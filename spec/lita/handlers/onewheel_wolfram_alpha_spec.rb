require_relative '../../spec_helper'

def mock_fixture(fixture)
  mock_xml = File.open("spec/fixtures/#{fixture}.xml").read
  allow(RestClient).to receive(:get) { mock_xml }
end

describe Lita::Handlers::OnewheelWolframAlpha, :lita_handler => true do

  before(:each) do
    # mock_geocoder = ::Geocoder::Result::Google.new({'formatted_address' => 'Portland, OR', 'geometry' => { 'location' => { 'lat' => 45.523452, 'lng' => -122.676207 }}})
    # allow(::Geocoder).to receive(:search) { [mock_geocoder] }  # It expects an array of geocoder objects.

    registry.configure do |config|
      config.handlers.onewheel_wolfram_alpha.api_uri = 'http://api.wolframalpha.com/v2/query?input=[query]&appid=[appid]'
      config.handlers.onewheel_wolfram_alpha.app_id = 'app-id-here'
    end
  end

  it 'will work' do
    mock_fixture('pi')
    send_command 'a pi'
    expect(replies.last).to eq('3.141592653589793238462643383279502884197169399375105820974...')
  end

  it 'shouldnt route other words' do
    mock_fixture('pi')
    send_command 'animate pi'
    expect(replies.last).to eq(nil)
  end

  it 'will fail gracefully' do
    mock_fixture('boopadoop')
    send_command 'a boopadoop'
    expect(replies.last).to satisfy { |v|
      ['Nope, no boopadoop to see here.',
       'What\'s that, now?',
       'boopadoop?'].include? v
    }
  end

  it 'will print plot for mathy things' do
    mock_fixture('x^2')
    send_command 'a x^2'
    expect(replies.last).to eq('http://www2.wolframalpha.com/Calculate/MSP/MSP8620hdi8ba18h005cd0000268f85ce36b8h331?MSPStoreType=image/gif&s=15')
  end

  it 'will error missing config' do
    registry.configure do |config|
      config.handlers.onewheel_wolfram_alpha.api_uri = 'http://api.wolframalpha.com/v2/query?input=[query]&appid=[appid]'
      config.handlers.onewheel_wolfram_alpha.app_id = nil
    end
    send_command 'a pi'
    expect(replies.last).to eq(nil)
  end

  it 'will single-line a multi-line plaintext' do
    mock_fixture('multiline-plaintext')
    send_command 'a light years'
    expect(replies.last).to eq('1 ly | 0.3066 pc  (parsecs) | 63241 au  (astronomical units) | 9.461&#xD7;10^12 km  (kilometers) | 9.461&#xD7;10^15 meters | 5.879 trillion miles')
  end

  it 'will add desired text to the end' do
    mock_fixture('x^2')
    send_command 'a x^2 <as a service>'
    expect(replies.last).to eq('http://www2.wolframalpha.com/Calculate/MSP/MSP8620hdi8ba18h005cd0000268f85ce36b8h331?MSPStoreType=image/gif&s=15 as a service')
  end


end
