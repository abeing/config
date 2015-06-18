# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions
export PATH=$PATH:/home/builder/bin

export EDITOR=vim

# Don't use a GUI to ask for SSH passwords (why?!)
unset SSH_ASKPASS
export P4USER=mieziaa
export MYIPADR=rntqepool08
export P4CLIENT=mieziaa_rntqepool08.wz.hasbro.com
export P4JOURNAL=/home/builder/perforce/journal
export P4LOG=/home/builder/perforce/p4err
export P4PORT=tcp:10.1.32.35:1666
export P4ROOT=/home/builder/depot

export LD_LIBRARY_PATH=/home/builder/depot/thirdparty/boost/lib6:/home/builder/depot/mol/leagues/source/lib:/home/builder/depot/thirdparty/expat/2.0.1/lib
export MTGOV3_TEST_FRAMEWORK_PATH=/home/builder/depot/QA/mol/leagues/test_framework_static/:/home/builder/depot/QA/mol/leagues/test_framework_static/Functional/:/home/builder/depot/QA/mol/leagues/test_framework_static/Load/

alias cdaction='cd ~/depot/QA/mol/leagues/test_framework_static/Functional'

