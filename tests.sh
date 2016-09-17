#!/bin/sh

# $Id: tests.sh,v 1.8 2015/11/04 00:02:45 gilles Exp gilles $

# $Log: tests.sh,v $
# Revision 1.8  2015/11/04 00:02:45  gilles
# Added ll_timeout2()
#
# Revision 1.7  2015/10/16 22:30:44  gilles
# Added justlogin.
#
# Revision 1.6  2013/09/22 22:29:05  gilles
# Change to pass new machine "petite".
#
# Revision 1.5  2008/09/01 01:31:15  gilles
# noidatefromheader() added to regression list.
#
# Revision 1.4  2008/09/01 01:27:52  gilles
# Added test noidatefromheader()
#
# Revision 1.3  2008/08/05 16:31:52  gilles
# Added ll_quiet()
# Added ll_ssl()
#
# Revision 1.2  2008/08/05 16:17:00  gilles
# Adapted all tests to localhost
#
# Revision 1.1  2003/08/19 01:17:14  gilles
# Initial revision
#


#### Shell pragmas

exec 3>&2 # 
#set -x   # debug mode. See what is running
set -e    # exit on first failure

#### functions definitions

echo3() {
        #echo '#####################################################' >&3
        echo "$*" >&3
}

run_test() {
        echo3 "#### $test_count $1"
        $1
        if test x"$?" = x"0"; then
                echo "$1 passed"
        else
                echo "$1 failed" >&2
        fi
}

run_tests() {
        for t in $*; do
                test_count=`expr 1 + $test_count`
                run_test $t
                sleep 1
        done
}

#### Variable definitions

prog=pop2imap
test_count=0

##### The tests functions

perl_syntax() {
        perl -c ./${prog}
}


no_args() {
        ./${prog}
}

sendtestmessage() {
    email=${1:-"toto"}
    rand=`pwgen 16 1`
    mess='test:'$rand
    cmd="echo $mess""| mail -s ""$mess"" $email"
    echo $cmd
    eval "$cmd"
}

ll_justlogin() {
./pop2imap --host1 localhost --user1 toto --passfile1 /home/gilles/var/pass/secret.toto \
           --host2 localhost --user2 titi --passfile2 /home/gilles/var/pass/secret.titi \
           --justlogin
}


ll_basic() {
sendtestmessage
./pop2imap --host1 localhost --user1 toto --passfile1 /home/gilles/var/pass/secret.toto \
           --host2 localhost --user2 titi --passfile2 /home/gilles/var/pass/secret.titi
}



ll_quiet() {
sendtestmessage
./pop2imap --host1 localhost --user1 toto --passfile1 /home/gilles/var/pass/secret.toto \
           --host2 localhost --user2 titi --passfile2 /home/gilles/var/pass/secret.titi \
           --quiet
}

ll_timeout2() {
./pop2imap --host1 localhost --user1 toto --passfile1 /home/gilles/var/pass/secret.toto \
           --host2 localhost --user2 titi --passfile2 /home/gilles/var/pass/secret.titi \
           --timeout2 4
}




badpophost() {
! ./pop2imap --host1 nogoodhost --user1 toto --passfile1 /home/gilles/var/pass/secret.toto \
             --host2 localhost  --user2 titi --passfile2 /home/gilles/var/pass/secret.titi
}

connect_refused() {
! ./pop2imap --host1 localhost --port1 109 --user1 toto --passfile1 /home/gilles/var/pass/secret.toto \
             --host2 localhost             --user2 titi --passfile2 /home/gilles/var/pass/secret.titi

}


dry_mode() {
./pop2imap --host1 localhost --user1 toto --passfile1 /home/gilles/var/pass/secret.toto \
           --host2 localhost --user2 titi --passfile2 /home/gilles/var/pass/secret.titi \
           --dry
}


delete_opt() {
 ./pop2imap --host1 localhost --user1 toto --passfile1 /home/gilles/var/pass/secret.toto \
            --host2 localhost --user2 titi --passfile2 /home/gilles/var/pass/secret.titi \
	    --delete
}


ll_ssl() {
 ./pop2imap --host1 localhost --user1 toto --passfile1 /home/gilles/var/pass/secret.toto \
            --host2 localhost --user2 titi --passfile2 /home/gilles/var/pass/secret.titi \
            --ssl1 --ssl2
}

noidatefromheader() {
 ./pop2imap --host1 localhost --user1 toto --passfile1 /home/gilles/var/pass/secret.toto \
            --host2 localhost --user2 titi --passfile2 /home/gilles/var/pass/secret.titi \
            --noidatefromheader
}



# mandatory tests

run_tests perl_syntax 


# All tests

test $# -eq 0 && run_tests \
        no_args         \
        ll_justlogin    \
        ll_basic        \
	ll_timeout2     \
        ll_quiet        \
        badpophost      \
	connect_refused \
	dry_mode        \
	delete_opt      \
        ll_ssl          \
        noidatefromheader

# selective tests

test $# -gt 0 && run_tests "$@"

# If there, all is good

echo3 ALL $test_count TESTS SUCCESSFUL





