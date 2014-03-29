package MyWeb::App;
use Dancer ':syntax';
use Net::Twitter::Lite::WithAPIv1_1;
use Scalar::Util 'blessed';
use Data::Dumper;
use Template;
use Array::Utils qw(:all);

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
#my $doh = $nt->friends_list({ screen_name => 'featherart' });
# my $doh = $nt->lookup_users({ screen_name => $name });
#my $doh = $nt->lookup_users({ screen_name => 'featherart' });
#print Dumper $doh;
   
get '/' => sub {
    # default welcome page
    template 'hello';
};

post '/find_tweets' => sub {

  my $name = params->{name}; 
  my @r = eval { $nt->user_timeline({ screen_name => $name }) };

  set template => 'template_toolkit';
  
  template 'find_tweets' => {
      name => $name,
      response => @r
  };
};

# still need to get query right
post '/user_results' => sub {
  my $name1 = params->{name1};
  my $name2 = params->{name2};
  
  # this just looks them up
  #my @r = eval { $nt->lookup_users({ screen_name => $name1. ", ".$name2 }) };
  # these just break everything
  #my @r= eval { $nt->follows($name1, $name2) };
  #my $r = $nt->show_relationship($name1, $name2);
  #my $r = $nt->show_relationship(); 
  # this works but will require a 2nd query :(
  my @r = eval { $nt->friends_list({ screen_name => $name1 }) };
  my @s = eval { $nt->friends_list({ screen_name => $name2 }) };

  # intersection
  my @i = intersect(@r, @s);

  set template => 'template_toolkit';

  template 'user_results' => {
      name1 => $name1,
      name2 => $name2,
      response => @i
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
