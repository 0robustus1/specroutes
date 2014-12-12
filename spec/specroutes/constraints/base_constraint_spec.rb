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

  let(:uri) { '/simple?positional;key=value;other_positional;id=1' }
  let(:request) { double('request', original_fullpath: uri) }

  context '#query_params' do
    let(:query_params) { constraint.send(:query_params, request) }

    it 'should not contain "positional"' do
      expect(query_params.keys).to_not include('positional')
    end

    it 'should contain the key => value mapping' do
      expect(query_params).to include('key' => 'value')
    end

    it 'should not contain "other_positional"' do
      expect(query_params.keys).to_not include('other_positional')
    end

    it 'should contain the id => 1 mapping' do
      expect(query_params).to include('id' => '1')
    end
  end

  context '#positional_params' do
    let(:positional_params) { constraint.send(:positional_params, request) }

    it 'should contain "positional" as a to-index mapping' do
      expect(positional_params).to include('positional' => 0)
    end

    it 'should not contain "key" as a key' do
      expect(positional_params.keys).to_not include('key')
    end

    it 'should contain "other_positional" as a to-index mapping' do
      expect(positional_params).to include('other_positional' => 2)
    end

    it 'should not contain "id" as a key' do
      expect(positional_params.keys).to_not include('id')
    end
  end
end
