#
# Cookbook Name:: pxeboot
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Install package dependencies
package 'dnsmasq'
package 'tftpd-hpa'
package 'syslinux'
package 'nfs-kernel-server'
package 'initramfs-tools'
package 'openssh-server'
package 'nginx'

service 'networking'

# Create Directories
directory '/tftpboot/pxelinux.cfg' do
  owner 'tftp'
  group 'tftp'
  mode 0755
end

directory '/srv/install' do
  owner 'root'
  group 'root'
  mode 0755
end

#
remote_directory 'netboot' do
  path '/tftpboot'
end

# Setup Configuration Files
template '/etc/dnsmasq.conf' do
  source 'dnsmasq.conf.erb'
  notifies :restart, "service[dnsmasq]"
end

# Setup Configuration Files
template '/etc/hosts.dnsmasq.conf' do
  source 'hosts.conf.erb'
  notifies :restart, "service[dnsmasq]"
end

template '/etc/default/tftpd-hpa' do
  source 'tftpd-hpa.erb'
  notifies :restart, 'service[tftpd-hpa]'
end

template '/etc/exports' do
  source 'exports.erb'
  notifies :restart, 'service[nfs-kernel-server]'
end

template '/etc/network/interfaces' do
  source 'interfaces'
  notifies :restart, 'service[networking]'
end

template '/etc/resolv.conf' do
  source 'resolv.conf'
end

# Enable Services
service "dnsmasq" do
  action [:enable, :start]
end

service "tftpd-hpa" do
  action [:enable, :start]
end

service "nfs-kernel-server" do
  action [:enable, :start]
end

service "ssh" do
  action [:enable, :start]
end

service "nginx" do
  action [:enable, :start]
end
