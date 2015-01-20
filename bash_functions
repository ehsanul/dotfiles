function parse_git_branch_and_add_brackets(){
    #git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\ \[\1\]/'
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e s/"* "/" "/
}

function linerate(){
    pv -ltr -i1 > /dev/null
}

function weblog_grep(){
    local pattern=${1}
    local log=${2}
    dsh -cg web -- "tail -f $log | grep --line-buffered -P '$pattern'"
}
