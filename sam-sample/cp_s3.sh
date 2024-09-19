#!/bin/bash

# 引数の確認
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <source-bucket> <source-key> <destination-key>"
    exit 1
fi

# コマンド引数を変数に代入
SOURCE_BUCKET=$1
SOURCE_KEY=$2
DESTINATION_KEY=$3

# オブジェクトのコピー
aws s3 cp "s3://$SOURCE_BUCKET/$SOURCE_KEY" "s3://$SOURCE_BUCKET/$DESTINATION_KEY"

# 成功メッセージ
if [ $? -eq 0 ]; then
    echo "Successfully copied $SOURCE_KEY to $DESTINATION_KEY in bucket $SOURCE_BUCKET"
else
    echo "Error copying object."
    exit 1
fi
