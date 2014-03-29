package MyWeb::App;
use Dancer ':syntax';
use Net::Twitter::Lite::WithAPIv1_1;
use Scalar::Util 'blessed';
use Data::Dumper;
use Template;
use Array::Utils qw(:all);
#use List::Compare;
use List::MoreUtils qw(zip);

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

print "*********r**********\n";
# my @arr1 = $nt->friends_list({ screen_name => 'featherart' });
# my @arr2 = $nt->friends_list({ screen_name => 'hansflorine' });
my @arr1 = $nt->friends_list({ screen_name => 'featherart' });
my @arr2 = $nt->friends_list({ screen_name => 'pamelafox' });

# at this point it's still correctly formatted
# according to data dumper, but causes runtime error  
my @merged = zip(@arr1, @arr2); 
#my @unique = keys { map { $_ => 1 } @merged };

# this gives the right result set
# but no longer good format & causes runtime error
my @unique = eval { unique(@merged) };

# this did not work AT ALL
# my $lc = List::Compare->new( \@arr1, \@arr2 );
# my @intersection = $lc->get_intersection;


# print "@++++++unique++++++++++@@@\n";
print Dumper(\@unique);
# print "@++++++++++++++++@@@\n";
# my $lc = List::Compare->new( {
#         lists    => [\@r, \@s],
#         unsorted => 1,
#     } );
# my @intersection = $lc->get_intersection;
# print "\@instersection: @intersection\n";
# intersection, nope
# my @i = intersect(@r, @s);
# print scalar @i;
# print @i;

# for my $el (@i) {
#   print $el . "\n";
# };
print "@++++++++++++++++@@@\n";

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
  
  my @res1 = $nt->friends_list({ screen_name => $name1 });
  my @res2 = $nt->friends_list({ screen_name => $name2 });
  
  # derp! This returns the correct result set
  # but I get a weird runtime error that no one on Stack Overflow has seen
  # Just not sure at all what to do next ...
  # my @all = zip(@res1, @res2);
  # my @uniq = eval { unique(@all) };

  # my @unique = do { my %seen; grep { !$seen{$_}++ } @all };

  set template => 'template_toolkit';

  template 'user_results' => {
      name1 => $name1,
      name2 => $name2,
      response1 => @res1,
      response2 => @res2
  };
};

# to test out routes & params passing
get '/hello/:name' => sub {
  my $name = params->{name};

  template 'hello' => {
      name => $name,
  };
};

true;
