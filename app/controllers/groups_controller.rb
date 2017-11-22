class GroupsController < ApplicationController

    before_action :set_group, only: [
                                :show,
                                :edit,
                                :update
                            ]

    add_breadcrumb 'Home', :root_path
    add_breadcrumb 'Groups', :groups_path

    def index
        @groups = Group.all
    end

    def show
        add_breadcrumb @group.title, group_path(@group)
    end

    def edit
        add_breadcrumb @group.title, group_path(@group)
        add_breadcrumb 'Edit', edit_group_path(@group)
    end

    def update
        redirect_to edit_group_path(@group) unless request.patch?
        redirect_to edit_group_path(@group), notice: '... You try to play with me ? Please don t try again' unless current_user.check_allowed(params[:group]['access_level'])
        @group.update_attributes(params[:group].permit(:access_level))
        redirect_to edit_group_path(@group), notice: 'Group permissions updated'
    end

    private

    def set_group
        @group = Group.find(params[:id])
    end
end
