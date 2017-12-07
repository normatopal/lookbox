namespace :cleaners do

  desc "calear uploads tmp folder"
  task :remove_tmp_images => :environment do
    CarrierWave.clean_cached_files!
  end

end