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

  context '#depth' do
    it 'should be zero for the root-node' do
      expect(tree.depth).to eq(0)
    end

    it 'should be 1 for the first child-node' do
      expect(foo_child.depth).to eq(1)
    end

    it 'should equal the one of a sibling' do
      expect(foo_child.depth).to eq(bar_child.depth)
    end
  end

  context '#path' do
    it 'should be the path_portion on the root node' do
      expect(tree.path).to eq(tree.path_portion)
    end

    it 'should be the correct path for a child node' do
      expect(foo_child.path).to eq('/foo')
    end
  end

  context '#children' do
    it 'should have the correct children on the root node' do
      expect(tree.children).to include(foo_child, bar_child)
    end
  end
end
