require_relative '../../spec_helper'

describe Lita::Handlers::OnewheelWolframAlpha, :lita_handler => true do

  before(:each) do
    # mock_geocoder = ::Geocoder::Result::Google.new({'formatted_address' => 'Portland, OR', 'geometry' => { 'location' => { 'lat' => 45.523452, 'lng' => -122.676207 }}})
    # allow(::Geocoder).to receive(:search) { [mock_geocoder] }  # It expects an array of geocoder objects.

    # Mock up the Wolfram Alpha call.
    mock_xml = File.open('spec/fixtures/pi.xml').read
    allow(RestClient).to receive(:get) { mock_xml }

    registry.configure do |config|
      config.handlers.onewheel_wolfram_alpha.api_uri = 'http://api.wolframalpha.com/v2/query?input=[query]&appid=[appid]'
      config.handlers.onewheel_wolfram_alpha.app_id = 'app-id-here'
    end
  end

  it { is_expected.to route_command('alpha') }

  it 'will work' do
    send_command 'alpha pi'
    expect(replies.last).to eq('3.141592653589793238462643383279502884197169399375105820974...')
  end

  it 'will error missing config' do
    registry.configure do |config|
      config.handlers.onewheel_wolfram_alpha.api_uri = 'http://api.wolframalpha.com/v2/query?input=[query]&appid=[appid]'
      config.handlers.onewheel_wolfram_alpha.app_id = nil
    end
    send_command 'alpha pi'
    expect(replies.last).to eq(nil)
  end
end
