#!/usr/bin/env bash
# MPPL Docker 镜像构建并推送到 DockerHub。
# 用法（仓库根目录）:
#   ./scripts/docker-build-push.sh
#   ./scripts/docker-build-push.sh --build-only
#   ./scripts/docker-build-push.sh --version 2.0.1
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

CONFIG="${ROOT}/scripts/dockerhub.env"
if [[ -f "$CONFIG" ]]; then
  # shellcheck source=/dev/null
  source "$CONFIG"
fi

BUILD_ONLY=false
PUSH_ONLY=false
NO_CACHE=""
VERSION_ARG=""

usage() {
  cat <<'EOF'
用法: ./scripts/docker-build-push.sh [选项]

从仓库根目录 VERSION 读取发布版本（可用 IMAGE_TAG 或 --version 覆盖），
构建 mppl 镜像并推送到 DockerHub。

配置:
  scripts/dockerhub.env   复制自 dockerhub.env.example，设置 DOCKERHUB_USERNAME
  VERSION                 当前发布版本（semver，如 2.0.0）

环境变量（可覆盖配置文件）:
  DOCKERHUB_USERNAME      DockerHub 用户名（必填）
  IMAGE_TAG               镜像 tag，默认读取 VERSION

选项:
  --build-only, -b    仅构建，不推送
  --push-only, -p     仅推送已有本地镜像
  --no-cache          构建禁用缓存
  --version <tag>     指定版本 tag
  -h, --help          显示帮助
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --build-only|-b)
      BUILD_ONLY=true
      shift
      ;;
    --push-only|-p)
      PUSH_ONLY=true
      shift
      ;;
    --no-cache)
      NO_CACHE="--no-cache"
      shift
      ;;
    --version)
      if [[ $# -lt 2 ]]; then
        echo "错误: --version 需要参数" >&2
        exit 1
      fi
      VERSION_ARG="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "未知参数: $1" >&2
      usage
      exit 1
      ;;
  esac
done

read_version() {
  local v
  if [[ -n "$VERSION_ARG" ]]; then
    echo "$VERSION_ARG"
    return
  fi
  if [[ -n "${IMAGE_TAG:-}" ]]; then
    echo "$IMAGE_TAG"
    return
  fi
  if [[ ! -f "$ROOT/VERSION" ]]; then
    echo "错误: 未找到 VERSION，请创建或通过 IMAGE_TAG / --version 指定版本。" >&2
    exit 1
  fi
  v="$(tr -d ' \r\n' < "$ROOT/VERSION")"
  if [[ ! "$v" =~ ^[0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z0-9.]+)?$ ]]; then
    echo "错误: VERSION 内容无效: '$v'（期望 semver，如 2.0.0）" >&2
    exit 1
  fi
  echo "$v"
}

IMAGE_TAG="$(read_version)"

if [[ -z "${DOCKERHUB_USERNAME:-}" ]]; then
  echo "错误: 请设置 DOCKERHUB_USERNAME。" >&2
  echo "  复制 scripts/dockerhub.env.example 为 scripts/dockerhub.env 并填写用户名，" >&2
  echo "  或执行: export DOCKERHUB_USERNAME=your-name" >&2
  exit 1
fi

if ! docker info >/dev/null 2>&1; then
  echo "错误: Docker 未运行，请先启动 Docker Engine / Docker Desktop。" >&2
  exit 1
fi

MPPL_IMAGE="${DOCKERHUB_USERNAME}/mppl:${IMAGE_TAG}"
MPPL_LATEST="${DOCKERHUB_USERNAME}/mppl:latest"

echo "==> MPPL Docker 发布"
echo "    用户: ${DOCKERHUB_USERNAME}"
echo "    版本: ${IMAGE_TAG}"
echo "    镜像: ${MPPL_IMAGE}"
echo

if [[ "$PUSH_ONLY" != true ]]; then
  echo "==> 构建 MPPL 镜像..."
  # shellcheck disable=SC2086
  docker build ${NO_CACHE:+$NO_CACHE} -f Dockerfile \
    -t "$MPPL_IMAGE" \
    -t "$MPPL_LATEST" \
    .

  echo
  echo "==> 本地镜像:"
  docker image ls --format 'table {{.Repository}}\t{{.Tag}}\t{{.Size}}' \
    | grep -E "^${DOCKERHUB_USERNAME}/mppl\s" || true
  echo
fi

if [[ "$BUILD_ONLY" == true ]]; then
  echo "==> 已完成构建（--build-only，未推送）。"
  exit 0
fi

echo "==> 推送到 DockerHub（需已执行 docker login）..."
docker push "$MPPL_IMAGE"
docker push "$MPPL_LATEST"

echo
echo "==> 发布完成: ${IMAGE_TAG}"
echo "    拉取: docker pull ${MPPL_IMAGE}"
echo "    使用: docker run --rm -v \$(pwd)/:/mppl ${MPPL_IMAGE} -o out.pdf doc.md"
