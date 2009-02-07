#!perl

use Test::More tests => 3;

BEGIN {
    use_ok (File::Temp);
    use File::Temp qw/tempfile/;
}

diag( "Testing environment" );
test_backticks();

sub test_backticks {
    
    my ($errortempfh, $error_temp_file_path) = tempfile();
    
    my $clear_string;           #Redirect STDERR to temp file:
    eval {$clear_string = `clear 2> $error_temp_file_path`};
    
    ok (length $clear_string > 5);#Make sure backticks returned something
    
    my $error_string = do { local( @ARGV, $/ ) = $error_temp_file_path ; <> } ;
    
    #Check eval:
    if ($@) {
        fail("System call with backticks failed for the following reason: $@");
    }
    #Fail if there is an error string, and it's more than a bunch of whitespace:
    elsif ($error_string and $error_string !~ /^\s*$/){
        fail("System call to `clear` function produced an error")
    }
    #Otherwise, pass:
    else {
        pass("Environment seems ok");
    }
}