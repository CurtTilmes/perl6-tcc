use TCC;

my $tcc = TCC.new;

sub add(int32 $a, int32 $b --> int32)
{
    return $a + $b;
}

$tcc.compile:
'
    #include <stdio.h>
    int add(int a, int b);
    int fib(int n)
    {
        if (n <= 2)
            return 1;
        else
            return fib(n-1) + fib(n-2);
    }

    int foo(int n)
    {
        printf("Hello World!\n");
        printf("fib(%d) = %d\n", n, fib(n));
        printf("add(%d, %d) = %d\n", n, 2 * n, add(n, 2 * n));
        return 0;
    }
';

$tcc.add-symbol(&add);

my &fib = $tcc.bind('fib', :(int32 --> int32));
my &foo = $tcc.bind('foo', :(int32 --> int32));

say foo(32);
