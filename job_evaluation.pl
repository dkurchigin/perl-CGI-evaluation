#!/usr/bin/perl

use CGI qw/:standard/;
use utf8;
use DBI;
binmode(STDOUT,':utf8');

#print		
#           header(-charset=>'utf8'),           
#	   start_html('Simple Script'),
#           h1('Оценка работы отделов'),
#	   start_form,
#	   "Представьтесь: ",p,
#	   "Логин:",textfield('login'),p,
#	   "Пароль:",textfield('password'),p,
#	   submit('Войти'),"\n";
#          hr,"\n";

my $host = "localhost";
my $port = "3306";
my $user = "root";
my $sql_passwd = '2NB5n$0&XTEU';
my $db = "evaluation";

if (param) {
	my $login = param('login');
	my $passwd = param('passwd');

	if (checkUser($login, $passwd) == 1) {
		print redirect('http://192.168.8.5/voting/');
	} elsif (checkUser($login, $passwd) == -1) {
		print redirect('http://192.168.8.5/voting/invalid_password.html');
	} else {
		print redirect('http://192.168.8.5/voting/invalid_login.html');
	}
}     

sub checkUser {
	my $dbh = DBI->connect("DBI:mysql:$db:$host:$port",$user,$sql_passwd);          my $sth = $dbh->prepare("select * from users where (?)");
        my ($login, $passwd) = @_;
	$sth->execute($passwd);
	while (my $ref = $sth->fetchrow_arrayref) {
		if ($$ref[0] =~ /$login/) {
			if ($$ref[1] =~ /$passwd/) {
				return 1; 
			} else {
				return -1; 
			}
		} else {
			return 0; 
		}
	}
	my $rc = $sth->finish;
        $rc = $dbh->disconnect;	
}
