module TranslateAttributes
    extend ActiveSupport::Concern

    def translate_attributes(attributes)
        self.class.translate_attributes(attributes)
    end

    module ClassMethods
        def translate_attributes(attributes)
            attributes = attributes.slice(*self::ATTRIBUTES)
            self::TRANSLATE_ATTRIBUTES.each do |k, v|
                attributes[v] = attributes[k] if attributes[k]
                attributes.delete(k)
            end
            attributes
        end
    end
end