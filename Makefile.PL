use inc::Module::Install;

name 'Lingua-Translate-Wikipedia';
license 'perl';

test_requires 'Test::More';
test_requires 'File::Temp';
test_requires 'Cache::FileCache';

requires 'Web::Scraper';

WriteAll;
