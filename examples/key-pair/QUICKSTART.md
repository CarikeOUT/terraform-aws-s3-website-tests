# Quick Start Guide for Beginners

## Step 1: Copy the Configuration File

Copy the `main.tf` file from the `examples/key-pair/` directory to your working directory `/home/bob/terraform/`:

```bash
# Create the working directory if it doesn't exist
mkdir -p /home/bob/terraform

# Copy the configuration file
cp examples/key-pair/main.tf /home/bob/terraform/main.tf

# Navigate to the working directory
cd /home/bob/terraform
```

## Step 2: Initialize Terraform

Run this command to download the required providers:

```bash
terraform init
```

Expected output:
```
Initializing the backend...
Initializing provider plugins...
- Finding hashicorp/aws versions matching "~> 5.0"...
- Finding hashicorp/tls versions matching "~> 4.0"...
...
Terraform has been successfully initialized!
```

## Step 3: Review What Will Be Created

Run this command to see what Terraform will create:

```bash
terraform plan
```

You should see that Terraform will create:
- 1 RSA private key
- 1 AWS key pair named "nautilus-kp"
- 1 local file at `/home/bob/nautilus-kp.pem`

## Step 4: Create the Key Pair

Run this command to actually create the resources:

```bash
terraform apply
```

Type `yes` when prompted to confirm.

## Step 5: Verify the Key Pair

Check that the key file was created:

```bash
ls -l /home/bob/nautilus-kp.pem
```

You should see a file with permissions `-r--------` (read-only).

## What You Created

- **Key Pair Name**: nautilus-kp
- **Key Type**: RSA (4096-bit)
- **Private Key Location**: /home/bob/nautilus-kp.pem
- **AWS Resource**: Key pair registered in your AWS account

## Next Steps

You can now use this key pair to:
1. Launch EC2 instances
2. SSH into EC2 instances using this key

## Clean Up

When you're done, you can remove all resources:

```bash
cd /home/bob/terraform
terraform destroy
```

Type `yes` when prompted.
