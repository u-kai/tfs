#!/bin/bash

# 必要な変数
REPOSITORY_NAME=$1   # ECRリポジトリ名 (例: my-repo)
EXISTING_TAG=$2      # 既存のイメージタグ (例: commit-hash)
NEW_TAG=$3           # 新しく追加するタグ (例: v1.0.0)

# ECRから既存のイメージマニフェストを取得
IMAGE_MANIFEST=$(aws ecr batch-get-image \
  --repository-name "$REPOSITORY_NAME" \
  --image-ids imageTag="$EXISTING_TAG" \
  --query 'images[0].imageManifest' \
  --output text)

# エラーチェック: もしイメージマニフェストが取得できなかった場合
if [ -z "$IMAGE_MANIFEST" ]; then
  echo "Error: イメージマニフェストが取得できませんでした。既存のタグが正しいか確認してください。"
  exit 1
fi

# 既存のイメージに新しいタグを追加
aws ecr put-image \
  --repository-name "$REPOSITORY_NAME" \
  --image-tag "$NEW_TAG" \
  --image-manifest "$IMAGE_MANIFEST"

# 結果表示
if [ $? -eq 0 ]; then
  echo "新しいタグ '$NEW_TAG' がリポジトリ '$REPOSITORY_NAME' に追加されました。"
else
  echo "Error: タグの追加に失敗しました。"
fi
