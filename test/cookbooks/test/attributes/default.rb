#
# Cookbook:: test
# Attribute:: default
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

cb = 'test'

default[cb]['php-fpm']['name'] = 'php-fpm'
default[cb]['php-fpm']['key'] = '14AA40EC0831756756D7F66C4F4EA0AAE5267A6C'
default[cb]['php-fpm']['uri'] = 'https://ppa.launchpadcontent.net/ondrej/php/ubuntu'

default[cb]['mariadb']['name'] = 'mariadb'
default[cb]['mariadb']['key'] = 'https://mariadb.org/mariadb_release_signing_key.pgp'
default[cb]['mariadb']['key_name'] = 'mariadb_release_signing_key.pgp'
default[cb]['mariadb']['key_checksum'] = '6e568b02d6cd08f746bf163017c4666a74af760d9d1209537d5270023e0851c9'
default[cb]['mariadb']['uri'] = 'https://deb.mariadb.org/11.3/ubuntu'

default[cb]['elastic']['name'] = 'elastic'
default[cb]['elastic']['key'] = 'https://artifacts.elastic.co/GPG-KEY-elasticsearch'
default[cb]['elastic']['key_name'] = 'elastic-7.x.gpg'
default[cb]['elastic']['key_dearmor'] = true
default[cb]['elastic']['uri'] = 'https://artifacts.elastic.co/packages/7.x/apt'
default[cb]['elastic']['distribution'] = 'stable'

default[cb]['git']['name'] = 'git'
default[cb]['git']['key'] = 'git-core.gpg'
default[cb]['git']['uri'] = 'https://ppa.launchpadcontent.net/git-core/ppa/ubuntu'
