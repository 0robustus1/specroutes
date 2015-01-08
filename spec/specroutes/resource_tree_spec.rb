require 'rails_helper'

describe Specroutes::ResourceTree do
  let(:tree) { described_class.new('/') }
  let!(:foo_child) { described_class.new('foo', tree) }
  let!(:bar_child) { described_class.new('bar', tree) }

  context 'when adding a non-fitting element' do
    it 'should raise the appropriate error' do
      expect { foo_child.branch!('non-fitting', nil) }.
        to raise_error(Specroutes::ResourceTree::DoesNotFitError)
    end
  end

  context 'when adding a fitting element' do
    it 'should raise no error' do
      expect { foo_child.branch!('/bar/dar', nil) }.
        to_not raise_error
    end
  end
end
