# frozen_string_literal: true

require 'spec_helper'

describe 'rundeck' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      describe 'add file-based key storage' do
        let(:params) do
          {
            file_keystorage_dir: '/var/lib/rundeck/var/storage',
            file_keystorage_keys: {
              'password_key' => {
                'value' => 'gobbledygook',
                'path' => 'foo/bar',
                'data_type' => 'password',
                'content_type' => 'application/x-rundeck-data-password'
              },
              'public_key' => {
                'value' => 'ssh-rsa AAAAB3rhwL1EoAIuI3hw9wZL146zjPZ6FIqgZKvO24fpZENYnNfmHn5AuOGBXYGTjeVPMzwV7o0mt3iRWk8J9Ujqvzp45IHfEAE7SO2frEIbfALdcwcNggSReQa0du4nd user@localhost',
                'path' => 'foo/bar',
                'data_type' => 'public',
                'content_type' => 'application/pgp-keys'
              }
            }
          }
        end

        # base key storage directory needs to be there first
        it { is_expected.to contain_file('/var/lib/rundeck/var/storage') }

        # content and meta data for passwords
        it { is_expected.to contain_file('/var/lib/rundeck/var/storage/content/keys/foo/bar/password_key.password').with_content(%r{gobbledygook}) }
        it { is_expected.to contain_file('/var/lib/rundeck/var/storage/meta/keys/foo/bar/password_key.password').with_content(%r{application/x-rundeck-data-password}) }

        # content and meta data for public keys
        it { is_expected.to contain_file('/var/lib/rundeck/var/storage/content/keys/foo/bar/public_key.public').with_content(%r{ssh-rsa AAAAB3rhwL1EoAIuI3hw9wZL146zjPZ6FIqgZKvO24fpZENYnNfmHn5AuOGBXYGTjeVPMzwV7o0mt3iRWk8J9Ujqvzp45IHfEAE7SO2frEIbfALdcwcNggSReQa0du4nd user@localhost}) }
        it { is_expected.to contain_file('/var/lib/rundeck/var/storage/meta/keys/foo/bar/public_key.public').with_content(%r{application/pgp-keys}) }
      end
    end
  end
end
