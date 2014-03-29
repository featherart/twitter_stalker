package MyWeb::App;
use Dancer ':syntax';
use Net::Twitter::Lite::WithAPIv1_1;
use Scalar::Util 'blessed';
use Data::Dumper;
use Template;

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

# this works SO BE CAREFUL!
#$nt->update('Hello World!');

print "*******************\n";
#my $doh = $nt->lookup_users({ screen_name => 'featherart,hansflorine' });
#my $doh = $nt->list_statuses(screen_name =>'featherart');
#print Dumper $doh;
   
get '/' => sub {
    # default welcome page
    template 'hello';
};

post '/find_tweets' => sub {

  my $name = params->{name}; 
  #my @r = eval { $nt->search($name) };
  #my @r = eval { $nt->lookup_users({ screen_name => $name }) };
  my @r = eval { $nt->user_timeline({ screen_name => $name }) };

  print scalar @r;
  set template => 'template_toolkit';
  
  template 'find_tweets' => {
      name => $name,
      response => @r
    };
};

# still need to get template fixed
post '/user_results' => sub {
  my $name1 = params->{name1};
  my $name2 = params->{name2};
  
  #my @r = eval { $nt->lookup_users({ screen_name => $name1. ", ".$name2 }) };
  #my @r= eval { $nt->follows($name1, $name2) };
  my $r = $nt->show_relationship($name1, $name2);
  set template => 'template_toolkit';

  template 'user_results' => {
      name1 => $name1,
      name2 => $name2,
      response => $r
  };
};

print "@++++++++++++++++@@@\n";
# to test out routes & params passing
get '/hello/:name' => sub {
  my $name = params->{name};

  template 'hello' => {
      name => $name,
  };
};

print "@@@@@@@@@@@@@@@@@@@\n";
true;
