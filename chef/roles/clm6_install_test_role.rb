# Licensed Materials - Property of IBM Copyright IBM Corporation 2012. All Rights Reserved.
# U.S. Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP
# Schedule Contract with IBM Corp.
################################################################################
name "CLMv6_Install"
description "IM Installation, Application server, profile creation,CLMv6 Installation, WAS configuration, CLM Deployment."
run_list(
  "recipe[im_18]",
  "recipe[was855_clmv6]",
  "recipe[clmv6_install]",
  "recipe[was_config_clmv6]",
  "recipe[db2_ese_v105_CLMv6]"
  )


