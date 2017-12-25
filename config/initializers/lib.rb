# Ensure the requiring of lib files, especially for re-opening classes,
# such as lib/date.rb. See https://stackoverflow.com/questions/4235782/rails-3-library-not-loading-until-require/6797707#6797707

Dir[Rails.root + 'lib/**/*.rb'].each do |file|
  require file
end
