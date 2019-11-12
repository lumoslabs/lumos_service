RSpec.describe LumosService::Core do
  class ServiceClass
    include LumosService::Core

    attr_accessor :after_success_var, :after_fail_var, :after_call_var, :before_call_array

    before_call do
      @before_call_array = [:before_call]
    end

    after_success do
      @after_success_var = :after_success
    end

    after_fail do
      @after_fail_var = :after_fail
    end

    after_call do
      @after_call_var = :after_call
      @before_call_array << :after_call
    end

    def call(should_fail:)
      if should_fail
        fail!
      else
        true
      end
    end
  end

  context '.call' do
    it 'should be an instance of ServiceClass' do
      service = ServiceClass.call(should_fail: false)
      expect(service.is_a?(ServiceClass)).to eq(true)
    end

    it 'should be success' do
      service = ServiceClass.call(should_fail: false)
      expect(service.success?).to eq(true)
      expect(service.fail?).to eq(false)
    end

    it 'should fail' do
      service = ServiceClass.call(should_fail: true)
      expect(service.fail?).to eq(true)
      expect(service.success?).to eq(false)
    end

    it 'should respond to .success?' do
      service = ServiceClass.call(should_fail: false)
      expect(service.respond_to?(:success?)).to eq(true)
    end

    it 'should respond to .fail?' do
      service = ServiceClass.call(should_fail: false)
      expect(service.respond_to?(:fail?)).to eq(true)
    end
  end

  context 'callbacks' do
    it '.after_success' do
      service = ServiceClass.call(should_fail: false)
      expect(service.success?).to eq(true)
      expect(service.after_success_var).to eq(:after_success)
      expect(service.after_fail_var).to eq(nil)
    end

    it '.after_fail' do
      service = ServiceClass.call(should_fail: true)
      expect(service.fail?).to eq(true)
      expect(service.after_fail_var).to eq(:after_fail)
      expect(service.after_success_var).to eq(nil)
    end

    it '.before_call' do
      service = ServiceClass.call(should_fail: false)
      expect(service.success?).to eq(true)
      expect(service.before_call_array).to eq(%i(before_call after_call))
    end

    context '.after_call' do
      it 'when success' do
        service = ServiceClass.call(should_fail: false)
        expect(service.success?).to eq(true)
        expect(service.after_call_var).to eq(:after_call)
      end

      it 'when fail' do
        service = ServiceClass.call(should_fail: true)
        expect(service.fail?).to eq(true)
        expect(service.after_call_var).to eq(:after_call)
      end
    end
  end
end
