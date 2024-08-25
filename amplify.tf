resource "aws_amplify_app" "app" {
  name         = "app"
  repository   = local.repository_url
  access_token = var.github_access_token
  build_spec   = <<EOF
    version: 1
    applications:
    - appRoot: app
      frontend:
        phases:
          preBuild:
            commands:
              - npm ci
          build:
            commands:
              - npm run build
        artifacts:
          baseDirectory: .next
          files:
            - '**/*'
        cache:
          paths:
            - node_modules/**/*
  EOF

  enable_auto_branch_creation = true
  enable_branch_auto_build    = true
  enable_branch_auto_deletion = true
  platform                    = "WEB_COMPUTE"
  iam_service_role_arn        = aws_iam_role.app_role.arn
  auto_branch_creation_config {
    enable_pull_request_preview = true
  }

  environment_variables = {
    "AMPLIFY_MONOREPO_APP_ROOT" = "app"
  }

  tags = {
    Name = "app"
  }
}

resource "aws_amplify_branch" "main" {
  app_id      = aws_amplify_app.app.id
  branch_name = "main"
  framework   = "Next.js - SSR"

  enable_auto_build = true

  stage = "PRODUCTION"
}

# ドメインを設定
resource "aws_amplify_domain_association" "app" {
  app_id      = aws_amplify_app.app.id
  domain_name = local.domain_name

  sub_domain {
    branch_name = aws_amplify_branch.main.branch_name
    prefix      = ""
  }

  sub_domain {
    branch_name = aws_amplify_branch.main.branch_name
    prefix      = "www"
  }
}

