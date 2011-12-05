Introduction
=================
The default mysql configuration out of the box is extremely conservative in its assumptions. 
Consequently default configuration performance is usually unacceptable on anything larger than 50MB database, and dismally unuseable on any decent size database.

The bottom line is, you MUST configure MySQL if you are going to use it for development and/or deployment. The problem is that MySQL has a plethora of configuration options, some of which are mission critical with a large impact on performance while others are practically insignificant.

This project aims to help developers find a quick start MySQL configuration that is better than the out of the box defaults.

So What's Here?
------------------------------
The MySQL configuration files are based on actual working configurations. Some have been tested extensively. Some have not. Some are donated by others. The files here, at least initially, are based on configurations where MySQL was run on Mac OS X and Linux platforms with InnoDB Transactional Engine as the default database engine, but that does not mean that these configurations cannot be used as is on other platforms with little, if any, changes. Also the files here are generally for MySQL 5 and above. Remember that most MySQL options are indifferent to the platform. Comments in the files will usually tell you if an option's usage and/or its values should take into consideration the host operating system.

Either way, using one of these config files is most likely a better choice than no config file and default configuration. Keep in mind that MySQL has example config files included too. Feel free to check those out.


Comparing Before and After
--------------------------
If you are going to change your MySQL configuration file and you want to clearly see what changed, it can be a good idea to save the result of a SHOW VARIABLES command in 'before' and 'after' text files and just use diff to compare.

So How Do I Pick a Configuration File?
======================================
1.   First decide the maximum amount of memory you are prepared to give to MySQL. Let's call this Available MySQL Memory. See the section below 'How Much Memory do I Need?'
    *   The Configurations directory has config files named as follows:
        *   `[M|G]NNN_[engine]_[mac/linux]_[version]_[comment].cnf`, where:
            *   The first letter denotes `M` for `Megabytes` and `G` for `Gigabytes`.
            *   `NNN` is the size in `Megabytes` or `Gigabytes`. Partial Gigabytes may
                 use the form `NNN.N`.
            *   `engine` value will be `innodb` or some other engine. This means the configuration 
                is intended for an installation where the specified engine is the primary Engine
                used for tables in this server.
            *   `mac` means the file was used on Mac OS X. `linux` means the file was used on Linux
            *   `version` will indicate the version of MySQL that the file was created for, 
                however, option files are usually forward compatible. If not, mysqld will not 
                started and the error log file will tell you exactly what option was invalid 
                or had a wrong value usually.
        *   For example:
            *   `M512_innodb_mac_5.1_my.cnf` = MySQL 5.1 using *about* 512MB of memory 
                on Mac OS X and primarily using innodb storage engine.
            *   `G038_innodb_linux_5.1_my.cnf` = MySQL 5.1 using *about* 38GB of memory 
                on Linux and primarily using innodb storage engine.
2.  Install the file and get to work.

Setup for New Installation
---------------------------
If you have not yet started MySQL for the first time, simply:

1.   name the chosen file 'my.cnf' and 
*   place it in the appropriate location, usually at /etc/my.cnf. 
*   Now go ahead and install and/or start MySQL for the first time.

Setup for Existing Installation
--------------------------------
If you have already been running mysql, use `SHOW VARIABLES` statement to check the value of `innodb_log_file_size`. Now check the value of that option in the config file that you have chosen.
If they are different, and they most likely are, then you must perform the following Data Log Reconfiguration procedure to update to the new settings **after** you have shut down mysql and **before** you have restarted it. Depending on your confidence level, now might be a good time to make a backup.

### Data Log Reconfiguration ###
Refer to [this article](http://dev.mysql.com/doc/refman/5.0/en/innodb-data-log-reconfiguration.html) if you like.
 
1.  Switch to root user on your machine
*   Navigate to mysql data dir
*   You will usually see 2 or more log files with names such as `ib_logfile0`, `ib_logfile1`, etc. Delete them...really.
    *   `$ rm ib_logfile*`
*   Start mysqld:
	*   `$ sudo echo`
	*   `$ sudo mysqld_safe &`
* If
	
How Much Memory do I Need?
--------------------------
If you are a developer, a good rule of thumb might be to dedicate 10% to 20% of your total memory to MySQL. However in reality it depends on your data sizes in your database(s). If you want to see the size of your data and indices for all tables in all databases in a running mysql server, just use a query like this:

    SELECT TABLE_SCHEMA, TABLE_NAME, TABLE_ROWS, 
        (DATA_LENGTH + INDEX_LENGTH)/1024/1024 as SIZE_IN_MB, 
        DATA_LENGTH/1024/1024 as DATA_SIZE_IN_MB, 
        INDEX_LENGTH/1024/1024 as INDEX_SIZE_IN_MB 
    FROM information_schema.TABLES 
    WHERE TABLE_SCHEMA NOT IN ('mysql','information_schema') order by SIZE_IN_MB desc;

Just get the sum of the size column there for a total. You might want to take this opportunity to clean out the cruft ;-)

The best performance scenario is a case where ALL data and indices fit into available memory. If you have too much data and not enough available memory for that, then just decide what the most memory is that you can afford to allocate in your current server or development machine.

LICENSE
=======
The MIT License (MIT)
Copyright (c) 2011 Green Island Consulting LLC

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.