provider "aws" {
  shared_config_files      = ["~/credentials_file"]
  shared_credentials_files = ["~/config_file"]
  profile                  = ""
}