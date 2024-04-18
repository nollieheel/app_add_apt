#
# Cookbook:: test
# Recipe:: default
#
# Copyright:: 2024, Earth U
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# # Save node attribs to file
# ruby_block 'save node attribs' do
#   block do
#     ::File.write('/tmp/kitchen_chef_node.json', node.to_json)
#   end
# end

vs = node[cookbook_name]

add_apt vs['php-fpm']['name'] do
  key          vs['php-fpm']['key']
  uri          vs['php-fpm']['uri']
  components   ['main']
  arch         'amd64'
  cache_rebuild false
end

add_apt vs['mariadb']['name'] do
  keyserver     false
  key           vs['mariadb']['key']
  key_name      vs['mariadb']['key_name']
  key_checksum  vs['mariadb']['key_checksum']
  uri           vs['mariadb']['uri']
  components    ['main']
  options       []
  arch          'amd64'
  cache_rebuild false
end

add_apt vs['elastic']['name'] do
  keyserver    false
  key          vs['elastic']['key']
  key_name     vs['elastic']['key_name']
  key_dearmor  vs['elastic']['key_dearmor']
  uri          vs['elastic']['uri']
  distribution vs['elastic']['distribution']
  components   ['main']
  options      ['arch=amd64']
end

add_apt vs['git']['name'] do
  keyserver  false
  key        vs['git']['key']
  uri        vs['git']['uri']
  components ['main']
end
