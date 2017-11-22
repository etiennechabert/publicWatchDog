class Ticket < ActiveRecord::Base
    belongs_to :student
    belongs_to :user
    belongs_to :last_message, class_name: TicketMessage
    has_many :messages, class_name: TicketMessage
    has_many :ticket_assignations
    has_many :users, through: :ticket_assignations

    enum category: [ :technical, :coaching, :adm ]
    enum status: [ :new_one, :working_on, :pending, :solved, :not_a_problem ]

    OPEN_TICKET = [ Ticket.statuses[:new_one], Ticket.statuses[:working_on], Ticket.statuses[:pending] ]
    CLOSE_TICKET = [ Ticket.statuses[:solved], Ticket.statuses[:not_a_problem] ]
    COLOR_TICKET = [ '#4c0000', '#391300', '#262600', '#133900', '#4c0000']

    attr_accessor :student_login

    before_create :update_fields
    after_create :assign_ticket

    ##### Getter helper ######

    def self.not_solved(student)
        student.tickets.where.not(status: Ticket.statuses[:solved])
    end

    def status_value
        Ticket.statuses[self.status]
    end

    def is_assigned?(user)
        self.users.where(id: user.id).length == 1
    end

    def assign_to(user, assignator=nil)
        tmp_users_nb = self.users.length
        self.users << user
        return if tmp_users_nb == self.users.length
        if assignator
            TicketMessage.create(user: assignator, message: "I assigned #{user.login} on this case", ticket: self)
        else
            TicketMessage.create(user: user, message: "I assigned myself on this case", ticket: self)
        end
    end

    def remove_assignation(user)
        assignation = self.ticket_assignations.where(user: user).first
        if assignation
            TicketMessage.create(user: user, message: "I am not following this case anymore", ticket: self)
        end
        assignation.destroy
    end

    def possible_assignations(research)
        User.where.not(id: users.map { |user| user.id}).where("login LIKE '#{research}%'")
    end

    def active_assignations
        self.ticket_assignations.where(ignored: false)
    end

    def update_last_read(user)
        assignation = self.ticket_assignations.find_by_user_id(user.id)
        return unless assignation
        message = self.messages.where.not(id: nil).last
        return assignation.update_attribute(:last_read_message_id, 0) unless message
        assignation.update_attribute(:last_read_message, message)
    end

    def unread_messages(user)
        messages = self.messages
        assignation = self.ticket_assignations.find_by(user: user)
        messages = messages.where("id > #{assignation.last_read_message_id}") if assignation
        messages
    end

    def user_messages(user)
        self.messages.where(user: user)
    end

    def vitisted_by(current_user)
        assignation = self.ticket_assignations.find_by(user: current_user)
        return unless assignation
        assignation.update_attributes({last_read_message_id: self.last_message_id, last_visit: DateTime.now})
    end

    private
    def update_fields
        return false unless student_login
        self.student = Student.find_by_login(student_login)
        true
    end

    def create_first_message
        self.last_message = self.messages.new(user: self.user, message: description)
        self.save
    end

    def assign_ticket
        self.ticket_assignations.transaction do
            self.ticket_assignations.create(user: self.user, last_read_message: self.last_message) # Let's assign the creator of the ticket
            self.student.users.each do |user| # Let's assign all users following these students
                self.ticket_assignations.find_or_create_by(user: user)
            end
        end
    end
end
