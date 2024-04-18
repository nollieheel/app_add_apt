#
# Cookbook:: app_add_apt
# Resource:: add_apt
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

# Add apt repository (a wrapper for apt_repository built-in resource)

provides :add_apt

property :repo_name, String,
         description: 'See apt_repository resource',
         name_property: true

property :arch, [String, false],
         description: 'See apt_repository resource'

property :cache_rebuild, [true, false],
         description: 'See apt_repository resource'

property :components, [Array],
         description: 'See apt_repository resource'

property :cookbook, [String, false],
         description: 'See apt_repository resource'

property :deb_src, [true, false],
         description: 'See apt_repository resource'

property :distribution, [String, false],
         description: 'See apt_repository resource'

property :key, String, required: true,
         description: 'If a keyserver is provided, this is assumed to be '\
                      'the fingerprint; otherwise it can be either the URI '\
                      'of GPG key for the repo, or a cookbook_file.'

property :key_name, String,
         description: 'Filename of key. Defaults to "{:repo_name}.gpg". '\
                      'Used only if :key is not a cookbook_file.'

property :key_checksum, String,
         description: 'SHA256 checksum if key is downloaded from a URI'

property :key_dearmor, [true, false],
         description: 'If key is downloaded from a URI, set '\
                      'this to true to run it through "gpg --dearmor"',
         default: false

property :keyserver, [String, false],
         description: 'The GPG keyserver where the key for the repo '\
                      'should be retrieved',
         default: 'keyserver.ubuntu.com'

property :options, [String, Array],
         description: 'Additional options to set for the repository. The '\
                      '"signed-by=" directive will be automatically added.',
         default: []

property :uri, String, required: true,
         description: 'The base of the Debian distribution. Provide the full '\
                      'URI here. For default PPAs, use the new domain: '\
                      'https://ppa.launchpadcontent.net. Example: '\
                      'https://ppa.launchpadcontent.net/git-core/ppa/ubuntu'

property :keyrings, String,
         description: 'Download keys (keyrings) into this local dir',
         default: '/usr/share/keyrings'

action :install do
  # Get GPG keyring and store in :keyrings directory

  kn = if property_is_set?(:key_name)
         new_resource.key_name
       else
         "#{new_resource.repo_name}.gpg"
       end

  sign = "signed-by=#{new_resource.keyrings}/"

  package 'gpg'

  if new_resource.keyserver
    execute "get_key_from_keyserver_#{kn}" do
      command 'gpg --homedir /tmp --no-default-keyring '\
              "--keyring #{new_resource.keyrings}/#{kn} "\
              "--keyserver #{new_resource.keyserver} "\
              "--recv-keys #{new_resource.key}"
      not_if  { ::File.exist?("#{new_resource.keyrings}/#{kn}") }
    end

    sign << "#{kn}"

  elsif new_resource.key.start_with?('http')
    locarmored   = "#{Chef::Config[:file_cache_path]}/#{kn}"
    locunarmored = "#{new_resource.keyrings}/#{kn}"

    if new_resource.key_dearmor
      remote_file locarmored do
        source   new_resource.key
        not_if   { ::File.exist?(locunarmored) }
        notifies :run, "execute[dearmor_#{kn}]", :immediately
        if new_resource.key_checksum
          checksum new_resource.key_checksum
        end
      end

      execute "dearmor_#{kn}" do
        command "gpg --dearmor -o #{locunarmored} #{locarmored}"
        action  :nothing
      end

    else
      remote_file locunarmored do
        action :create_if_missing
        source new_resource.key
        if new_resource.key_checksum
          checksum new_resource.key_checksum
        end
      end
    end

    sign << "#{kn}"

  else
    cookbook_file "#{new_resource.keyrings}/#{new_resource.key}" do
      if new_resource.cookbook
        cookbook new_resource.cookbook
      end
      mode '0644'
    end

    sign << "#{new_resource.key}"
  end

  # Add repo in sources.list.d

  opts = [sign, new_resource.options].flatten

  apt_repository new_resource.repo_name do
    if new_resource.property_is_set?(:arch)
      arch new_resource.arch
    end
    if new_resource.property_is_set?(:cache_rebuild)
      cache_rebuild new_resource.cache_rebuild
    end
    if new_resource.property_is_set?(:components)
      components new_resource.components
    end
    if new_resource.property_is_set?(:deb_src)
      deb_src new_resource.deb_src
    end
    if new_resource.property_is_set?(:distribution)
      distribution new_resource.distribution
    end

    keyserver false
    options   opts
    uri       new_resource.uri
  end
end
