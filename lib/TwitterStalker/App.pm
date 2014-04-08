package MyWeb::App;
use Dancer ':syntax';
use Net::Twitter::Lite::WithAPIv1_1;
use Scalar::Util 'blessed';
use Data::Dumper;
use Template;
use Array::Utils qw(:all);
#use List::Compare;
use List::MoreUtils qw(zip);
#use JSON;
use warnings;


our $VERSION = '0.1';
my $consumer_key = $ENV{'TWITTER_KEY'};
my $consumer_secret = $ENV{'TWITTER_SECRET'};
my $access_token = $ENV{'TWITTER_TOKEN'};
my $access_token_secret = $ENV{'TWITTER_TOKEN_SECRET'};


my $nt = Net::Twitter::Lite::WithAPIv1_1->new(
      consumer_key        => $consumer_key,
      consumer_secret     => $consumer_secret,
      access_token        => $access_token,
      access_token_secret => $access_token_secret,
      ssl                 => 1,
);
#==========================================
# test zone 
#my $hr = $nt->friends_list({ screen_name => "featherart" });

# pretty prints hashref
#print Dumper \$hr; 

# this lists keys, one of which is users
# foreach my $k (keys %$hr) {
#   print "$k\n";
# }

# this gives me an array
#print $$hr{users}, "\n";

# so why not try this?
# oh b/c it says Not a SCALAR reference
#print $$$hr{screen_name}, "\n";
#==========================================
get '/' => sub {
    # default welcome page
    template 'hello';
};

post '/find_tweets' => sub {

  my $name = params->{name}; 
  my $r = $nt->user_timeline({ screen_name => $name });

  set template => 'template_toolkit';
  
  template 'find_tweets' => {
      name => $name,
      response => $r
  };
};

post '/user_results' => sub {
  my $name1 = params->{name1};
  my $name2 = params->{name2};
  
  my $res1 = $nt->friends_list({ screen_name => $name1 });
  my $res2 = $nt->friends_list({ screen_name => $name2 });
  
  set template => 'template_toolkit';

  # not sending the right thing, just shows *all the results
  # not able to get the intersection to work
  template 'user_results' => {
      name1 => $name1,
      name2 => $name2,
      response1 => $res1,
      response2 => $res2
  };
};

true;
