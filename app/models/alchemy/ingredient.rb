# frozen_string_literal: true

module Alchemy
  class Ingredient < BaseRecord
    class DefinitionError < StandardError; end

    self.abstract_class = true
    self.table_name = "alchemy_ingredients"

    belongs_to :element, class_name: "Alchemy::Element", inverse_of: :ingredients
    belongs_to :related_object, polymorphic: true, optional: true

    validates :type, presence: true
    validates :role, presence: true

    class << self
      # Builds concrete ingredient class as described in the +elements.yml+
      def build(attributes = {})
        element = attributes[:element]
        raise ArgumentError, "No element given. Please pass element in attributes." if element.nil?
        raise ArgumentError, "No role given. Please pass role in attributes." if attributes[:role].nil?

        definition = element.ingredient_definition_for(attributes[:role])
        if definition.nil?
          raise DefinitionError,
            "No definition found for #{attributes[:role]}. Please define #{attributes[:role]} on #{element[:name]}."
        end

        ingredient_class = Ingredient.ingredient_class_by_type(definition[:type])
        ingredient_class.new(
          type: Ingredient.normalize_type(definition[:type]),
          value: definition[:default],
          role: definition[:role],
          element: element,
        )
      end

      # Creates concrete ingredient class as described in the +elements.yml+
      def create(attributes = {})
        build(attributes).tap(&:save)
      end

      # Defines getters and setter methods for ingredient attributes
      def ingredient_attributes(*attributes)
        attributes.each do |name|
          define_method name.to_sym do
            data[name]
          end
          define_method "#{name}=" do |value|
            data[name] = value
          end
        end
      end

      # Defines getter and setter method aliases for related object
      def related_object_alias(name)
        alias_method name, :related_object
        alias_method "#{name}=", :related_object=
      end

      # Returns an ingredient class by type
      #
      # Raises ArgumentError if there is no such class in the
      # +Alchemy::Ingredients+ module namespace.
      #
      # If you add custom ingredient class,
      # put them in the +Alchemy::Ingredients+ module namespace
      #
      # @param [String] The ingredient class name to constantize
      # @return [Class]
      def ingredient_class_by_type(ingredient_type)
        Alchemy::Ingredients.const_get(ingredient_type.to_s.classify.demodulize)
      end

      # Modulize ingredient type
      #
      # Makes sure the passed ingredient type is in the +Alchemy::Ingredients+
      # module namespace.
      #
      # If you add custom ingredient class,
      # put them in the +Alchemy::Ingredients+ module namespace
      # @param [String] Ingredient class name
      # @return [String]
      def normalize_type(ingredient_type)
        "Alchemy::Ingredients::#{ingredient_type.to_s.classify.demodulize}"
      end
    end

    # Compatibility method for access from element
    def essence
      self
    end

    # The value or the related object if present
    def value
      related_object || self[:value]
    end

    # Settings for this ingredient from the +elements.yml+ definition.
    def settings
      definition[:settings] || {}
    end

    # Fetches value from settings
    #
    # @param key [Symbol]               - The hash key you want to fetch the value from
    # @param options [Hash]             - An optional Hash that can override the settings.
    #                                     Normally passed as options hash into the content
    #                                     editor view.
    def settings_value(key, options = {})
      settings.merge(options || {})[key.to_sym]
    end

    # Definition hash for this ingredient from +elements.yml+ file.
    #
    def definition
      return {} unless element

      element.ingredient_definition_for(role) || {}
    end

    # The first 30 characters of the value
    #
    # Used by the Element#preview_text method.
    #
    # @param [Integer] max_length (30)
    #
    def preview_text(maxlength = 30)
      value.to_s[0..maxlength - 1]
    end

    # Cross DB adapter data accessor that works
    def data
      @_data ||= (self[:data] || {}).with_indifferent_access
    end

    # The path to the view partial of the ingredient
    # @return [String]
    def to_partial_path
      "alchemy/ingredients/#{partial_name}_view"
    end

    # The demodulized underscored class name of the ingredient
    # @return [String]
    def partial_name
      self.class.name.demodulize.underscore
    end

    # @return [Boolean]
    def has_validations?
      !!definition[:validate]
    end

    # @return [Boolean]
    def has_hint?
      !!definition[:hint]
    end

    # @return [Boolean]
    def deprecated?
      !!definition[:deprecated]
    end
  end
end
