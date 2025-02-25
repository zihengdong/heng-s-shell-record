#!/bin/bash

SAM_FILE="20240529_8.fastqfilt.fq.filthuman.fq.sam"
BAM_FILE="20240529_8.fastqfilt.fq.filthuman.fq.bam"
SORTED_BAM_FILE="20240529_8.fastqfilt.fq.filthuman.fq.sorted.bam"
THREADS=8

# 检查 SAMtools 是否安装
if ! command -v samtools &> /dev/null; then
    echo "请先安装 SAMtools！"
    echo "安装命令示例：sudo apt-get install samtools 或 conda install -c bioconda samtools"
    exit 1
fi

if [ ! -f "$SAM_FILE" ]; then
    echo "错误：输入文件 $SAM_FILE 不存在！"
    exit 1
fi

# 步骤 1：将 SAM 转换为 BAM
echo "正在将 $SAM_FILE 转换为 BAM 格式..."
samtools view -b -o "$BAM_FILE" "$SAM_FILE"
if [ $? -ne 0 ]; then
    echo "错误：SAM 转 BAM 失败！"
    exit 1
fi
echo "完成：生成 $BAM_FILE"

# 步骤 2：对 BAM 文件排序
echo "正在对 $BAM_FILE 进行排序（使用 $THREADS 个线程）..."
samtools sort -@ "$THREADS" -o "$SORTED_BAM_FILE" "$BAM_FILE"
if [ $? -ne 0 ]; then
    echo "错误：BAM 排序失败！"
    exit 1
fi
echo "完成：生成 $SORTED_BAM_FILE"

# 步骤 3：为排序后的 BAM 文件创建索引
echo "正在为 $SORTED_BAM_FILE 创建索引..."
samtools index "$SORTED_BAM_FILE"
if [ $? -ne 0 ]; then
    echo "错误：索引创建失败！"
    exit 1
fi
echo "完成：生成 $SORTED_BAM_FILE.bai"


# 验证结果
echo "处理完成！最终文件："
ls -lh "$SORTED_BAM_FILE" "$SORTED_BAM_FILE.bai"

echo "任务成功结束！"