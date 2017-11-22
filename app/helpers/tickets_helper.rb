module TicketsHelper

    def count_by_enum(user, enum_name)
       tmp_result = {}
       enum_name = enum_name.to_s
        Ticket.method(enum_name.pluralize).call.each do |k,v|
            tmp_result[v] = {
                name: k,
                value:  0
            }
        end
        user.open_tickets.group(enum_name).count.each do |k, v|
            tmp_result[k][:value] = v
        end
        result = {}
        tmp_result.each do |k, v|
            result[v[:name]] = v[:value]
        end
        result.symbolize_keys!
    end

    def class_by_enum(hash)
        result = {}
        hash.each do |k, v|
            result[k] = ''
            result[k] = 'disabled' if v == 0
        end
        result
    end
end
