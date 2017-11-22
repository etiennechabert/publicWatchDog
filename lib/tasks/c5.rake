namespace :c5 do
    task :generate, :file do |t, args|
        result = JSON.parse(File.read("./C5/#{args[:file]}.json"))
        File.open("./C5/#{args[:file]}.names", 'w') do |f|
            C5_names(result['definition'], f)
        end
        File.open("./C5/#{args[:file]}.data", 'w') do |f|
            C5_data(result['data'], f)
        end
    end

    def C5_names(hash, file)
        file << "#{hash["target"]}. | target\n"
        hash.extract!("target")
        hash.each do |k,v|
            file << "#{k}: #{v}.\n"
        end
    end

    def C5_data(hash_array, file)
        hash_array.delete_if {|h| h["grade"] == '-'}
        hash_array.each do |hash|
            file << hash.values.join(',')
            file << "\n"
        end
    end
end