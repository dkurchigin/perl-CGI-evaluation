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

if (param) {
	my $fio = param('fio');
	my $login = param('login');
	my $passwd = param('passwd');
	my $checkpasswd = param('checkpasswd');
	my $department = param('department');

	if ($passwd != $checkpasswd) {
		print redirect('http://192.168.8.5/registration/mismatch.html');	
	} elsif (checkUser($login)) {
		 print redirect('http://192.168.8.5/registration/already_created.html');	
	} else {
		addUser($login, $passwd, $department);
		print redirect('http://192.168.8.5/registration/success.html'); 
	}
}

sub checkUser {
	my $dbh = DBI->connect("DBI:mysql:$db:$host:$port",$user,$sql_passwd);
	my $sth = $dbh->prepare("select * from users");
	$sth->execute;

	while (my $ref = $sth->fetchrow_arrayref) {
		if ($$ref[0] =~ /@_/) {
			return 1;
		} else {
			return 0;
		}
	}

	my $rc = $sth->finish;
	$rc = $dbh->disconnect;
}

sub addUser {
	my $dbh = DBI->connect("DBI:mysql:$db:$host:$port",$user,$sql_passwd); 		my $sth = $dbh->prepare("insert into users (login, passwd, vote, department) value (?, ?, 'N', ?)");
        
	my ($login, $passwd, $department) = @_;
	$sth->execute($login, $passwd, $department);
        
	my $rc = $sth->finish;
        $rc = $dbh->disconnect;
}
