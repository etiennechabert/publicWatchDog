require 'test_helper'

class EpitechModuleTest < ActiveSupport::TestCase
    test "Basic instance test" do
        instance = ModuleInstance.try_create({"scolaryear"=>2014, "id_user_history"=>"153138", "codemodule"=>"B-CPE-155", "codeinstance"=>"PAR-2-1", "title"=>"B2 - Elementary programming in C", "date_ins"=>"2015-02-03 17:14:34", "cycle"=>"bachelor", "grade"=>"-", "credits"=>8, "barrage"=>0})
        instance.discover_details
        assert_equal instance.epitech_module.module_activities.count, 26
    end
end
