name             "t3-chef-vault"
maintainer       "TYPO3 Association"
maintainer_email "steffen.gebert@typo3.org"
license          "Apache 2.0"
description      "A library cookbook extending the chef-vault library cookbook"
version          IO.read(File.join(File.dirname(__FILE__), 'VERSION')) rescue '0.0.1'

depends          "chef-vault", "~> 1.3.3"
