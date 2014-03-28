package MyWeb::App;
use Dancer ':syntax';
use Net::Twitter::Lite::WithAPIv1_1;
use Scalar::Util 'blessed';
use Data::Dumper;

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
# my $doh = $nt->lookup_users({ screen_name => 'featherart,hansflorine' });
# #only prints the users we have in common
# print Dumper $doh;

# this might be a way to at least look at the hash!
# $Data::Dumper::Sortkeys = \&my_filter;
# my $foo = { map { (ord, "$_$_$_") } 'I'..'Q' };
# my $bar = { %$foo };
# my $baz = { reverse %$foo };
# print Dumper [ $foo, $bar, $baz ];


#   print Dumper $r;
#my %friends = $nt->friends;
#print $nt;
# print @tweets[0];
# print "\n";
#print %friends[0];
#print "$tweets[0]\n";
#print $res;

print "@@@@@@@@@@@@@@@@@@@\n";
get '/' => sub {
    # default welcome page
    template 'hello';
};

get '/find_tweets/:name' => sub {
  # nope
  # my $form = form('find_tweets');
  my $name = params->{name};
  my $response = $nt->search($name);

  # Dancer adds .tt automatically, but this is configurable
  template 'find_tweets' => {
      name => $name,
      response => $response
  };
};

get '/user_results/:name1&:name2' => sub {
  my $name1 = params->{name1};
  my $name2 = params->{name2};
  my $response = $nt->lookup_users({ screen_name => $name1,$name2 });

  # Dancer adds .tt automatically, but this is configurable
  template 'user_results' => {
      name1 => $name1,
      name2 => $name2,
      response => $response
  };
};

print "@++++++++++++++++@@@\n";
# to test out routes & params passing
get '/hello/:name' => sub {
  my $name = params->{name};

  # Dancer adds .tt automatically, but this is configurable
  template 'hello' => {
      name => $name,
  };
};

# get '/tweets' => sub {
#   my $form = form('search_tweets');
#   print "here's my form: \n";
#   print $form;
# };
# print "@++++++++++++++++@@@\n";
# post '/tweets' => sub {
#   my $form = form('search_tweets');
#   my $values = $form->values();
#   print "here's my form vals: \n";
#   print $values;
# };

print "@@@@@@@@@@@@@@@@@@@\n";
true;
