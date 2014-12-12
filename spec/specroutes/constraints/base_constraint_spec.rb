require 'rails_helper'

describe Specroutes::Constraints::BaseConstraint do
  let(:constraint) { described_class.new }

  context '#matches' do
    [nil, 'other', 1, Object.new].each do |val|
      it "should always return true (e.g. with #{val.inspect})" do
        expect(constraint.matches?(val)).to be(true)
      end
    end
  end

  context '#as_param!' do
    let(:params) { {} }
    let(:env) { {'action_dispatch.request.path_parameters' => params} }
    let(:request) { double('request', env: env) }

    it 'should contain no params in the env before' do
      expect(params).to be_empty
    end

    it 'should merge values into the params-hash' do
      constraint.send(:as_param!, request, key: 'value')
      expect(params).to include(key: 'value')
    end
  end
end
