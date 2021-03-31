resource "aws_iam_role" "EksWorkerNodesSsm" {
  name = "EksWorkerNodesSsm"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

data "aws_iam_policy" "AmazonEKSWorkerNodePolicy" {
  arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_policy_attachment" "EksWorkerNodesSsm-policy-attachement-1" {
  name       = "EksWorkerNodesSsm-policy-attachement-1"
  roles      = [aws_iam_role.EksWorkerNodesSsm.name]
  policy_arn = data.aws_iam_policy.AmazonEKSWorkerNodePolicy.arn
}

data "aws_iam_policy" "AmazonEC2ContainerRegistryReadOnly" {
  arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_policy_attachment" "EksWorkerNodesSsm-policy-attachement-2" {
  name       = "EksWorkerNodesSsm-policy-attachement-2"
  roles      = [aws_iam_role.EksWorkerNodesSsm.name]
  policy_arn = data.aws_iam_policy.AmazonEC2ContainerRegistryReadOnly.arn
}

data "aws_iam_policy" "AmazonEKS_CNI_Policy" {
  arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_policy_attachment" "EksWorkerNodesSsm-policy-attachement-3" {
  name       = "EksWorkerNodesSsm-policy-attachement-3"
  roles      = [aws_iam_role.EksWorkerNodesSsm.name]
  policy_arn = data.aws_iam_policy.AmazonEKS_CNI_Policy.arn
}

data "aws_iam_policy" "AmazonSSMManagedInstanceCore" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_policy_attachment" "EksWorkerNodesSsm-policy-attachement-4" {
  name       = "EksWorkerNodesSsm-policy-attachement-4"
  roles      = [aws_iam_role.EksWorkerNodesSsm.name]
  policy_arn = data.aws_iam_policy.AmazonSSMManagedInstanceCore.arn
}

resource "aws_iam_instance_profile" "EksWorkerNodesSsm_instance_profile" {
  name = "EksWorkerNodesSsm"
  role = aws_iam_role.EksWorkerNodesSsm.name
}