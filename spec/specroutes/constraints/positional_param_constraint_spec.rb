require 'rails_helper'

describe Specroutes::Constraints::PositionalParamConstraint do
  let(:allowed) { {"symbols" => 0} }
  let(:constraint) { described_class.new(allowed) }

  context '#matches?' do
    let(:params) { {} }
    let(:env) { {'action_dispatch.request.path_parameters' => params} }
    let(:original_fullpath) { "/simple" }
    let(:request) { double('request', env: env, original_fullpath: original_fullpath) }

    context 'with param at position' do
      let(:original_fullpath) { "/simple?symbols" }

      it 'should return true' do
        expect(constraint.matches?(request)).to be(true)
      end
    end

    context 'with param at position and additional param' do
      let(:original_fullpath) { "/simple?symbols&something=else" }

      it 'should return true' do
        expect(constraint.matches?(request)).to be(true)
      end
    end

    context 'with param at wrong position' do
      let(:original_fullpath) { "/simple?first;symbols" }

      it 'should return false' do
        expect(constraint.matches?(request)).to be(false)
      end
    end

    context 'with no param' do
      let(:original_fullpath) { "/simple" }

      it 'should return false' do
        expect(constraint.matches?(request)).to be(false)
      end
    end

  end
end
