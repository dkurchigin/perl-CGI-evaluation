#!/usr/bin/perl

use CGI qw/:standard/;
use DBI;

my $host = "localhost";
my $port = "3306";
my $user = "root";
my $sql_passwd = '2NB5n$0&XTEU';
my $db = "evaluation";
my $a = 0;

my $dbh = DBI->connect("DBI:mysql:$db:$host:$port",$user,$sql_passwd);
my $sth = $dbh->prepare("select SUM(d1) from results");
$sth->execute;
while (my $ref = $sth->fetchrow_arrayref) {
		print "DB $$ref[0] $$ref[1]\n";
		$a = $$ref[0];
}
my $rc = $sth->finish;
$rc = $dbh->disconnect;

print header(-charset=>'utf8'),
start_html('Результаты голосования'),
h1('Результаты голосования'),
hr;

print table({-border=>undef, -align=>'CENTER'},
caption('Лучший отдел'),
Tr({-align=>'CENTER',-valign=>'TOP'},
[
	th(['Название', 'Общий балл']),
	td(['Руководство' , "$a"]),
	td(['ОИО' , '1']),
	td(['ОХО'   , '1'])
]
)
);

