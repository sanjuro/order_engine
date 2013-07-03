# module ActiveRecordExtensions
#   def self.included(base)
#     base.extend(ClassMethods)
#   end

#     # Update attributes of a record in the database without callbacks, validations etc.
#     def update_attributes_without_callbacks(attributes)
#       self.assign_attributes(attributes, :without_protection => true)
#       self.class.update_all(attributes, { :id => id })
#     end

#     # Update a single attribute in the database
#     def update_attribute_without_callbacks(name, value)
#       send("#{name}=", value)
#       update_attributes_without_callbacks(name => value)
#     end

#   module ClassMethods
#     # add your static(class) methods here
#     # Update attributes of a record in the database without callbacks, validations etc.
#     def update_attributes_without_callbacks(attributes)
#       self.assign_attributes(attributes, :without_protection => true)
#       self.class.update_all(attributes, { :id => id })
#     end

#     # Update a single attribute in the database
#     def update_attribute_without_callbacks(name, value)
#       send("#{name}=", value)
#       update_attributes_without_callbacks(name => value)
#     end
#   end
# end
module ActiveRecord::Persistence

  # Update attributes of a record in the database without callbacks, validations etc.
  def update_attributes_without_callbacks(attributes)
    self.assign_attributes(attributes, :without_protection => true)
    self.class.update_all(attributes, { :id => id })
  end

  # Update a single attribute in the database
  def update_attribute_without_callbacks(name, value)
    send("#{name}=", value)
    update_attributes_without_callbacks(name => value)
  end

end
