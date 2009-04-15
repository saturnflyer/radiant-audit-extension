namespace :radiant do
  namespace :extensions do
    namespace :audit do
      
      desc "Runs the migration of the Audit extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          AuditExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          AuditExtension.migrator.migrate
        end
      end
      
      desc "Copies public assets of the Audit to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        puts "Copying assets from AuditExtension"
        Dir[AuditExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(AuditExtension.root, '')
          directory = File.dirname(path)
          mkdir_p RAILS_ROOT + directory
          cp file, RAILS_ROOT + path
        end
      end  
    end
  end
end
