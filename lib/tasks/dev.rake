namespace :dev do

    task sync_prod: :environment do
        puts 'DOWNLOAD OF PROD DATABASE REMOTE PASSWORD:'
        system('mysqldump -u root -p -h watchdog WatchDog_prod > /tmp/dump')

        puts 'DROP LOCAL DATABASE :'
        system('rake db:drop')

        puts 'RECREATE DATABASE :'
        system('rake db:create')
        system('rake db:schema:load')

        puts 'APPLY DUMP'
        system('mysql -u WatchDog WatchDog_dev < /tmp/dump')
    end

end