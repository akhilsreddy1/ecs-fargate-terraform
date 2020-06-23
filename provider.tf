
provider "aws" {
  version                 = "~> 2.43.0"
  region                  = "us-west-2"
  shared_credentials_file = "/root/.aws/credentials"
  profile                 = "skylab"
}

