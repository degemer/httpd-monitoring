# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard :rubocop do
  watch(/.+\.rb/)
end

guard :rspec, cmd: 'bundle exec rspec' do
  watch(/^spec\/.+_spec\.rb$/)
  watch(/^lib.+\/(.+)\.rb$/)     { |m| "spec/unit/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { 'spec' }
end
