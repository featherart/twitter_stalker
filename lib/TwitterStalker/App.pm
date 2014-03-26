package TwitterStalker::App;
use Dancer ':syntax';

our $VERSION = '0.1';

get '/' => sub {
    template 'index';
};

get '/hello' => sub {
    template 'hello';
};

true;
