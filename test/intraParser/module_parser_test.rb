require 'test_helper'

class ModuleParserTest < ActiveSupport::TestCase

    test 'Module details test (2014 B-PSU-155 for Paris' do
        parser = EpitechModuleParser.new

        result = parser.module_details(2014, 'B-PSU-155', 'PAR-2-1')

        result.each do |k, v|
            assert_not_empty v, "#{k} Empty ..."
        end
    end

    test 'Module details test fail (2014 B-PSU-155 for Paris not existing)' do
        parser = EpitechModuleParser.new

        assert_raise EpitechRequest::NotFound do
            parser.module_details(2014, 'B-PSU-155', 'PAR-2-4')
        end
    end

    # SERIALIZED EXCEPTION FIX SECTION

    test 'Serialized exception 1' do
        epitech_module = FactoryGirl.create(:epitech_module, code: 'B-CPE-042-1')
        module_instance = FactoryGirl.create(:module_instance, epitech_module: epitech_module, scholar_year: 2011, code: 'PAR-1-1')

        module_instance.discover_details
    end

    test 'Serialized exception 2' do
        epitech_module = FactoryGirl.create(:epitech_module, code: 'B-PSU-150')
        module_instance = FactoryGirl.create(:module_instance, epitech_module: epitech_module, scholar_year: 2009, code: 'LIL-4-1')
        module_instance.discover_details

        epitech_module = FactoryGirl.create(:epitech_module, code: 'G-EPI-XXX-1')
        module_instance = FactoryGirl.create(:module_instance, epitech_module: epitech_module, scholar_year: 2009, code: 'BDX-3-1')
        module_instance.discover_details

        epitech_module = FactoryGirl.create(:epitech_module, code: 'B-ADM-050')
        module_instance = FactoryGirl.create(:module_instance, epitech_module: epitech_module, scholar_year: 2012, code: 'REN-1-1')
        module_instance.discover_details
    end

    test 'Bugs debug' do
        epitech_module = FactoryGirl.create(:epitech_module, code: 'B-BDD-350')
        module_instance = FactoryGirl.create(:module_instance, epitech_module: epitech_module, scholar_year: 2011, code: 'PAR-5-1')
        module_instance.discover_details

        assert(module_instance.crawler_stamp != '0001-01-01', 'fail')
    end
end
