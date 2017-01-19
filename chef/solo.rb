# Generated from uDeploy Chef plugin
CHEF_DIR = File.expand_path(File.dirname(__FILE__))
file_cache_path "/tmp/chef-solo"
role_path CHEF_DIR + "/roles"
environment_path CHEF_DIR + "/environments"
data_bag_path CHEF_DIR + "/data_bags"
cookbook_path CHEF_DIR + "/cookbooks"

#LOG
log_level	:info
