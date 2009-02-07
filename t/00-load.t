#!perl -T

use Test::More tests => 2;

BEGIN {
	use_ok( '' );
	use_ok( '::App' );
}

diag( "Testing  $::VERSION, Perl $], $^X" );
