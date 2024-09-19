#!/bin/zsh

# 必要な変数を設定
ROLE_NAME="AutoGitHubActionsOIDCRole"
POLICY_NAME="AdministratorAccess"  # Admin権限を付与
GITHUB_REPO="u-kai/tfs"  # GitHubリポジトリ (例: your-org/your-repo)
GITHUB_OIDC_URL="token.actions.githubusercontent.com"
#AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
REGION="ap-northeast-1"  # 指定されたリージョン


TRUST_POLICY_DOCUMENT=$(cat <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam::${AWS_ACCOUNT_ID}:oidc-provider/${GITHUB_OIDC_URL}"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                    "${GITHUB_OIDC_URL}:sub": "repo:${GITHUB_REPO}:ref:refs/heads/main"
                }
            }
        }
    ]
}
EOF
)


#
## IAMロールの作成
echo "Creating IAM Role: $ROLE_NAME"
aws iam create-role \
  --role-name "$ROLE_NAME" \
  --assume-role-policy-document "$TRUST_POLICY_DOCUMENT" \
  --description "Role for GitHub Actions OIDC Trust with $GITHUB_REPO" \
  --output text \
  --region "$REGION"


# 既存のAdministratorAccessポリシーをロールにアタッチ
echo "Attaching AdministratorAccess policy to the role"
aws iam attach-role-policy \
  --role-name "$ROLE_NAME" \
  --policy-arn "arn:aws:iam::aws:policy/AdministratorAccess" \
  --region "$REGION"

echo "IAM Role for GitHub Actions OIDC trust with AdministratorAccess has been created."
