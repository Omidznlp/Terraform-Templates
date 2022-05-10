terraform {
    backend "s3" {
        bucket = "bucket-for-save-filestate-terraform"
        key    = "terraform_state.tf"
        region = "eu-north-1"
    }
}