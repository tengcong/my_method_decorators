require '../lib/method_decorators.rb'
require '../lib/method_decorators/decorators.rb'

class Counter
  extend MethodDecorators
  @@count = 0

  +Within.new(3)
  +Retry.new(3)
  def print_something
    # p "#{@@count}"
    @@count += 1
    if @@count < 2
      raise 'xzcvzxcv'
    end
  end

  +Memoize
  def method_a
  end
end

c = Counter.new
# c.print_something
c.method_a
