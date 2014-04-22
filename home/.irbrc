# return a sorted list of methods minus those which are inherited from Object
class Object
  def interesting_methods
    (self.methods - Object.instance_methods).sort
  end
end

# return an Array of random numbers
class Array
  def self.test_list(n)
    a = []
    n.times { a << rand(0..100) } 
    a
  end
end

# return a Hash of symbols to random numbers
class Hash
  def self.test_list
    Array(:a..:z).each_with_object({}) {|x,h| h[x] = rand(100) }
  end
end
