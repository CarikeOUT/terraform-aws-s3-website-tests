# AWS Key Pair Creation with Terraform - Beginner's Guide

This example demonstrates how to create an AWS EC2 key pair using Terraform. This is perfect for beginners learning Terraform!

## What This Does

This Terraform configuration will:
1. **Generate an RSA key pair** (private and public keys) with 4096-bit encryption
2. **Create an AWS key pair** named `nautilus-kp` that can be used to access EC2 instances
3. **Save the private key** to `/home/bob/nautilus-kp.pem` with secure permissions

## Prerequisites

Before you start, make sure you have:
- **Terraform installed** (version 1.0 or higher)
- **AWS credentials configured** (AWS Access Key ID and Secret Access Key)
- **Directory created**: `/home/bob/` must exist on your system

### Installing Terraform

If you don't have Terraform installed:
- Download it from: https://www.terraform.io/downloads
- Follow the installation instructions for your operating system

### Configuring AWS Credentials

You need to configure AWS credentials. The easiest way is:

```bash
# Option 1: Set environment variables
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"

# Option 2: Use AWS CLI to configure
aws configure
```

## Step-by-Step Instructions

### Step 1: Navigate to the Terraform Working Directory

```bash
cd /home/bob/terraform
```

### Step 2: Initialize Terraform

This downloads the required provider plugins (AWS and TLS providers):

```bash
terraform init
```

**What happens:** Terraform downloads the AWS and TLS provider plugins needed to execute this configuration.

### Step 3: Review the Execution Plan

This shows you what Terraform will create before actually creating it:

```bash
terraform plan
```

**What to look for:**
- You should see plans to create 3 resources:
  - `tls_private_key.nautilus_key` - generates the RSA key
  - `aws_key_pair.nautilus_kp` - creates the key pair in AWS
  - `local_file.private_key` - saves the private key file

### Step 4: Apply the Configuration

This actually creates the resources:

```bash
terraform apply
```

**What happens:**
1. Terraform will show you the plan again
2. Type `yes` when prompted to confirm
3. Terraform will:
   - Generate the RSA key pair
   - Create the key pair in AWS
   - Save the private key to `/home/bob/nautilus-kp.pem`

### Step 5: Verify the Key Pair Was Created

Check that the private key file exists:

```bash
ls -l /home/bob/nautilus-kp.pem
```

You should see a file with permissions `-r--------` (read-only for owner).

You can also verify in the AWS Console:
1. Go to EC2 → Key Pairs
2. You should see `nautilus-kp` listed

### Step 6: View the Outputs

Terraform will display outputs showing:
- The key pair name: `nautilus-kp`
- The key pair ID
- The key pair fingerprint

## Understanding the Configuration

### The main.tf File Structure

The `main.tf` file contains several sections:

#### 1. Provider Configuration
```hcl
provider "aws" {
  region = "us-east-1"
}
```
This tells Terraform to use AWS in the us-east-1 region.

#### 2. Terraform Block
```hcl
terraform {
  required_providers {
    aws = { ... }
    tls = { ... }
  }
}
```
This specifies which provider plugins Terraform needs to download.

#### 3. RSA Key Generation
```hcl
resource "tls_private_key" "nautilus_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
```
This generates a secure 4096-bit RSA key pair.

#### 4. AWS Key Pair Creation
```hcl
resource "aws_key_pair" "nautilus_kp" {
  key_name   = "nautilus-kp"
  public_key = tls_private_key.nautilus_key.public_key_openssh
}
```
This registers the public key with AWS.

#### 5. Private Key File
```hcl
resource "local_file" "private_key" {
  content         = tls_private_key.nautilus_key.private_key_pem
  filename        = "/home/bob/nautilus-kp.pem"
  file_permission = "0400"
}
```
This saves the private key to your local file system with secure permissions.

## Using the Key Pair

Once created, you can use this key pair to:
- Launch EC2 instances with this key pair
- SSH into EC2 instances:
  ```bash
  ssh -i /home/bob/nautilus-kp.pem ec2-user@<instance-ip>
  ```

## Cleaning Up

When you're done testing, you can destroy all resources:

```bash
terraform destroy
```

Type `yes` when prompted. This will:
- Delete the key pair from AWS
- Remove the private key file from your local system
- Delete the state information

**Note:** The local private key file will be deleted by Terraform.

## Important Security Notes

1. **Protect Your Private Key**: The file `/home/bob/nautilus-kp.pem` contains your private key. Never share it or commit it to version control.

2. **Secure Permissions**: The key file has `0400` permissions (read-only for owner), which is required by SSH.

3. **AWS Credentials**: Keep your AWS credentials secure. Never commit them to version control.

4. **Key Rotation**: In production environments, rotate your keys regularly.

## Troubleshooting

### Error: "No valid credential sources found"
**Solution:** Configure your AWS credentials (see Prerequisites section).

### Error: "Permission denied" for /home/bob/nautilus-kp.pem
**Solution:** Make sure the `/home/bob/` directory exists and you have write permissions.

### Error: "Key pair already exists"
**Solution:** A key pair named `nautilus-kp` already exists in AWS. Either:
- Delete it from AWS EC2 console
- Change the `key_name` in main.tf to a different name

## Next Steps

Now that you've created a key pair, you can:
1. Launch an EC2 instance using this key pair
2. Learn about Terraform state files (`terraform.tfstate`)
3. Explore Terraform variables to make configurations more flexible
4. Learn about Terraform modules for reusable configurations

## Additional Resources

- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Terraform TLS Provider Documentation](https://registry.terraform.io/providers/hashicorp/tls/latest/docs)
- [AWS Key Pairs Documentation](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html)
