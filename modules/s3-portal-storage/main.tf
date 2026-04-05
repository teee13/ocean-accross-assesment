resource "aws_s3_bucket" "portal" {
  bucket = "${var.portal_name}-portal-app-storage-${random_id.bucket_suffix.hex}"
  acl    = "private"

  tags = {
    Name = "${var.portal_name}-storage"
  }
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}
