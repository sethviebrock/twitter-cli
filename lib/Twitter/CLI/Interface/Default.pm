package Twitter::CLI::Interface::Default;
=head1 NAME

 - The great new !

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';
use Moose; with qw/
    MooseX::Getopt
    MooseX::Object::Pluggable
/;
extends 'Twitter::CLI';

use Carp;
use Net::Twitter;
use Term::ANSIColor;
use Term::ReadKey;

has _clear_string => (is => 'ro', default => sub {`clear`});
has _tweet_prompt => (is => 'ro', isa => 'Str', default => 'tweet> ');
has _basic_commands => (is => 'ro', default => sub {
    my $heredoc =
<<COMMANDS;
 ctrl+d to post
 ctrl+c to delete
 ctrl+z to exit
COMMANDS
    if ($^O =~ /(win32|windows|dos)$/i){#Different control keys for EOF on Windows:
        $heredoc =~ s/ctrl\+d/ctrl+z/;#ctrl+z is EOF on Windoze
        $heredoc =~ s/ctrl\+z/ctrl+???/;#XXX: figure out what ctrl+z is in 'doze
    }
    return $heredoc;
});
has _basic_menu => (is => 'rw', isa => 'Str');

sub init_menu {
    my $self = shift;
    my $basic_menu =
        $self->_clear_string
        ."^" x 80 . "\n"
        ."Welcome, " . color("blue") . $self->_username . color("reset") . "\n"
        ."Please type your message below.\n\n"
        .$self->_basic_commands . "\n"
    ;
    $self->_basic_menu($basic_menu);#Set!
}

sub print_menu {
    my $self = shift;
    my %args = @_;
    my $color;
    my $message;
    if (exists($args{message})){
        $color = delete $args{color} if exists $args{color};
        $message = delete $args{message};
    }
    else {
        $message = "\n";#new line if no message passed
    }
    
    #Die if there are still keys in %args:
    if (keys %args){
        my @args = keys %args;
        die "Incorrect args \"@args\" passed to menu function";
    }
    
    print $self->_basic_menu;
    if ($color){
        print color($color) . $message . color("reset");
    }
    else {
        print $message;
    }
    
    print "-" x 80 . "\n"
        .$self->_tweet_prompt
    ;
    print $self->_tweet."\n";
    print "-" x 80 . "\n\n";
}

=head1 SYNOPSIS

Please refer to the twitter_cli documentation

=head1 IMPORT

This module imports ::Prompting by default, then it will
import any other plugins provided to it.

=head1 FUNCTIONS

=head2 menu

Prints out a terminal screenful of menu text

=cut

sub run {
    die "You are trying to call run() from ".__PACKAGE__.". "
    ."Please define your run() function in a plugin, "
    ."or load an appropriate plugin with a run() function."
}

######################################
package Twitter::CLI::Interface::Default::UserSession;
use Moose;
extends 'Twitter::CLI::Interface::Default';

has _tweet => (is => 'rw', isa => 'Str', default => '');#Init as empty string
has _username => (is => 'rw', isa => 'Str');
has _password => (is => 'rw', isa => 'Str');
has _current_tweet_length => (is => 'rw', isa => 'Int', default => 0);#Init as empty string

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
