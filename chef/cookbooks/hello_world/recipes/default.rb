################################################################################
# Licensed Materials - Property of IBM Copyright IBM Corporation 2012. All Rights Reserved.
# U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP
# Schedule Contract with IBM Corp.
################################################################################

OWN  = node['was']['owner']
FILE = node['hello']['file']
DIR  = node['hello']['dir'] 

#_______________________________________[ main deploy ]

execute "Creating dir/file" do
  user "#{OWN}"
  cwd '/tmp'
  command "mkdir #{DIR}; touch #{DIR}/#{FILE}"
  action :run
end
