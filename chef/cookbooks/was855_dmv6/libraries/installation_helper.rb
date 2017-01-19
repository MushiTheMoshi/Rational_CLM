##########################################################################################################
# Licensed Materials - Property of IBM Copyright IBM Corporation 2012. All Rights Reserved.
# U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP
# Schedule Contract with IBM Corp.
##########################################################################################################
#
# Author:  Daniel Abraao Silva Costa
# Contact: dasc@br.ibm.com
#
##########################################################################################################

module InstallationCheck
  module CheckInstalledPackages

	# This method detects previous installations 
  def checkInstalledPackages
    im_location_path = node['was8552']['im_tools_path']
      if File.exist?("#{im_location_path}")
        installedPackagesList = `"#{im_location_path}/imcl" listInstalledPackages`
        if installedPackagesList.include? "websphere.ND.v85_8.5.5002"
          Chef::Log.info("Package is already installed: Websphere.ND.v85_8.5.5002")
          wasIsInstalled = true
        else 
          wasIsInstalled = false
        end
      else
        Chef::Log.info("The IBM Installation Manager wasn't found.")
        wasIsInstalled = false
      end   
      # Return    
    wasIsInstalled
  end
  
  end
end

Chef::Recipe.send(:include, InstallationCheck::CheckInstalledPackages)