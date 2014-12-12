require_relative '../../spec_helper'

describe Lita::Handlers::WolframAlpha, :lita_handler => true do

  it { is_expected.to route('!alpha') }

end
