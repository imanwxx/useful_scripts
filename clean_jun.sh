#!/bin/bash

# Linux垃圾清理脚本
# 作者: AI助手
# 版本: 1.0

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 函数：显示分隔线
function show_separator() {
    echo -e "${BLUE}================================================${NC}"
}

# 函数：显示标题
function show_title() {
    clear
    echo -e "${GREEN}╔══════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║           Linux系统垃圾清理工具 v1.0            ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════╝${NC}"
    echo ""
}

# 函数：显示菜单
function show_menu() {
    show_title
    echo -e "${YELLOW}请选择要执行的操作：${NC}"
    echo ""
    echo "1) 查看磁盘使用情况"
    echo "2) 清理系统缓存"
    echo "3) 清理包管理器缓存"
    echo "4) 清理开发工具缓存"
    echo "5) 清理用户临时文件"
    echo "6) 清理旧的内核"
    echo "7) 查找并删除大文件"
    echo "8) 全自动清理"
    echo "9) 退出"
    echo ""
    echo -n "请输入选项 [1-9]: "
}

# 函数：显示磁盘使用情况
function show_disk_usage() {
    show_separator
    echo -e "${GREEN}当前磁盘使用情况：${NC}"
    echo ""
    df -h
    echo ""
    
    echo -e "${GREEN}目录空间占用前10：${NC}"
    du -sh /home/wx/* 2>/dev/null | sort -rh | head -10
    echo ""
    read -p "按回车键继续..."
}

# 函数：清理系统缓存
function clean_system_cache() {
    show_separator
    echo -e "${GREEN}正在清理系统缓存...${NC}"
    echo ""
    
    # 清理内存缓存
    echo -e "${YELLOW}清理内存缓存...${NC}"
    if [ "$EUID" -eq 0 ]; then
        sync && echo 3 > /proc/sys/vm/drop_caches
        echo -e "${GREEN}内存缓存清理完成${NC}"
    else
        echo -e "${RED}需要root权限清理内存缓存${NC}"
    fi
    
    # 清理系统日志
    echo -e "${YELLOW}清理系统日志...${NC}"
    if [ "$EUID" -eq 0 ]; then
        journalctl --vacuum-time=7d
        echo -e "${GREEN}系统日志清理完成${NC}"
    else
        echo -e "${RED}需要root权限清理系统日志${NC}"
    fi
    
    echo ""
    read -p "按回车键继续..."
}

# 函数：清理包管理器缓存
function clean_package_cache() {
    show_separator
    echo -e "${GREEN}正在清理包管理器缓存...${NC}"
    echo ""
    
    # 检测包管理器并清理
    if command -v apt-get &> /dev/null; then
        echo -e "${YELLOW}清理APT缓存...${NC}"
        if [ "$EUID" -eq 0 ]; then
            apt-get clean
            apt-get autoclean
            apt-get autoremove -y
            echo -e "${GREEN}APT缓存清理完成${NC}"
        else
            echo -e "${RED}需要root权限清理APT缓存${NC}"
        fi
    elif command -v yum &> /dev/null; then
        echo -e "${YELLOW}清理YUM缓存...${NC}"
        if [ "$EUID" -eq 0 ]; then
            yum clean all
            echo -e "${GREEN}YUM缓存清理完成${NC}"
        else
            echo -e "${RED}需要root权限清理YUM缓存${NC}"
        fi
    elif command -v dnf &> /dev/null; then
        echo -e "${YELLOW}清理DNF缓存...${NC}"
        if [ "$EUID" -eq 0 ]; then
            dnf clean all
            echo -e "${GREEN}DNF缓存清理完成${NC}"
        else
            echo -e "${RED}需要root权限清理DNF缓存${NC}"
        fi
    else
        echo -e "${YELLOW}未检测到支持的包管理器${NC}"
    fi
    
    echo ""
    read -p "按回车键继续..."
}

# 函数：清理开发工具缓存
function clean_dev_cache() {
    show_separator
    echo -e "${GREEN}正在清理开发工具缓存...${NC}"
    echo ""
    
    # 清理pip缓存
    if command -v pip &> /dev/null; then
        echo -e "${YELLOW}清理pip缓存...${NC}"
        pip cache purge
        echo -e "${GREEN}pip缓存清理完成${NC}"
    else
        echo -e "${YELLOW}pip未安装${NC}"
    fi
    
    # 清理conda缓存
    if command -v conda &> /dev/null; then
        echo -e "${YELLOW}清理conda缓存...${NC}"
        conda clean --all -y
        echo -e "${GREEN}conda缓存清理完成${NC}"
    else
        echo -e "${YELLOW}conda未安装${NC}"
    fi
    
    # 清理npm缓存
    if command -v npm &> /dev/null; then
        echo -e "${YELLOW}清理npm缓存...${NC}"
        npm cache clean --force
        echo -e "${GREEN}npm缓存清理完成${NC}"
    else
        echo -e "${YELLOW}npm未安装${NC}"
    fi
    
    # 清理Docker缓存
    if command -v docker &> /dev/null; then
        echo -e "${YELLOW}清理Docker缓存...${NC}"
        if [ "$EUID" -eq 0 ]; then
            docker system prune -a -f
            echo -e "${GREEN}Docker缓存清理完成${NC}"
        else
            echo -e "${RED}需要root权限清理Docker缓存${NC}"
        fi
    else
        echo -e "${YELLOW}Docker未安装${NC}"
    fi
    
    echo ""
    read -p "按回车键继续..."
}

# 函数：清理用户临时文件
function clean_user_temp() {
    show_separator
    echo -e "${GREEN}正在清理用户临时文件...${NC}"
    echo ""
    
    # 清理回收站
    echo -e "${YELLOW}清理回收站...${NC}"
    rm -rf ~/.local/share/Trash/*
    echo -e "${GREEN}回收站清理完成${NC}"
    
    # 清理缩略图缓存
    echo -e "${YELLOW}清理缩略图缓存...${NC}"
    rm -rf ~/.cache/thumbnails/*
    echo -e "${GREEN}缩略图缓存清理完成${NC}"
    
    # 清理浏览器缓存
    echo -e "${YELLOW}清理浏览器缓存...${NC}"
    rm -rf ~/.cache/google-chrome/* 2>/dev/null
    rm -rf ~/.cache/mozilla/firefox/* 2>/dev/null
    echo -e "${GREEN}浏览器缓存清理完成${NC}"
    
    # 清理其他缓存
    echo -e "${YELLOW}清理其他应用缓存...${NC}"
    find ~/.cache -type f -delete 2>/dev/null
    echo -e "${GREEN}其他应用缓存清理完成${NC}"
    
    echo ""
    read -p "按回车键继续..."
}

# 函数：清理旧的内核
function clean_old_kernels() {
    show_separator
    echo -e "${GREEN}正在清理旧的内核...${NC}"
    echo ""
    
    if command -v apt-get &> /dev/null; then
        echo -e "${YELLOW}检查旧内核...${NC}"
        if [ "$EUID" -eq 0 ]; then
            apt-get autoremove --purge -y linux-image-*-generic
            echo -e "${GREEN}旧内核清理完成${NC}"
        else
            echo -e "${RED}需要root权限清理旧内核${NC}"
        fi
    else
        echo -e "${YELLOW}此功能仅支持Ubuntu/Debian系统${NC}"
    fi
    
    echo ""
    read -p "按回车键继续..."
}

# 函数：查找并删除大文件
function find_large_files() {
    show_separator
    echo -e "${GREEN}查找大文件...${NC}"
    echo ""
    
    echo "请输入要搜索的路径 (默认为/home/wx):"
    read search_path
    if [ -z "$search_path" ]; then
        search_path="/home/wx"
    fi
    
    echo "请输入文件大小阈值 (MB):"
    read size_threshold
    if [ -z "$size_threshold" ]; then
        size_threshold="100"
    fi
    
    echo -e "${YELLOW}搜索${search_path}中大于${size_threshold}MB的文件...${NC}"
    find "$search_path" -type f -size +"${size_threshold}M" 2>/dev/null | head -20
    
    echo ""
    echo -n "是否删除这些文件? (y/N): "
    read confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        find "$search_path" -type f -size +"${size_threshold}M" -delete 2>/dev/null
        echo -e "${GREEN}大文件删除完成${NC}"
    fi
    
    echo ""
    read -p "按回车键继续..."
}

# 函数：全自动清理
function auto_clean() {
    show_separator
    echo -e "${GREEN}正在执行全自动清理...${NC}"
    echo ""
    
    # 清理包管理器缓存
    echo -e "${YELLOW}[1/5] 清理包管理器缓存...${NC}"
    if command -v apt-get &> /dev/null && [ "$EUID" -eq 0 ]; then
        apt-get clean && apt-get autoclean && apt-get autoremove -y
    elif command -v yum &> /dev/null && [ "$EUID" -eq 0 ]; then
        yum clean all
    elif command -v dnf &> /dev/null && [ "$EUID" -eq 0 ]; then
        dnf clean all
    fi
    echo -e "${GREEN}包管理器缓存清理完成${NC}"
    
    # 清理开发工具缓存
    echo -e "${YELLOW}[2/5] 清理开发工具缓存...${NC}"
    if command -v pip &> /dev/null; then pip cache purge; fi
    if command -v conda &> /dev/null; then conda clean --all -y; fi
    if command -v npm &> /dev/null; then npm cache clean --force; fi
    if command -v docker &> /dev/null && [ "$EUID" -eq 0 ]; then docker system prune -a -f; fi
    echo -e "${GREEN}开发工具缓存清理完成${NC}"
    
    # 清理用户临时文件
    echo -e "${YELLOW}[3/5] 清理用户临时文件...${NC}"
    rm -rf ~/.local/share/Trash/*
    rm -rf ~/.cache/thumbnails/*
    rm -rf ~/.cache/google-chrome/* 2>/dev/null
    rm -rf ~/.cache/mozilla/firefox/* 2>/dev/null
    find ~/.cache -type f -delete 2>/dev/null
    echo -e "${GREEN}用户临时文件清理完成${NC}"
    
    # 清理系统日志
    echo -e "${YELLOW}[4/5] 清理系统日志...${NC}"
    if [ "$EUID" -eq 0 ]; then journalctl --vacuum-time=7d; fi
    echo -e "${GREEN}系统日志清理完成${NC}"
    
    # 清理临时文件
    echo -e "${YELLOW}[5/5] 清理系统临时文件...${NC}"
    if [ "$EUID" -eq 0 ]; then
        rm -rf /tmp/*
        rm -rf /var/tmp/*
    fi
    echo -e "${GREEN}系统临时文件清理完成${NC}"
    
    echo ""
    echo -e "${GREEN}全自动清理完成！${NC}"
    read -p "按回车键继续..."
}

# 函数：退出程序
function exit_program() {
    show_separator
    echo -e "${GREEN}感谢使用Linux系统垃圾清理工具！${NC}"
    exit 0
}

# 主程序
function main() {
    while true; do
        show_menu
        read choice
        
        case $choice in
            1) show_disk_usage ;;
            2) clean_system_cache ;;
            3) clean_package_cache ;;
            4) clean_dev_cache ;;
            5) clean_user_temp ;;
            6) clean_old_kernels ;;
            7) find_large_files ;;
            8) auto_clean ;;
            9) exit_program ;;
            *) 
                echo -e "${RED}无效选项，请重新输入！${NC}"
                sleep 1
                ;;
        esac
    done
}

# 检查是否以root权限运行
if [ "$EUID" -ne 0 ]; then
    echo -e "${YELLOW}提示：某些操作需要root权限，建议使用sudo运行此脚本${NC}"
    echo ""
fi

# 启动主程序
main
