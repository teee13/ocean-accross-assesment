# AI Log

## Conversation Summary

This log captures the key interactions between the user and GitHub Copilot while working in the `aws-infra/task-1` Terraform project.

### Key tasks completed together

- Completed a review of ECS infrastructure and discovered the project was configured for Fargate.
- Converted ECS service definitions from Fargate to EC2 and updated the ECS cluster module to provision EC2 container instances.
- Added support for `t3.micro` instance type for ECS container instances in `modules/ecs-cluster` and wired that into `stacks/shared-platform/main.tf`.
- Prepared to update IAM task role permissions and S3 bucket policies for portal tasks.
- Updated the Terraform code to use an S3/DynamoDB backend for remote state management.
- Removed hardcoded database passwords from `stacks/shared-platform/variables.tf` and switched to CLI-provided values for initial setup.
- Ensured `db_password` was only required for the shared-platform stack and not for portal stack CI/CD deployments.
- Refined the portal stacks so portal applications use their own Secrets Manager entries and do not require access to a master database secret.
- Removed the obsolete `db-bootstrap` module from portal stack flows when it became unnecessary.
- Added README documentation explaining manual RDS database/user creation and secure credentials handling.

## Interaction Highlights

- The user requested that ECS containers should run on `t3.micro` instances and not use Fargate.
- GitHub Copilot identified the `aws_ecs_service` configuration and updated `modules/ecs-service/main.tf` from `FARGATE` to `EC2`.
- GitHub Copilot added EC2 cluster resources, including an ECS-optimized AMI, instance role, launch template, and autoscaling group.
- The user then requested S3 bucket permissions be added for IAM task roles and bucket policies, and GitHub Copilot began reviewing relevant files.
- The user asked to remove database password defaults from Terraform variables and pass them via CLI during deployments.
- GitHub Copilot updated backend files, portal stack backend blocks, and the shared-platform stack configuration accordingly.
- The user clarified that only shared-platform should need the `db_password` on deployment, and GitHub Copilot adjusted the flow to keep portal deployments clean.
- The user asked for portal-specific database isolation, and GitHub Copilot updated per-portal secrets and IAM role-based access logic.
- When the user confirmed `db-bootstrap` was no longer needed, GitHub Copilot removed the portal bootstrap module and cleaned up outputs.

## Collaboration Notes

- The user is working in a Terraform-based AWS infrastructure repository with separate stacks for shared platform resources and portal-specific services.
- GitHub Copilot followed the user's instructions closely, making targeted edits to modules and stack files.
- The workflow was iterative: inspection of existing Terraform definitions, editing configuration files, formatting, and validation steps.
- The focus shifted from infrastructure provisioning to secure state management and least-privilege database access.
- The project uses a modular Terraform architecture with shared-platform and portal-specific stacks.

## Final State

- `stacks/shared-platform` now handles backend setup, RDS provisioning, and secrets generation for portal credentials.
- Portal stacks are designed to use portal-specific Secrets Manager entries and IAM roles, without requiring raw password variables.
- The README now explains how to deploy shared-platform, migrate state, and manually create RDS databases and users using generated secrets.

## Actual Prompts used

- the ec2 containers running the services should be on t3.micro instnaces and we're not gonna use fargate
- add s3 bucket permissions for iam task roles as well as bucket policies
- create an ai_log.md file , including our conversations and summary of how wev'e wrked together
- add the prompts i provided

