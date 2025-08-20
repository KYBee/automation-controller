#!/bin/bash

# 스크립트의 첫 번째 인자로 대상 레퍼지토리 경로를 받습니다. (예: 'YOUR_USERNAME/target-repo-A')
TARGET_REPO=$1
# PR을 위한 새로운 브랜치 이름을 현재 시간 기준으로 생성합니다.
NEW_BRANCH="feat/auto-pr-$(date +%s)"

# 1. 대상 레퍼토리를 복제(clone)합니다.
echo "Cloning ${TARGET_REPO}..."
git clone "https://${GITHUB_ACTOR}:${GITHUB_TOKEN}@github.com/${TARGET_REPO}.git" temp_repo
cd temp_repo

# 2. 새로운 브랜치를 생성하고 이동합니다.
git checkout -b "$NEW_BRANCH"

# 3. "안녕?" 이라는 내용을 담은 파일을 생성하여 변경 사항을 만듭니다.
echo "안녕? 이 PR은 자동 생성되었어." > HELLO.md

# 4. 변경 사항을 커밋하고 푸시합니다.
git config --global user.email "action@github.com"
git config --global user.name "GitHub Action"
git add HELLO.md
git commit -m "feat: 자동 PR 생성"
git push origin "$NEW_BRANCH"

# 5. gh CLI를 사용하여 PR을 생성합니다.
echo "Creating PR for ${TARGET_REPO}..."
gh pr create \
  --repo "$TARGET_REPO" \
  --title "👋 안녕? 자동 생성된 PR이야" \
  --body "이 PR은 'automation-controller' 레퍼지토리의 GitHub Actions에 의해 자동으로 생성되었습니다." \
  --base main

echo "PR for ${TARGET_REPO} created successfully!"
