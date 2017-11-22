class TicketsController < ApplicationController
    before_action :set_ticket, only: [:show, :edit, :update, :destroy]
    before_action :check_permission, only: [:show]
    after_action :update_ticket_logic, only: [:show]

    add_breadcrumb 'Tickets', :tickets_path

    # GET /tickets
    # GET /tickets.json
    def index
        @tickets = Ticket.all
    end

    # GET /tickets/1
    # GET /tickets/1.json
    def show
        add_breadcrumb @ticket.student.login, student_path(@ticket.student.login) + '#tickets'
        add_breadcrumb "Ticket #{@ticket.id}", ticket_path(@ticket)

        @answer = @ticket.messages.new
        @answer.assign_attributes(status: @ticket.status, category: @ticket.category)
        @ticket.update_last_read(current_user)
        gon.push({
                     ticket: @ticket
                 })
    end

    # GET /tickets/new
    def new
        @ticket = Ticket.new
    end

    # POST /tickets
    # POST /tickets.json
    def create
        @ticket = Ticket.new(ticket_params.to_hash.merge({user: current_user}))

        respond_to do |format|
            if @ticket.save
                format.html { redirect_to @ticket }
                format.json { render :show, status: :created, location: @ticket }
            else
                format.html { render :new }
                format.json { render json: @ticket.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /tickets/1
    # DELETE /tickets/1.json
    def destroy
        @ticket.destroy
        respond_to do |format|
            format.html { redirect_to tickets_url, success: 'Ticket was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    private
    def check_permission
        return if @ticket.is_assigned?(current_user)
        return if current_user.check_allowed(:dpra)
        redirect_to :root, notice: 'You was not allowed to visit this page'
    end

    def update_ticket_logic
        @ticket.vitisted_by(current_user)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_ticket
        @ticket = Ticket.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ticket_params
        params[:ticket].permit([:student_login, :title, :category, :description])
    end
end
