require 'rails_helper'

describe Specroutes::Constraints::HeaderConstraint do
  let(:constraint) { described_class.new(header, value) }
  let(:request) { double('request', headers: headers) }

  context 'with a value set' do
    let(:header) { 'API-Version' }
    let(:value) { 'v1' }

    context '#matches?' do
      context 'request with correct header-value combination' do
        let(:headers) { {header => value} }

        it 'should return true' do
          expect(constraint.matches?(request)). to be(true)
        end
      end

      context 'request with correct header but incorrect value' do
        let(:headers) { {header => "#{value}-butdifferent"} }

        it 'should return false' do
          expect(constraint.matches?(request)). to be(false)
        end
      end

      context 'request without header' do
        let(:headers) { {} }

        it 'should return false' do
          expect(constraint.matches?(request)). to be(false)
        end
      end
    end
  end

  context 'without a value set' do
    let(:header) { 'Content-Type' }
    let(:value) { nil }

    context '#matches?' do
      context 'request with correct header' do
        let(:headers) { {header => 'something'} }

        it 'should return false' do
          expect(constraint.matches?(request)). to be(true)
        end
      end

      context 'request without header' do
        let(:headers) { {} }

        it 'should return false' do
          expect(constraint.matches?(request)). to be(false)
        end
      end
    end
  end
end
