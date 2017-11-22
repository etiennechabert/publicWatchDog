class InstanceActivityGroupsController < ApplicationController
    before_action :set_group, only: [:show]

    def show
        gon.jbuilder template: 'app/views/instance_activity_groups/show.json.jbuilder', as: 'data' if request.format.symbol != :json
    end

    private

    def set_group
        @group = InstanceActivityGroup.find(params[:id])
    end

end
