require "active_model/validations/clusivity"

module ActiveModel

  # == Active Model Exclusion Validator
  module Validations
    class ExclusionValidator < EachValidator
      include Clusivity

      def validate_each(record, attribute, value)
        if include?(record, value)
          record.errors.add(attribute, :exclusion, options.except(:in).merge!(:value => value))
        end
      end
    end

    module HelperMethods
      # Validates that the value of the specified attribute is not in a particular enumerable object.
      #
      #   class Person < ActiveRecord::Base
      #     validates_exclusion_of :username, :in => %w( admin superuser ), :message => "You don't belong here"
      #     validates_exclusion_of :age, :in => 30..60, :message => "This site is only for under 30 and over 60"
      #     validates_exclusion_of :format, :in => %w( mov avi ), :message => "extension %{value} is not allowed"
      #     validates_exclusion_of :password, :in => lambda { |p| [p.username, p.first_name] }, :message => "should not be the same as your username or first name"
      #   end
      #
      # Configuration options:
      # * <tt>:in</tt> - An enumerable object of items that the value shouldn't be part of.
      #   This can be supplied as a proc or lambda which returns an enumerable. If the enumerable
      #   is a range the test is performed with <tt>Range#cover?</tt>
      #   (backported in Active Support for 1.8), otherwise with <tt>include?</tt>.
      # * <tt>:message</tt> - Specifies a custom error message (default is: "is reserved").
      # * <tt>:allow_nil</tt> - If set to true, skips this validation if the attribute is +nil+ (default is +false+).
      # * <tt>:allow_blank</tt> - If set to true, skips this validation if the attribute is blank (default is +false+).
      # * <tt>:on</tt> - Specifies when this validation is active. Runs in all
      #   validation contexts by default (+nil+), other options are <tt>:create</tt>
      #   and <tt>:update</tt>.
      # * <tt>:if</tt> - Specifies a method, proc or string to call to determine if the validation should
      #   occur (e.g. <tt>:if => :allow_validation</tt>, or <tt>:if => Proc.new { |user| user.signup_step > 2 }</tt>). The
      #   method, proc or string should return or evaluate to a true or false value.
      # * <tt>:unless</tt> - Specifies a method, proc or string to call to determine if the validation should
      #   not occur (e.g. <tt>:unless => :skip_validation</tt>, or <tt>:unless => Proc.new { |user| user.signup_step <= 2 }</tt>). The
      #   method, proc or string should return or evaluate to a true or false value.
      # * <tt>:strict</tt> - Specifies whether validation should be strict.
      #   See <tt>ActiveModel::Validation#validates!</tt> for more information
      def validates_exclusion_of(*attr_names)
        validates_with ExclusionValidator, _merge_attributes(attr_names)
      end
    end
  end
end
