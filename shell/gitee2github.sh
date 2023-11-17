#!/bin/bash


# gitee2github.sh




currentDate=`date "+%Y-%m-%d %H:%M:%S"`
echo "-当前时间-"${currentDate}


# 当前脚本所在的目录
# script_dir=$(dirname $0)
script_dir=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)
echo ${script_dir}

script_parent_dir=$(dirname "${script_dir}")
echo ${script_parent_dir}


# 当前脚本所在的目录 上级目录
project_root_dir=$(dirname "${script_dir}")

# 当前执行命令的目录
pwd_dir=$(pwd)


## purple to echo
function purple(){
    echo -e "\033[35m$1\033[0m"
}


## green to echo
function green(){
    echo -e "\033[32m$1\033[0m"
}

## Error to warning with blink
function bred(){
    echo -e "\033[31m\033[01m\033[05m$1\033[0m"
}

## Error to warning with blink
function byellow(){
    echo -e "\033[33m\033[01m\033[05m$1\033[0m"
}


## Error
function red(){
    echo -e "\033[31m\033[01m$1\033[0m"
}

## warning
function yellow(){
    echo -e "\033[33m\033[01m$1\033[0m"
}







token_env=${script_dir}/token_env.sh

source ${token_env}


fileContentFile="${script_dir}/gitee2github_repo.txt"



while read -r oneLine
do


	aRepo=` echo ${oneLine} | awk -F '===' '{print $1}'  `
	bRepo=` echo ${oneLine} | awk -F '===' '{print $2}'`
	dirName=` echo ${oneLine} | awk -F '===' '{print $3}'`



    if [ -z "${aRepo}" ] ; then
       # echo ${aRepo}
       continue
    fi
    if [ -z "${bRepo}" ] ; then
       # echo ${bRepo}
       continue
    fi
    if [ -z "${dirName}" ] ; then
       # echo ${dirName}
       continue
    fi

    fileDirName="${script_parent_dir}/${dirName}"
    green ${fileDirName}

    # 变量替换 ${aRepo/old/new} 如果old搜索不到则不替换为new,old是不存在的变量不会报错
    aRepo=${aRepo/'${a_gitlab_token}'/${a_gitlab_token}}
    bRepo=${bRepo/'${b_github_token}'/${b_github_token}}


    
    
    purple "git clone ${aRepo}   ${fileDirName}"

    git clone ${aRepo}   ${fileDirName}
    cd "${fileDirName}"
    yellow "git remote add --mirror=fetch origin_simple_bak  ${bRepo}"
    git remote add --mirror=fetch origin_simple_bak  ${bRepo}
    # git pull --all
    git push origin_simple_bak --all  --force
    git push origin_simple_bak --tags

    rm -rf ${fileDirName}
    cd "${pwd_dir}"

	echo ""

done < ${fileContentFile}




