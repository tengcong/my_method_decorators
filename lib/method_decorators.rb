# require "method_decorators/version"

module MethodDecorators
  # when define a instance_method, Module#method_added will be called
  def method_added(name)
    super

    p "add a method #{name}"

    # this return #<UnboundMethod: Counter#print_something>
    orig_method = instance_method(name)

    decorators = MethodDecorator.current_decorators
    return  if decorators.empty?

    # set visibility
    if    private_method_defined?(name);   visibility = :private
    elsif protected_method_defined?(name); visibility = :protected
    else                                   visibility = :public
    end

    define_method(name) do |*args, &blk|
      decorated = MethodDecorators.decorate_callable(orig_method.bind(self), decorators)
      decorated.call(*args, &blk)
    end

    # set visibility
    case visibility
    when :protected; protected name
    when :private;   private name
    end
  end

  def singleton_method_added(name)
    super
    orig_method = method(name)

    decorators = MethodDecorator.current_decorators
    return  if decorators.empty?

    MethodDecorators.define_others_singleton_method(self, name) do |*args, &blk|
      decorated = MethodDecorators.decorate_callable(orig_method, decorators)
      decorated.call(*args, &blk)
    end
  end

  # this part merge all decorators together
  # put all these together as a lambda
  # lambda store all these method call, when call lambda, then invoke all
  def self.decorate_callable(orig, decorators)
    p '0-' * 10
    p decorators.first.class
    decorators.reduce(orig) do |callable, decorator|
      lambda{ |*a, &b| decorator.call(callable, orig.receiver, *a, &b) }
    end
  end

  def self.define_others_singleton_method(klass, name, &blk)
    if klass.respond_to?(:define_singleton_method)
      klass.define_singleton_method(name, &blk)
    else
      class << klass
        self
      end.send(:define_method, name, &blk)
    end
  end
end

class MethodDecorator
  @@current_decorators = []

  def self.current_decorators
    p 'zxvsdfasdfasdfasdf'
    decs = @@current_decorators
    p decs
    @@current_decorators = []
    decs
  end

  def self.+@
    +new
  end

  def +@
    p '----===' * 10
    p self
    @@current_decorators.unshift(self)
  end
end
