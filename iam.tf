resource "aws_iam_role" "app_role" {
  name = "app_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "amplify.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "app_policy" {
  name        = "myapp"
  description = "Policy for app"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "PushLogs",
        Effect = "Allow",
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "arn:aws:logs:ap-northeast-1:${data.aws_caller_identity.current.account_id}:log-group:/aws/amplify/*:log-stream:*"
      },
      {
        Sid    = "CreateLogGroup",
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup"
        ],
        Resource = "arn:aws:logs:ap-northeast-1:${data.aws_caller_identity.current.account_id}:log-group:/aws/amplify/*"
      },
      {
        Sid    = "DescribeLogGroups",
        Effect = "Allow",
        Action = [
          "logs:DescribeLogGroups"
        ],
        Resource = "arn:aws:logs:ap-northeast-1:${data.aws_caller_identity.current.account_id}:log-group:*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "app_role_policy_attachment" {
  role       = aws_iam_role.app_role.name
  policy_arn = aws_iam_policy.app_policy.arn
}
