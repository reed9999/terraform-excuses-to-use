# more or less from 
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  # region  = var.aws_region.name
  region  = "eu-west-3"
}


resource "aws_s3_bucket" "bucket01" {
  # four random nouns of length 5
  bucket = "truth-hotel-drama-story"

  tags = {
    Name        = "Bucket one"
    Environment = "dev"
  }
}

resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.bucket01.id
  acl    = "private"
}

variable "image_filenames" {
  default     = {
    miami = "images/1024px-Miami_Skyline_2020.jpg"
    lagos = "images/Lagos_Island.jpg"
    kuala_lumpur = "images/Moonrise_over_kuala_lumpur.jpg"
    chicago = "images/Chicago-Buildings-1804479_1920.jpg"
  }
}

resource "aws_s3_object" "miami" {
  bucket = aws_s3_bucket.bucket01.id
  key    = "miami"
  source = var.image_filenames.miami
 
  # Comment from link above:  
  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
 # etag = "${md5(file("path/to/file"))}"
  etag = filemd5(var.image_filenames.miami)
}

resource "aws_s3_object" "lagos" {
  bucket = aws_s3_bucket.bucket01.id
  key    = "lagos"
  source = var.image_filenames.lagos
  etag = filemd5(var.image_filenames.lagos)
}

resource "aws_s3_object" "kuala_lumpur" {
  bucket = aws_s3_bucket.bucket01.id
  # Notably, fixing this issue (where I had a duplicate "chicago" key here) required two invocations
  # of `terraform apply` to heal itself. The first simply renamed the KL object wrongly named 
  # "chicago" to its proper name, without replacing the real Chicago image. The second pass through
  # (post-correction), Terraform picked up on the missing "chicago" object and recreated it. 
  key    = "kuala_lumpur" 
  source = var.image_filenames.kuala_lumpur
  etag = filemd5(var.image_filenames.kuala_lumpur)
}

resource "aws_s3_object" "chicago" {
  bucket = aws_s3_bucket.bucket01.id
  key    = "chicago"
  source = var.image_filenames.chicago
  etag = filemd5(var.image_filenames.chicago)
}


