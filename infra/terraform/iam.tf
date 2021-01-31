resource "aws_api_gateway_account" "this" {
  cloudwatch_role_arn = substr(aws_iam_role.cloudwatch.arn, 0, 63)
}

resource "aws_iam_role" "cloudwatch" {
  name = substr(format("%s-%s-apigw-cloudwatch", var.stage, var.environment), 0, 63)

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "cloudwatch" {
  name = substr(format("%s-%s-API-GW-CW-role-policy", var.stage, var.environment), 0, 63)
  role = aws_iam_role.cloudwatch.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams",
                "logs:PutLogEvents",
                "logs:GetLogEvents",
                "logs:FilterLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}
