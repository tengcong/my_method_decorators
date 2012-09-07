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
end

c = Counter.new
c.print_something
