require 'rails_helper'

describe Specroutes::UtilityBelt::StateBasedEquality do
  context 'with default implementation of equality_state' do
    let(:klass) do
      class SBE_ImplementingKlass_01
        include Specroutes::UtilityBelt::StateBasedEquality

        def initialize(a, b)
          @a, @b = a, b
        end
      end
      SBE_ImplementingKlass_01
    end

    let(:instance) { klass.new(1, 2) }
    let(:equal_instance) { klass.new(1, 2) }
    let(:inequal_instance) { klass.new(2, 1) }

    context '#==' do
      it 'should accept identity as equality' do
        expect(instance == instance).to be(true)
      end

      it 'should recognize attribute-based equality' do
        expect(instance == equal_instance).to be(true)
      end

      it 'should recognize inequality' do
        expect(instance == inequal_instance).to be(false)
      end
    end

    context '#eql?' do
      it 'should accept identity as equality' do
        expect(instance == instance).to be(true)
      end

      it 'should recognize equality_state based equality' do
        expect(instance == equal_instance).to be(true)
      end

      it 'should recognize inequality' do
        expect(instance == inequal_instance).to be(false)
      end
    end

    context '#hash' do
      it 'should accept identity as equality' do
        expect(instance.hash == instance.hash).to be(true)
      end

      it 'should recognize equality_state based equality' do
        expect(instance.hash == equal_instance.hash).to be(true)
      end

      it 'should recognize inequality' do
        expect(instance.hash == inequal_instance.hash).to be(false)
      end
    end
  end

  context 'with custom implementation of equality_state' do
    let(:klass) do
      class SBE_ImplementingKlass_02
        include Specroutes::UtilityBelt::StateBasedEquality

        def initialize(a, b)
          @a, @b = a, b
        end

        def equality_state
          @a
        end
      end
      SBE_ImplementingKlass_02
    end

    let(:instance) { klass.new(1, 2) }
    let(:equal_instance) { klass.new(1, 3) }
    let(:inequal_instance) { klass.new(2, 1) }

    context '#==' do
      it 'should accept identity as equality' do
        expect(instance == instance).to be(true)
      end

      it 'should recognize equality_state based equality' do
        expect(instance == equal_instance).to be(true)
      end

      it 'should recognize inequality' do
        expect(instance == inequal_instance).to be(false)
      end
    end

    context '#eql?' do
      it 'should accept identity as equality' do
        expect(instance == instance).to be(true)
      end

      it 'should recognize equality_state based equality' do
        expect(instance == equal_instance).to be(true)
      end

      it 'should recognize inequality' do
        expect(instance == inequal_instance).to be(false)
      end
    end

    context '#hash' do
      it 'should accept identity as equality' do
        expect(instance.hash == instance.hash).to be(true)
      end

      it 'should recognize equality_state based equality' do
        expect(instance.hash == equal_instance.hash).to be(true)
      end

      it 'should recognize inequality' do
        expect(instance.hash == inequal_instance.hash).to be(false)
      end
    end
  end
end
