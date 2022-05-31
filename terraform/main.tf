terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  backend "s3" {
    bucket = "dev.ad3f.me"
    key    = "cloud_resume_challenge_remote_state.tfstate"
    region = "ap-southeast-2"
  }
}

provider "aws" {
    region = "ap-southeast-2"
    alias  = "aws_syd"
}

provider "aws" {
  region = "us-east-1"
  alias  = "aws_us1"
}

provider "random" {
  alias = "rnd"
}