module Refreshable
    extend ActiveSupport::Concern

    def mark_as_refresh
        self.update_attribute(:crawler_stamp, Date.today)
    end

    def mark_as_not_refresh
        self.update_attribute(:crawler_stamp, '0001-01-01')
    end

    def check_hash(attribute_name, content)
        Digest::MD5.hexdigest(content.to_json) == self[attribute_name]
    end

    def update_hash(attribute_name, content)
        self.update_attribute(attribute_name, Digest::MD5.hexdigest(content.to_json))
    end

    module ClassMethods
        def need_refresh?
            !refresh_selection.empty?
        end
    end
end