# Configure the AWS Provider
# This tells Terraform to use AWS as the cloud provider
provider "aws" {
  region = "us-east-1" # You can change this to your preferred region
}

# Configure the TLS Provider
# This is needed to generate RSA keys
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
  required_version = ">= 1.0"
}

# Generate an RSA private key
# This creates a 4096-bit RSA key pair (private and public keys)
resource "tls_private_key" "nautilus_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create an AWS Key Pair using the generated public key
# This registers the public key with AWS so you can use it to access EC2 instances
resource "aws_key_pair" "nautilus_kp" {
  key_name   = "nautilus-kp" # Name of the key pair in AWS
  public_key = tls_private_key.nautilus_key.public_key_openssh
}

# Save the private key to a local file
# This writes the private key to the specified path with restricted permissions
resource "local_file" "private_key" {
  content         = tls_private_key.nautilus_key.private_key_pem
  filename        = "/home/bob/nautilus-kp.pem"
  file_permission = "0400" # Read-only for owner (secure permissions)
}

# Output the key pair name for verification
output "key_pair_name" {
  description = "The name of the created key pair"
  value       = aws_key_pair.nautilus_kp.key_name
}

# Output the key pair ID
output "key_pair_id" {
  description = "The ID of the created key pair"
  value       = aws_key_pair.nautilus_kp.id
}

# Output the fingerprint of the key pair
output "key_pair_fingerprint" {
  description = "The fingerprint of the key pair"
  value       = aws_key_pair.nautilus_kp.fingerprint
}
