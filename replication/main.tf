terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
      configuration_aliases = [aws.primary, aws.dr]
    }
  }
}

# ✅ Primary S3 Bucket (Source)
resource "aws_s3_bucket" "primary_bucket" {
  bucket = "myterraform-dr-bucket-primary"
  tags = {
    Name = "Primary S3 Bucket"
  }
}

# ✅ Enable Versioning on Primary Bucket
resource "aws_s3_bucket_versioning" "primary_versioning" {
  bucket = aws_s3_bucket.primary_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# ✅ DR S3 Bucket (Destination)
resource "aws_s3_bucket" "dr_bucket" {
  provider = aws.dr
  bucket   = "myterraform-dr-bucket-dr"
  tags = {
    Name = "DR S3 Bucket"
  }
}

# ✅ Enable Versioning on DR Bucket
resource "aws_s3_bucket_versioning" "dr_versioning" {
  provider = aws.dr
  bucket   = aws_s3_bucket.dr_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# ✅ IAM Role for S3 Replication
resource "aws_iam_role" "replication_role" {
  provider = aws.primary
  name     = var.s3_replication_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = { Service = "s3.amazonaws.com" },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# ✅ IAM Role Policy for Replication
resource "aws_iam_role_policy" "replication_policy" {
  provider = aws.primary
  name     = "s3-replication-policy"
  role     = aws_iam_role.replication_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetReplicationConfiguration",
          "s3:ListBucket"
        ],
        Resource = [aws_s3_bucket.primary_bucket.arn]
      },
      {
        Effect = "Allow",
        Action = [
          "s3:GetObjectVersion",
          "s3:GetObjectVersionAcl"
        ],
        Resource = ["${aws_s3_bucket.primary_bucket.arn}/*"]
      },
      {
        Effect = "Allow",
        Action = [
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags",
          "s3:ObjectOwnerOverrideToBucketOwner"
        ],
        Resource = ["${aws_s3_bucket.dr_bucket.arn}/*"]
      }
    ]
  })
}

# ✅ S3 Replication Configuration
resource "aws_s3_bucket_replication_configuration" "replication" {
  provider = aws.primary
  bucket   = aws_s3_bucket.primary_bucket.id
  role     = aws_iam_role.replication_role.arn

  depends_on = [
    aws_s3_bucket_versioning.primary_versioning,
    aws_s3_bucket_versioning.dr_versioning
  ]

  rule {
    id     = "replication-rule"
    status = "Enabled"

    destination {
      bucket        = aws_s3_bucket.dr_bucket.arn
      storage_class = "STANDARD"
    }
  }
}