class BoardController < ApplicationController
    def index
        add_breadcrumb 'Board', root_path

        @user = current_user
        @stats = gon.jbuilder template: 'app/views/board/index/_stats.json.jbuilder', as: 'stats'
    end

    #This method is used for debug pupose
    def debug
        Delayed::Worker.delay_jobs = false
        ModuleInstance.find(3).discover_details
    end
end
