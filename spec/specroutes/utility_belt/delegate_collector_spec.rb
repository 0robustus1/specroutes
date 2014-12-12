require 'rails_helper'

describe Specroutes::UtilityBelt::DelegateCollector do
  let(:klass) do
    class ImplementingKlass
      include Specroutes::UtilityBelt::DelegateCollector::InstanceMethods
      extend Specroutes::UtilityBelt::DelegateCollector::ClassMethods
    end
    ImplementingKlass
  end

  let(:foo_proc) { proc { 'foo' } }
  let(:bar_proc) { proc { 'bar' } }

  context '.default_delegate_before' do
    it 'should initially be nil' do
      expect(klass.default_delegate_before).to be_nil
    end

    it 'should be the foo_proc afterwards' do
      klass.default_delegate_before(&foo_proc)
      expect(klass.default_delegate_before).to be(foo_proc)
    end
  end

  context '.default_delegate_after' do
    it 'should initially be nil' do
      expect(klass.default_delegate_after).to be_nil
    end

    it 'should be the bar_proc afterwards' do
      klass.default_delegate_after(&bar_proc)
      expect(klass.default_delegate_after).to be(bar_proc)
    end
  end

  context '#default_delegate_before' do
    let(:instance) { klass.new }

    it 'should be the bar_proc after setting it' do
      instance.default_delegate_before(&bar_proc)
      expect(instance.default_delegate_before).to be(bar_proc)
    end

    it 'should be equal to the class-methods result' do
      instance.default_delegate_before(&foo_proc)
      expect(instance.default_delegate_before).
        to be(klass.default_delegate_before)
    end
  end

  context '#default_delegate_after' do
    let(:instance) { klass.new }

    it 'should be the foo_proc after setting it' do
      instance.default_delegate_after(&foo_proc)
      expect(instance.default_delegate_after).to be(foo_proc)
    end

    it 'should be equal to the class-methods result' do
      instance.default_delegate_after(&foo_proc)
      expect(instance.default_delegate_after).
        to be(klass.default_delegate_after)
    end
  end

  context 'in referrals:' do
    let(:klass) do
      class HookClass
        include Specroutes::UtilityBelt::DelegateCollector::InstanceMethods
        extend Specroutes::UtilityBelt::DelegateCollector::ClassMethods

        hooked_refer_to :hooked
        refer_to :unhooked
      end
      HookClass
    end
    let(:instance) { klass.new }

    context '.hooked_refer_to' do
      let(:hooked_result) { {method: :hooked, hooks: true,
                             args: [], block: nil} }

      it 'should define a method' do
        expect(klass.method_defined?(:hooked)).to be_truthy
      end

      it 'when called it should append the right call to methods' do
        instance.hooked
        expect(instance.methods).to include(hooked_result)
      end
    end

    context '.refer_to' do
      let(:unhooked_result) { {method: :unhooked, hooks: false,
                               args: [], block: nil} }

      it 'should define a method' do
        expect(klass.method_defined?(:unhooked)).to be_truthy
      end

      it 'when called it should append the right call to methods' do
        instance.unhooked
        expect(instance.methods).to include(unhooked_result)
      end

    end
  end

  context 'Helper.method_name' do
    let(:helper) { Specroutes::UtilityBelt::DelegateCollector::Helper }
    let(:a_proc) { proc { |bar| "foo#{bar}" } }

    it 'should return explicit when provided' do
      expect(helper.method_name('foo', 'bar', nil)).to eq('foo')
    end

    it 'should call the proc with method otherwise' do
      expect(helper.method_name(nil, 'bar', a_proc)).to eq('foobar')
    end
  end
end
