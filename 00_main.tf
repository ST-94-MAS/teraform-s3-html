# Terraform Configuration
provider "aws" {
  region = "ap-northeast-1"  # 使用したいリージョンに適切に変更してください
}

# S3バケットの作成
resource "aws_s3_bucket" "static_website_bucket" {
  bucket = "st-example-static-website"  # 適切なバケット名に変更してください
  acl    = "private"  # パブリックアクセスを許可しないようにします

  website {
    index_document = "index.html"  # インデックスドキュメントを設定
    error_document = "error.html"  # エラードキュメントを設定
  }
}

# バケットポリシーを追加
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.static_website_bucket.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": [
        "arn:aws:s3:::st-example-static-website/*"
      ]
    }
  ]
}
EOF
}

resource "aws_s3_bucket_public_access_block" "main" {
  bucket                  = aws_s3_bucket.static_website_bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# サンプルページのアップロード
resource "aws_s3_bucket_object" "index_html" {
  bucket       = aws_s3_bucket.static_website_bucket.id
  key          = "index.html"
  source       = "C:/Users/chosh/terraform/s3+html/index.html"  # ファイルの実際のパスに変更してください
  content_type = "text/html"
}

# エラードキュメントのアップロード
resource "aws_s3_bucket_object" "error_html" {
  bucket       = aws_s3_bucket.static_website_bucket.id
  key          = "error.html"  # サンプルのエラーHTMLファイル名を適宜変更してください
  source       = "C:/Users/chosh/terraform/s3+html/error.html"  # HTMLファイルのパスを指定してください
  content_type = "text/html"
}
