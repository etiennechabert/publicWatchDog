namespace :import do

    task sheet: :environment do
        CheckupImport.import_file('tmp/import_checkups.csv')
    end

    task flush: :environment do
        FirstYearCheckup.all.each do |e|
            e.destroy
        end

        SecondYearCheckup.all.each do |e|
            e.destroy
        end

        ThirdYearCheckup.all.each do |e|
            e.destroy
        end
    end
end