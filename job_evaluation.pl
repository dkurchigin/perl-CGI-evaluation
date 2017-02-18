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

	checkUser($login, $passwd);
}     

sub checkUser {
	my $dbh = DBI->connect("DBI:mysql:$db:$host:$port",$user,$sql_passwd);
	my ($login, $passwd) = @_;
	my $sth = $dbh->prepare("select * from users where login = (?)");
	$sth->execute($login);

	open(fh, ">> /home/pi/fcgi/testing");
	print fh "Q $login $passwd\n";
	my $access = 0;
	
	while (my $ref = $sth->fetchrow_arrayref) {
		print fh "DB $$ref[0] $$ref[1]\n";
		if ($$ref[0] =~ /$login/) {
			if ($$ref[1] =~ /^$passwd$/) {
				$access = 1; 
			} else {
				$access = -1; 
			}
		} else {
			$access = 0; 
		}
	}
	my $rc = $sth->finish;
        $rc = $dbh->disconnect;	
	close fh;
	if ($access == 1) {
		print redirect('http://imsonerd.no-ip.biz/voting/');	
	} elsif ($access == -1) {
		print redirect('http://imsonerd.no-ip.biz/voting/invalid_password.html');
	} else {
		print redirect('http://imsonerd.no-ip.biz/voting/invalid_login.html');
	}
}
