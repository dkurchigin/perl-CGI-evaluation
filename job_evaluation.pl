#!/usr/bin/perl

use CGI qw/:standard/;
use utf8;
#use open ':locale:';
binmode(STDOUT,':utf8');

my $signin = 0;

print		
           header(-charset=>'utf8'),           
	   start_html('Simple Script'),
           h1('Оценка работы отделов'),
	   start_form,
	   "Представьтесь: ",p,
	   "Логин:",textfield('login'),p,
	   "Пароль:",textfield('password'),p,
	   submit('Войти'),"\n";
           hr,"\n";

if (param) {
           print 
           "Your name is ",em(param('login')),p,
           "Your favorite color is ",em(param('color')),".\n";
           open(my $fh, '>>', '/home/pi/fcgi/testing');
           my $name = param('login');

           my $last_name = param('last_name');
           my $first_name = param('first_name');
           my $patronymic = param('patronymic');
           my $post = param('post');
           my $id_card = param('id_card');
           my $reader_id = param('reader_id');
           my $datetime = localtime();

           print $fh "$datetime from $reader_id : $name | $first_name | $patronymic | $post | $id_card \n";
           close $fh;
        }
        print end_html;

