# app_add_apt

Install an apt repository using individual keys.

## Supported Platforms

Ubuntu 22.04

## Resources

### add_apt

A wrapper for built-in resource [apt_repository](https://docs.chef.io/resources/apt_repository/) with additional properties.

```ruby
add_apt 'mariadb' do
  keyserver  false
  key        'https://mariadb.org/mariadb_release_signing_key.pgp'
  uri        'https://deb.mariadb.org/11.3/ubuntu'
  components ['main']
end
```

#### Actions

- `install` - Install the apt repo (default)

#### Properties

The following properties work the same as they do in `apt_repository`:
- `repo_name`
- `arch`
- `cache_rebuild`
- `cookbook`
- `deb_src`
- `distribution`
- `keyserver`

New properties or existing ones that now work a bit differently:
- `components` - Now defaults to `[]`.
- `key` - Same as in `apt_repository`, but only accepts a single string.
- `key_name` - If you want the key file to be named other than `:repo_name` by default.
- `key_checksum` - Optional. SHA256 checksum of downloaded raw key.
- `key_dearmor` - If downloaded key needs to be run through `gpg --dearmor`, set this to `true`. Default: `false`.
- `options` - Additional repo options. The `signed-by=` option will be automatically added here, so no need to manually enter it. Default: `[]`.
- `uri` - Enter the full URI of the Debian base here. For Launchpad PPAs, use the new https domain: `https://ppa.launchpadcontent.net`.
- `keyrings` - Location of keyrings. Default: `/usr/share/keyrings`.

## License and Authors

Author:: Earth U (<iskitingbords@gmail.com>)
