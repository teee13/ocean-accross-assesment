# Tenant-Based App Terraform Infrastructure

<img width="3128" height="2968" alt="image" src="https://github.com/user-attachments/assets/4c75a671-c664-41ab-9a93-c0a711f9eb14" />

## Structure

- `modules/`
  - `networking/`
  - `security/`
  - `kms/`
  - `alb/`
  - `ecs-cluster/`
  - `ecs-service/`
  - `ecr/`
  - `s3-portal-storage/`
  - `secrets-portal/`
  - `ssm-portal/`
  - `rds-cluster/`
  - `observability/`
  - `iam-task-role/`
  - `vpc-endpoints/`

- `stacks/`
  - `shared-platform/` - shared infrastructure and platform services
  - `portal-a/` - Portal A specific resources
  - `portal-b/` - Portal B specific resources
  - `portal-c/` - Portal C specific resources

- `scripts/` - helper scripts to init, plan, apply, and destroy stacks

## Backend Setup

The Terraform state is stored in S3 with DynamoDB locking. The backend resources are created by the `shared-platform` stack.

### Initial Setup (Bootstrap)

1. Apply the `shared-platform` stack locally first to create the S3 bucket, DynamoDB table, and master database secret:

```bash
cd stacks/shared-platform
terraform init
terraform plan -var="db_password=YOUR_DB_PASSWORD"
terraform apply -var="db_password=YOUR_DB_PASSWORD"
```

2. Migrate the state to S3:

```bash
terraform init -migrate-state
```

## Database Setup

After deploying the `shared-platform` stack, you need to manually create the databases and users in RDS:

### Get Database Connection Info

```bash
# Get RDS endpoint from Terraform outputs
cd stacks/shared-platform
terraform output db_address
terraform output db_port

# Get generated passwords from Secrets Manager
aws secretsmanager get-secret-value --secret-id portal-a-secrets --query SecretString
aws secretsmanager get-secret-value --secret-id portal-b-secrets --query SecretString  
aws secretsmanager get-secret-value --secret-id portal-c-secrets --query SecretString
```

### Create Databases and Users

Connect to the RDS instance using the master credentials and run:

```sql
-- Create databases
CREATE DATABASE "Employee";
CREATE DATABASE "Company"; 
CREATE DATABASE "Bureaus";

-- Create users (replace with actual passwords from Secrets Manager)
CREATE USER "Employee" WITH PASSWORD 'generated_password_from_secrets';
CREATE USER "Company" WITH PASSWORD 'generated_password_from_secrets';
CREATE USER "Bureaus" WITH PASSWORD 'generated_password_from_secrets';

-- Grant permissions
GRANT ALL PRIVILEGES ON DATABASE "Employee" TO "Employee";
GRANT ALL PRIVILEGES ON DATABASE "Company" TO "Company";
GRANT ALL PRIVILEGES ON DATABASE "Bureaus" TO "Bureaus";

-- Grant schema permissions
\c "Employee"
GRANT ALL ON SCHEMA public TO "Employee";

\c "Company"  
GRANT ALL ON SCHEMA public TO "Company";

\c "Bureaus"
GRANT ALL ON SCHEMA public TO "Bureaus";
```

## Sensitive Variables

Database passwords are stored securely in AWS Secrets Manager. The `db_password` variable is only required when deploying the `shared-platform` stack:

### For Shared Platform Deployment
```bash
cd stacks/shared-platform
terraform plan -var="db_password=YOUR_DB_PASSWORD"
terraform apply -var="db_password=YOUR_DB_PASSWORD"
```

### For Portal Stack Deployments
Portal stacks automatically retrieve the database password from the master secret created by shared-platform. No additional variables needed:

```bash
cd stacks/portal-a
terraform plan
terraform apply
```

## Usage

Run one of the helper scripts from the repository root:

```bash
./scripts/init.sh shared-platform
./scripts/plan.sh shared-platform
./scripts/apply.sh shared-platform
./scripts/destroy.sh shared-platform
```

For portal stacks:

```bash
./scripts/init.sh emp-portal
./scripts/plan.sh emp-portal
./scripts/apply.sh emp-portal
./scripts/destroy.sh emp-portal
```

## Notes

- `stacks/shared-platform` creates shared VPC networking, security groups, ALB, ECS cluster, RDS cluster, ECR, KMS, VPC endpoints, Terraform backend resources (S3 bucket + DynamoDB table), and generates portal-specific Secrets Manager entries with database credentials.
- `stacks/portal-a`, `stacks/portal-b`, and `stacks/portal-c` create portal-specific S3 storage, SSM parameters, IAM task roles, observability log groups, and ECS services. Each portal uses its own database user with access only to its database.
- **Database Setup**: After deploying shared-platform, you must manually create databases and users in RDS using the generated credentials stored in Secrets Manager.
- The ALB is configured to route to portal-specific target groups using path-based rules.
- **Security**: Each portal has isolated database access - portal users cannot access other portals' databases.
- Portal stack names map to portal names:
  - `portal-a` → `PortalA`
  - `portal-b` → `PortalB`
  - `portal-c` → `PortalC`

## Stack outputs

Each stack exposes its own outputs in `outputs.tf` for downstream integration.

# GitHub Actions

The GitHub Actions workflow here mimics how separate repositories would deploy new images
upon pushes by fetching the Terraform repository and deploying to their respective portals.
AWS OIDC is used to provide deployment permissions.

## Note

This workflow demonstrates a single-environment deployment, but it can be extended to a
multi-environment setup by using different clusters in AWS and environment-specific GitHub
Actions variables and secrets that resolve according to the target branch (prod, dev, stage).

## UK Compliance

Strict IAM policies are enforced to restrict data access to the portal that each bucket is
assigned to. All resources are provisioned within the London region (eu-west-2).

KMS keys are used for encryption at rest, and SSL/TLS is enforced at the compute layer.
