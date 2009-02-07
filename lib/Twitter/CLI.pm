package Twitter::CLI;
use Moose;
with qw/
    MooseX::Object::Pluggable
    MooseX::Getopt       
/;
use Carp qw/croak/;
has +_USER_NAMES =>
(   is => 'ro',
    required => 1,
    isa => 'ArrayRef',
    default =>
        sub {   #Anything not preceded by - or -- is a username:
            my @user_names = grep {$_ !~ /^-+/} @ARGV;
            if (not @user_names){
                print  "Please provide the first letter or two of your Twitter "
                        ."username(s) as an argument (or space-separated arguments) "
                        ."to this script. Do not preface them with - or --.\n";
                exit;
            }
            return \@user_names;
        }
);
has _MAX_TWEET_LENGTH => (is => 'ro', isa => 'Int', default => 140);

=head1 NAME

 - A command-line Twitter interface with plugins, prompting, multiple account support, and more!

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

This is pre-alpha software! Do not use it!

=head1 PLUGINS

This module is limited in what it does, for a good reason:
It supports multiple command-line interfaces to Net::Twitter with plugins.
You plug a plugin into an interface. For example, this is an example of what the
twitter_cli script looks like:
    
    use Twitter::CLI::Interface::Default;
    
    my $CLI = Twitter::CLI::Interface::Default->new;
    
    foreach my $user (@{ $CLI->_USER_NAMES }){
        #Create a new user session for each user
        my $user_session = Twitter::CLI::Interface::Default::UserSession->new_with_options;
        
        #Set username 
        $user_session->_username( $user );#XXX: Need to get+verify the username from the config file
        
        #XXX: Get the password from the config file:
        # Not implemented yet...
        $user_session->_password( '$SOME_PASSWORD' );
        
        #Load a plugin with which to run this session
        $user_session->load_plugin('Prompting');#Loads ::Plugin::Prompting
        
        #Run the session with the plugin's run() subroutine
        $user_session->run;
    }
    
=head1 EXPORT

All plugins will inherit an array reference called _USER_NAMES. Access this
via $self->_USER_NAMES . A "user name" is anything specified on the command line
that does not contain a "-" or "--" at the beginning, i.e. a bareword.
For example:
    twitter_cli vividnuage -a --some_flag openprogramming --another_flag
    
In the example, vividnuage and openprogramming are the usernames

=head1 FUNCTIONS

None except a BEGIN block that greps through @ARGV, searching for
-h, --h, or --help, in which case a verbose help message is printed.

This is a MooseX::Object::Pluggable class. Plug in your plugins!

=cut

BEGIN {
    #Match -h, --h, or --help and interpret as "HELP!"
    if (grep {/^(-h|--h|--help)$/} @ARGV){
        `perl $0 --list_options_`;#This will generate an argv parsing error and list commands
        print while <DATA>;#Prints out the __DATA__ section at the end of this script
        print "\n";
        exit;
    }
}

=head1 AUTHOR

Seth Viebrock, C<< <sviebrock at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-net-twitter-cli at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Twitter-CLI>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc 


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Twitter-CLI>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Twitter-CLI>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Twitter-CLI>

=item * Search CPAN

L<http://search.cpan.org/dist/Twitter-CLI>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2009 Seth Viebrock, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # End of 