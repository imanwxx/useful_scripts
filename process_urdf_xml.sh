#!/bin/bash
set -euo pipefail

# ===================== 配置参数 =====================
TARGET_EXT=".urdf"
INSERT_LINE=7               # 在第7行插入（原第7行后移）
BACKUP_SUFFIX=".bak_$(date +%Y%m%d_%H%M%S)"

# 要插入的内容（严格保留缩进，无需手动转义）
INSERT_CONTENT='<mujoco>
    <compiler 
    meshdir="../meshes/" 
    balanceinertia="true" 
    discardvisual="false" />
  </mujoco>
  <link name="world"/>
  <joint name="floating_base_joint" type="floating">
    <origin xyz="0 0 0" rpy="0 0 0" />
    <parent link="world"/>
    <child link="base_link"/>
  </joint>'

# ===================== 核心适配（关键修复） =====================
# 生成适配sed的多行插入命令
generate_sed_script() {
  local content="$1"
  local line="$2"
  local sed_script=""

  # 逐行处理插入内容，每行前加\（适配sed语法）
  while IFS= read -r line_content; do
    # 对空行也保留（避免丢失格式）
    if [[ -z "$line_content" ]]; then
      sed_script+="\\n"
    else
      sed_script+="\\${line_content}\\n"
    fi
  done <<< "$content"

  # 构造最终的sed命令：行号i\ + 转义后的内容
  echo "${line}i\\${sed_script%\\n}"  # 去掉最后一个多余的\n
}

# ===================== 主逻辑 =====================
echo "===== 查找${TARGET_EXT}文件 ====="
urdf_files=()
# 兼容空格/特殊字符的文件查找
while IFS= read -r -d '' file; do
  urdf_files+=("$file")
done < <(find ./ -maxdepth 1 -type f -name "*${TARGET_EXT}" -print0)

if [[ ${#urdf_files[@]} -eq 0 ]]; then
  echo "错误：未找到${TARGET_EXT}文件！"
  exit 1
fi
echo "找到 ${#urdf_files[@]} 个文件：${urdf_files[*]}"

# 批量处理
for file in "${urdf_files[@]}"; do
  echo -e "\n===== 处理：$file ====="
  
  # 1. 备份
  cp -f "$file" "${file}${BACKUP_SUFFIX}"
  echo "备份：${file}${BACKUP_SUFFIX}"
  
  # 2. 生成sed插入脚本（核心修复）
  SED_SCRIPT=$(generate_sed_script "$INSERT_CONTENT" "$INSERT_LINE")
  
  # 3. 执行sed（区分系统）
  if [[ "$(uname)" == "Darwin" ]]; then
    # macOS：sed -i '' 必须加空字符串
    sed -i '' "$SED_SCRIPT" "$file"
  else
    # Linux
    sed -i "$SED_SCRIPT" "$file"
  fi
  # 验证
  echo "验证插入位置（第$INSERT_LINE行附近）："
  sed -n "$((INSERT_LINE-1)),$((INSERT_LINE+10))p" "$file"
done

echo -e "\n===== 处理完成！====="
echo "编译urdf到xml"
cd /home/wx/.mujoco/mujoco210/bin


