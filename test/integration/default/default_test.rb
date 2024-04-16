# Chef InSpec test for recipe app_add_apt::default

# Make sure cache update has no errors
describe command('/usr/bin/apt-get update 2>&1 || echo E: Update failed') do
  its('stdout') { should_not match /^[WE]:/ }
end
