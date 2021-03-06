require 'spec_helper'

describe 'pptp' do
  on_supported_os.sort.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
      it { is_expected.to contain_class('pptp') }
      it { is_expected.to contain_class('pptp::install') }
      it { is_expected.to contain_class('pptp::service') }
      it { is_expected.to contain_class('pptp::connections') }
      it { is_expected.to contain_file('/etc/ppp/chap-secrets') }

      it { is_expected.to contain_class('kmod') }
      it { is_expected.to contain_kmod__load('ppp_mppe') }
      it { is_expected.not_to contain_file('/etc/modules-load.d/pptp.conf') }

      it { is_expected.to contain_file('/sbin/pon') }
      it { is_expected.to contain_file('/sbin/poff') }
      it { is_expected.to contain_file('/etc/ppp/options.pptp') }

      case os_facts[:osfamily]
      when 'Debian'
        it { is_expected.to contain_package('pptp-linux') }
        it { is_expected.to contain_class('firewalld') }
      when 'RedHat'
        it { is_expected.to contain_package('pptp') }
        it { is_expected.to contain_class('firewalld') }
      when 'Suse'
        it { is_expected.to contain_package('pptp') }
        it { is_expected.not_to contain_class('firewalld') }
        it { is_expected.to contain_file('/etc/sysconfig/kernel') }
      end
    end

    context "on #{os} with firewall management disabled" do
      let(:facts) { os_facts }
      let(:params) {
        {
          :firewall_manage => false,
        }
      }

      it { is_expected.to compile }
      it { is_expected.to contain_class('pptp') }
      it { is_expected.to contain_class('pptp::install') }
      it { is_expected.to contain_class('pptp::service') }
      it { is_expected.to contain_class('pptp::connections') }
      it { is_expected.to contain_file('/etc/ppp/chap-secrets') }

      it { is_expected.to contain_class('kmod') }
      it { is_expected.to contain_kmod__load('ppp_mppe') }
      it { is_expected.not_to contain_file('/etc/modules-load.d/pptp.conf') }

      it { is_expected.not_to contain_class('firewalld') }

      it { is_expected.to contain_file('/sbin/pon') }
      it { is_expected.to contain_file('/sbin/poff') }
      it { is_expected.to contain_file('/etc/ppp/options.pptp') }

      case os_facts[:osfamily]
      when 'Debian'
        it { is_expected.to contain_package('pptp-linux') }
      when 'RedHat'
        it { is_expected.to contain_package('pptp') }
      when 'Suse'
        it { is_expected.to contain_package('pptp') }
        it { is_expected.to contain_file('/etc/sysconfig/kernel') }
      end
    end

    context "on #{os} with package management disabled" do
      let(:facts) { os_facts }
      let(:params) {
        {
          :package_manage  => false,
        }
      }

      it { is_expected.to compile }
      it { is_expected.to contain_class('pptp') }
      it { is_expected.to contain_class('pptp::install') }
      it { is_expected.to contain_class('pptp::service') }
      it { is_expected.to contain_class('pptp::connections') }
      it { is_expected.to contain_file('/etc/ppp/chap-secrets') }

      it { is_expected.to contain_class('kmod') }
      it { is_expected.to contain_kmod__load('ppp_mppe') }
      it { is_expected.not_to contain_file('/etc/modules-load.d/pptp.conf') }

      it { is_expected.not_to contain_file('/sbin/pon') }
      it { is_expected.not_to contain_file('/sbin/poff') }
      it { is_expected.to contain_file('/etc/ppp/options.pptp') }

      case os_facts[:osfamily]
      when 'Debian'
        it { is_expected.not_to contain_package('pptp-linux') }
        it { is_expected.to contain_class('firewalld') }
      when 'RedHat'
        it { is_expected.not_to contain_package('pptp') }
        it { is_expected.to contain_class('firewalld') }
      when 'Suse'
        it { is_expected.not_to contain_package('pptp') }
        it { is_expected.not_to contain_class('firewalld') }
        it { is_expected.to contain_file('/etc/sysconfig/kernel') }
      end
    end

    context "on #{os} with module management disabled" do
      let(:facts) { os_facts }
      let(:params) {
        {
          :module_manage   => false,
        }
      }

      it { is_expected.to compile }
      it { is_expected.to contain_class('pptp') }
      it { is_expected.to contain_class('pptp::install') }
      it { is_expected.to contain_class('pptp::service') }
      it { is_expected.to contain_class('pptp::connections') }
      it { is_expected.to contain_file('/etc/ppp/chap-secrets') }

      it { is_expected.not_to contain_class('kmod') }
      it { is_expected.not_to contain_kmod__load('ppp_mppe') }
      it { is_expected.not_to contain_file('/etc/modules-load.d/pptp.conf') }

      it { is_expected.to contain_file('/sbin/pon') }
      it { is_expected.to contain_file('/sbin/poff') }
      it { is_expected.to contain_file('/etc/ppp/options.pptp') }

      case os_facts[:osfamily]
      when 'Debian'
        it { is_expected.to contain_package('pptp-linux') }
        it { is_expected.to contain_class('firewalld') }
      when 'RedHat'
        it { is_expected.to contain_package('pptp') }
        it { is_expected.to contain_class('firewalld') }
      when 'Suse'
        it { is_expected.to contain_package('pptp') }
        it { is_expected.not_to contain_class('firewalld') }
        it { is_expected.not_to contain_file('/etc/sysconfig/kernel') }
      end
    end
  end
end
