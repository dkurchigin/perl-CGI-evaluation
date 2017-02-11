#!/usr/bin/perl

use CGI qw/:standard/;
use utf8;
use DBI;
binmode(STDOUT,':utf8');

my $host = "localhost";
my $port = "3306";
my $user = "root";
my $sql_passwd = '2NB5n$0&XTEU';
my $db = "evaluation";

my $dbh = DBI->connect("DBI:mysql:$db:$host:$port",$user,$sql_passwd);
my $sth = $dbh->prepare("select * from users"); 
$sth->execute; 

open(my $fh, '>>', '/home/pi/fcgi/testing');
while ( my $ref = $sth->fetchrow_arrayref) {
print $fh "$$ref[0]\t"; 
print $fh "$$ref[1]\t";  
print $fh "$$ref[3]\n"; 
} 
close $fh;

my $rc = $sth->finish;    
$rc = $dbh->disconnect;

if (param) {
	my $fio = param('fio');
	my $login = param('login');
	my $passwd = param('passwd');
	my $checkpasswd = param('checkpasswd');
	my $department = param('department');
	if ($passwd != $checkpasswd) {
	print redirect('http://192.168.8.5/registration/mismatch.html');	
	} else {
		open(my $fh, '>>', '/home/pi/fcgi/testing');
		print $fh "$fio $login $passwd $checkpasswd $department \n";
		print redirect('http://192.168.8.5/registration/success.html');
	}	 
}
