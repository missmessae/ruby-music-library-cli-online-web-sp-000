module Concerns::Findable
  def find_by_name(object)
    self.all.detect {|o| o.name == object}
  end

  def find_or_create_by_name(object)
    found_object = find_by_name(object)
    if found_object
      found_object
    else
      new_object = self.create(object)
    end
  end

end
