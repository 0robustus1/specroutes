require 'rails_helper'

describe Specroutes::Constraints::MimeTypeConstraint do
  let(:constraint) do
    described_class.new(*mime_types, accept_allstar: allstar)
  end
  let(:request) { double('request', accepts: accepted) }

  context '#matches?' do
    context 'with allstar' do
      let(:mime_types) { [] }
      let(:allstar) { true }

      context 'and an allstar request' do
        let(:accepted) { [nil] }

        it 'should return true' do
          expect(constraint.matches?(request)).to be(true)
        end
      end

      context 'and a normal request' do
        let(:accepted) { %w(text/plain) }

        it 'should return false for any type not in list' do
          expect(constraint.matches?(request)).to be(false)
        end
      end
    end

    context 'without allstar' do
      let(:mime_types) { %w(text/plain application/json) }
      let(:allstar) { false }

      context 'and mime type is in list' do
        let(:accepted) { %w(text/plain) }

        it 'should return true if mime type is in list' do
          expect(constraint.matches?(request)).to be(true)
        end
      end

      context 'and mime type is not in list' do
        let(:accepted) { %w(text/html) }

        it 'should return false if mime type is not in list' do
          expect(constraint.matches?(request)).to be(false)
        end
      end
    end
  end
end
