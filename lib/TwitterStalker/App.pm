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
# this causes 403
#my $res    = $nt->update({ status => "I CAN HAZ OAUTH!" });
# but this works SO BE CAREFUL
#$nt->update('Hello World!');

print "*******************\n";
# print "twitter_secret:      ", $ENV{'TWITTER_KEY'}, "<BR>", "\n";
# print "hello?:      ", $ENV{'LANG'}, "<BR>", "\n";
# print $consumer_key, "\n";

my $search_term = "featherart";
my @tweets = $nt->home_timeline;
my $r = $nt->search($search_term);
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
    # template 'index';
    template 'hello';
};


print "@++++++++++++++++@@@\n";
#get '/user/view/:username/' => sub {
# get '/hello/:name' => sub {
#         #return "Why, hello there " . params->{name};
#         my $name = params->{name};
#         print $name;
#         template 'hello' => { name => $name };
# };

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
print "@@@@@@@@@@@@@@@@@@@\n";
print "@++++++++++++++++@@@\n";

# post '/tweets' => sub {
#   my $form = form('search_tweets');
#   my $values = $form->values();
#   print "here's my form vals: \n";
#   print $values;

# };
print "@@@@@@@@@@@@@@@@@@@\n";
true;
