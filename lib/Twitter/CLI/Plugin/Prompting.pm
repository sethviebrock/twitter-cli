#!/usr/bin/perl -w
package Twitter::CLI::Plugin::Prompting;
use Moose::Role;
use File::Temp qw/ tempfile /;

#A la Higher Order Perl:
sub NEXTVAL { $_[0]->() }
sub Iterator (&) { return $_[0] }
sub filehandle_iterator {
    my $fh = shift;
    return Iterator { <$fh> }
}

#Main sub that we plug in:
sub run {
    my $self = shift;
    print "I'm a prompting plugin app!";
    $self->init_menu();
    $self->print_menu();
    
    #An iterator over STDIN, just like a <STDIN> while loop:
    my $iterator = filehandle_iterator(*STDIN);
    while (defined(my $line = NEXTVAL($iterator))){
        #Take off beginning whitespace of the current line:
        $line =~ s/^\s*//;
        chomp $line;
        
        #Add a space at the front of each tweet line unless we're at the beginning
        #of a tweet:
        if ($self->_tweet =~ /^\s*$/){
            $self->_tweet( $self->_tweet . $line );
        }
        else {
            $self->_tweet( $self->_tweet . " " . $line );
        }
        
        my $sub_ref = sub { _delete_chars($self) };
    
        #Set ctrl+c signal handler.
        $SIG{INT} = $sub_ref;
        
        $self->print_menu();
        
        if ($self->_tweet =~ /__VI__/){
            
            my ($fh, $filename) = tempfile();
            
            #Take the trigger out of the message:
            {   local $_ = $self->_tweet;
                s/__VI__\s?//smg;
                $self->_tweet( $_ );
            }
            
            print $fh $self->_tweet;
            close $fh;
            system "vi $filename";
            
            #Rewrite the msg with whatever vi saves:
            my $file = do { local( @ARGV, $/ ) = $filename ; <> };#Slurp in the file
            $self->_tweet($file);#Update tweet
            
            $self->print_menu();
        }
        elsif ($self->_tweet =~ /__EM__/){
            
            my ($fh, $filename) = tempfile();
            
            #Take the trigger out of the message:
            {   local $_ = $self->_tweet;
                s/__EM__\s?//smg;
                $self->_tweet( $_ );
            }
            
            print $fh $self->_tweet;
            close $fh;
            system "emacs $filename";
            
            #Rewrite the msg with whatever emacs saves:
            my $file = do { local( @ARGV, $/ ) = $filename ; <> };#Slurp in the file
            $self->_tweet($file);#Update tweet
            
            $self->print_menu();
        }
        elsif ($self->_tweet =~ /__MATE__/){
            my ($fh, $filename) = tempfile();
            
            #Take the trigger out of the message:
            {   local $_ = $self->_tweet;
                s/__MATE__\s?//smg;
                $self->_tweet( $_ );
            }
            
            print $fh $self->_tweet;
            close $fh;
            system "mate -w $filename";
            
            #Rewrite the msg with whatever vi saves:
            my $file = do { local( @ARGV, $/ ) = $filename ; <> };#Slurp in the file
            $self->_tweet($file);#Update tweet
            
            $self->print_menu();
        }
        
        #Update tweet length:
        $self->_current_tweet_length(
            length $self->_tweet
        );
        
        if ( $self->_current_tweet_length > $self->_MAX_TWEET_LENGTH){
            
            my $too_long_by = $self->_current_tweet_length - $self->_MAX_TWEET_LENGTH;
            $self->print_menu(
                color => "red",
                message => "Message too long by $too_long_by characters.\n" 
            );
        }
    }
}

sub _delete_chars {
    my $self = shift;
    
    #Update tweet length:
    $self->_current_tweet_length(
        length $self->_tweet
    );
    
    #Trim $self->_tweet by one char:
    $self->_tweet(
        substr $self->_tweet, 0, ($self->_current_tweet_length - 1)
    );
    
    my $sub_ref = sub { _delete_chars($self) };
    
    #Set ctrl+c signal handler.
    $SIG{INT} = $sub_ref;
    
    #Update tweet length:
    $self->_current_tweet_length(
        length $self->_tweet
    );
    
    #print  "*** Character deleted! ***\n";
    if ( $self->_current_tweet_length > $self->_MAX_TWEET_LENGTH){
        
        my $too_long_by = $self->_current_tweet_length - $self->_MAX_TWEET_LENGTH;
        
        $self->print_menu(
            color => "red",
            message => "Message too long by $too_long_by characters.\n" 
        );
    }
    else {
        $self->print_menu(
            color => "green",
            message => "Message is of acceptable length!\n" 
        );
    }
}


1;


