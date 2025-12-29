#!/bin/bash
# 清空syslog/kern.log核心日志
sudo truncate -s 0 /var/log/syslog
sudo truncate -s 0 /var/log/kern.log
# 清理journal日志，只保留500M
sudo journalctl --vacuum-size=500M > /dev/null 2>&1
# 删除日志的历史压缩文件(.1 .gz结尾)
sudo rm -rf /var/log/*.1 /var/log/*.gz /var/log/*-???????? /var/log/*.old 2>/dev/null
# 清理docker日志（如果你用docker，必清）
sudo find /var/lib/docker/containers -name "*.log" -exec truncate -s 0 {} \; 2>/dev/null
# 清理临时日志
sudo rm -rf /var/log/nginx/* /var/log/mysql/* /var/log/apache2/* 2>/dev/null
echo "✅ 日志清理完成！空间已释放"
