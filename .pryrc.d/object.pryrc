# frozen_string_literal: true

# Return a list of methods defined locally for a particular object.  Useful
# for seeing what it does whilst losing all the guff that's implemented
# by its parents (eg Object).
class Object
  def local_methods(obj = self)
    (obj.methods - obj.class.superclass.instance_methods).sort
  end
end

# pretty much the same as `local_methods` minus the constructors, etc
class Object
  def interesting_methods
    case self.class
    when Class
      self.public_methods.sort - Object.public_methods
    when Module
      self.public_methods.sort - Module.public_methods
    else
      self.public_methods.sort - Object.new.public_methods
    end
  end
end
