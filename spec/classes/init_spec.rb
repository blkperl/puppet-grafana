require 'spec_helper'
describe 'grafana' do
  context 'with defaults for all parameters' do
    it { should contain_class('grafana') }
  end
end
