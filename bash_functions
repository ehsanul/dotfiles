function parse_git_branch_and_add_brackets(){
    #git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\ \[\1\]/'
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e s/"* "/" "/
}

funcion docker_log_grep(){
  docker ps | grep mytime-web | cut -d' ' -f1 | xargs -n1 docker logs 2>/dev/null | grep '${1}'
}

function linerate(){
    pv -ltr -i1 > /dev/null
}

function weblog_grep(){
    local pattern=${1}
    local log=${2}
    dsh -Mcg web -- "tail -f $log | grep --line-buffered -P '$pattern'"
}

# function wspec(){
#     local spec=${1}
#     # run once right away since fswatch won't trigger until a file change
#     REUSE_SNAPSHOT=true bin/rspec $spec
#     fswatch -o -e ".*" -i "\\.rb$" . | REUSE_SNAPSHOT=true xargs -n1 -I{} bin/rspec $spec
# }

function eg(){
    MAN_KEEP_FORMATTING=1 man "$@" 2>/dev/null \
        | gsed --quiet --expression='/^E\(\x08.\)X\(\x08.\)\?A\(\x08.\)\?M\(\x08.\)\?P\(\x08.\)\?L\(\x08.\)\?E/{:a;p;n;/^[^ ]/q;ba}' \
        | less
        #| ${MANPAGER:-${PAGER:-pager -s}}
}

function update_web_dsh_mtmux(){
  aws ec2 describe-instances --filters 'Name=tag:Name,Values=production-latency-ecs' --output json --query 'Reservations[*].Instances[*].PrivateDnsName' \
      | ruby -rjson -e 'puts JSON.parse($stdin.read).flatten.reject {|x| x.size == 0 }.join("\n")' \
      | sed -e 's/^/mytime-user@/g' \
      | tee $HOME/.mtmux/web $HOME/.dsh/group/web
}

function gbst {
  branch_name=$(git symbolic-ref -q HEAD)
  branch_name=${branch_name##refs/heads/}
  declare branch_name=${branch_name:-HEAD}
  declare staging_branch_name=${branch_name}_staging
  git pull
  git checkout master
  git pull
  git branch -D $staging_branch_name
  git checkout -b $staging_branch_name
  git merge --squash $branch_name
  git commit -am "deploy for $branch_name"
  git push --force origin $staging_branch_name
  git checkout $branch_name
}
