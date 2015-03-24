module Kvm
  class Program

    attr_reader :objects, :entry_point

    def initialize(objects, entry_point)
      @objects = objects
      @entry_point = entry_point
    end

    def main_method
      obj_id, meth_id = entry_point.split('.')
      obj = get_object(obj_id)
      obj.get_object_method(meth_id)
    end

    def main_object
      obj_id, meth_id = entry_point.split('.')
      get_object(obj_id)
    end

    def get_object(id)
      @objects[id] || raise("Could not find object: #{id.inspect}")
    end

  end
end
