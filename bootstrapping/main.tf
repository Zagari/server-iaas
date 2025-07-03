provider "aws" {
  region = "us-east-1"
}

# Bucket S3 para armazenar o arquivo de estado
resource "aws_s3_bucket" "tfstate" {
  bucket = "meu-projeto-server-castellabate-terraform-state" # ← USE UM NOME ÚNICO GLOBALMENTE

  # Previne a destruição acidental do bucket de estado
  lifecycle {
    prevent_destroy = true
  }
}

# Habilita o versionamento para o bucket de estado, para ter um histórico de mudanças
resource "aws_s3_bucket_versioning" "tfstate_versioning" {
  bucket = aws_s3_bucket.tfstate.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Tabela DynamoDB para o travamento de estado (state locking)
resource "aws_dynamodb_table" "tflock" {
  name           = "meu-projeto-server-castellabate-terraform-lock"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}