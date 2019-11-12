module LumosService::Core
  extend ActiveSupport::Concern

  included do
    include ActiveSupport::Callbacks
    define_callbacks :call, :success, :fail
    attr_accessor :error, :error_code

    def success?
      fail!('Service was not called yet') if @service_success.nil?
      @service_success
    end

    def fail?
      !success?
    end

    def fail!(error = nil, error_code = nil)
      @error = error
      @error_code = error_code
      raise LumosService::ServiceError
    end

    def on_success
      yield self if block_given? && success?
      self
    end

    def on_fail
      yield self if block_given? && fail?
      self
    end

    private

    def service_success=(result)
      @service_success = result
    end
  end

  class_methods do
    def after_call(*filters, &blk)
      set_callback(:call, :after, *filters, &blk)
    end

    def around_call(*filters, &blk)
      set_callback(:call, :around, *filters, &blk)
    end

    def before_call(*filters, &blk)
      set_callback(:call, :before, *filters, &blk)
    end

    def after_success(*filters, &blk)
      set_callback(:success, :after, *filters, &blk)
    end

    def after_fail(*filters, &blk)
      set_callback(:fail, :after, *filters, &blk)
    end

    def call(*args)
      instance = new
      instance.run_callbacks :call do
        begin
          instance.call(*args)
          run_callbacks_and_set_result(instance, true, :success)
        rescue LumosService::ServiceError
          run_callbacks_and_set_result(instance, false, :fail)
        rescue Exception => e
          run_callbacks_and_set_result(instance, false, :fail)
          Rollbar.error(e)
          raise e
        end
      end
      instance
    end

    def run_callbacks_and_set_result(instance, result, callbacks)
      instance.send(:service_success=, result)
      instance.run_callbacks callbacks
    end
  end
end
