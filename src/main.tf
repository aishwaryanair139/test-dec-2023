Provider "aws" {
   region = "ap-south-1"
   Shared_credentials_files = ["C:/Users/HP/.aws"]

}

resource "aws_iam_role" "lambda_role" {
    name = "terraform_aws_lanmbda_role"
    assume_role_policy = <<EOF
    {
        "Version":"",
        "Statement": [
            {
                "Action": "sts:AssumeRole";
                "Principal":{
                    "Service": "Lambda.amazonaws.com"
                },
                "Effect": "Allow",
            }
        ]
    }
  EOF
}

#IAM Policy for loging from lambda

resource "aws_iam_policy" "iam_policy_for_lambda" {
  name = "aws_iam_policy_for_terraform_aws_lambda_role"
  path = "/"
  description = "AWS IAM Policy for managing aws Lambda role"
  policy = <<EOF
  {
    "Version": "",
    "Statement":[
        {
            "Action":[
                "logs:createLogGroup",
                "logs:CreateLogStream",
                "loges:PutLogEvents"

            ],
            "Resource": "arn:aws:logs:*:*:*,
            "Effect": "Allow"
        }
    ]
  }
  EOF
}

#Policy attachment on the role

resource "aws_iam_role_policy_attachment" "attach+iam_policy_to_iam_role" {
    role = aws_iam_role.Lambda_role.name
    policy_arn = aws_iam_policy.iam_policy_for_Lambda.arn
}

#Generation an archive from the content a file or a diectory

data "archive_file" "Zip_the_spring_code" {
    type = "Zip"
    Source_dir="${path.module}C:/Users/HP/Desktop/hello"
    output_path = "${path.module}C:/Users/HP/Desktop/hello/-hello.zip"
    }  

#create lambda function
#in terraform ${path.module}is the current directory
resource "aws_lambda_function" "terraform_lambda_func" {
    value = aws_iam_role.Lambda_role.name
    filename = "${path.module}C:/Users/HP/Desktop/hell-hello.zip"
    function_name = "Jhooq=Lambda-function"
    role= aws_iam_role.lambda_role.policy_arn
    handler= "HelloApplication.HelloController"
    runtime=""
    depends_on = [ aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role ]
}
output "terraform_aws_role_output" {
    value = aws_iam_role.lambda_role.arn
}

output "terraform_aws_role_arn_output" {
    value = aws_iam_role.lambda_role.arn
}
output "terraform_logging_arn_output" {
    value = aws_iam_policy.iam_policy_for_lambda.arn
}