#!/bin/bash

# The MIT License (MIT)
# 
# Copyright (c) 2011 Green Island Consulting LLC
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

# ABOUT
# -----
# A script to convert MySQL tables to InnoDB, or rebuild InnoDB tables.
#
# A simple (meaning zero validation of your usage) script to ALTER all tables to InnoDB Engine.
# If the table(s) are already InnoDB engine, they will be rebuilt, hence reclaiming fragmented space
# making this useful for just that operation on InnoDB.
#
# Assumptions: You have a ~/.my.cnf file in your home dir having user name and password with
# appropriate perissions. You can just just do this temporarily on your remote server.
#
# Test this on a clone of your server first to satisfy yourself with the results.
# Use at your own risk. 
#
# If converting from MyISAM to InnoDB for the first time, it is best to configure InnoDB settings *before*
# first creating InnoDB tables.

# Argument(s): database name(s)
# Usage: $0 database1 [database2 database3 ...]

set -xv

DATABASES="$@"
echo "Converting all tables in ${DATABASES}..."

for DATABASE in $DATABASES
do
	
	TABLES=`mysql --database=$DATABASE --skip-column-names --execute="SHOW TABLES;"`
	
	for TABLE in $TABLES
	do
		mysql --database=$DATABASE --execute="ALTER TABLE $TABLE ENGINE=InnoDB;"
	done
done
