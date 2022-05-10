terraform {
    backend "s3" {
        bucket = "bucket-for-save-filestate-terraform"
        key    = "terraform_state"
        region = "eu-north-1"
    }
}