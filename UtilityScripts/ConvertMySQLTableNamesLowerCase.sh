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

# A simple (meaning zero validation of your usage) script to convert TABLE names to lowercase.
# To convert a **DATABASE** name to lower case, shut down mysql and rename the database directory name 
# in data dir, then simply restart mysql
# Useful if you plan to convert a system to lower_case_table_names = 1 option

# Assumptions: You have a ~/.my.cnf file in your home dir having user name and password with
# appropriate perissions. You can just just do this temporarily on your remote server.

# Test this on a clone of your server first to satisfy yourself with the results.
# Use at your own risk. 

# Argument: database name(s)
# Usage: $0 database1 [database2 database3 ...]

set -xv

DATABASES="$@"
echo $DATABASES

for DATABASE in $DATABASES
do
	
	TABLES=`mysql --database=$DATABASE --skip-column-names --execute="SHOW TABLES;"`
	
	for TABLE in $TABLES
	do
		LOWER_CASE_NAME=`echo $TABLE | tr "[:upper:]" "[:lower:]"`
		# We cannot just rename it since the uppercase and lowercase names will clash on a case insensitive file system
		# so we name to a temp name and then name to lowercase name
		TMP_NAME="_tmp_rename_"$LOWER_CASE_NAME
		mysql --database=$DATABASE --execute="RENAME TABLE $TABLE TO $TMP_NAME; RENAME TABLE $TMP_NAME TO $LOWER_CASE_NAME;"
	done
done
