Project Euler ����һҳ
========================

�� Julia_ �� `Project Euler`_ �ϵ���Ŀ��ֱ�����׻��� ...

1
---

�ҳ� 1000 ���� 3 �� 5 �ı����ĺ�

���ý��� - -

.. code:: julia

    println(sum(filter(i->i%3==0 || i%5==0, [3:999])))


2
---

쳲��������е�ż�����

���ǲ��ý��� - -

.. code:: julia

    a = 1
    b = 2
    sum = 2
    while true
        c = a+b
        if c>4000000 then
            break
        end
        if c%2 == 0 then
            sum = sum + c
        end
        a = b
        b = c
    end

    println(sum)


3
---

600851475143 �������������

���� julia ��ôһ�� IMBA ������ ���� ���ǲ��ý���

.. code:: julia

    v = 600851475143
    println(maximum([f[1] for f in factor(v)]))

4
---

�ҳ���λ�������ɵ���������

��Ȼ���ý���

.. code:: julia

    isPalindrome(s::String) =
        if length(s)>2 
            s[1]==s[end] && isPalindrome(s[2:end-1])
        else
            s[1] == s[end]
        end
    isPalindrome(i::Int) = isPalindrome(string(i))
    println(maximum(filter(isPalindrome, [a*b for a in 100:999, b in 100:999])))

5
---

1 .. 20 ����С������

.. code:: julia

    println(lcm([1:20]...))

6
---

1 .. 100 �͵�ƽ����ƽ���͵Ĳ�

.. code:: julia

    println(sum([1:100])^2 - sum(map(x->x^2, [1:100])))

7
---

�� 10001 ��������ʲô��

.. code:: julia

    println(primes(500000)[10001])

8
---

����һ���������ҵ�����������������ֵĻ� ����

.. code:: julia

    s = replace(
    "
    73167176531330624919225119674426574742355349194934
    96983520312774506326239578318016984801869478851843
    85861560789112949495459501737958331952853208805511
    12540698747158523863050715693290963295227443043557
    66896648950445244523161731856403098711121722383113
    62229893423380308135336276614282806444486645238749
    30358907296290491560440772390713810515859307960866
    70172427121883998797908792274921901699720888093776
    65727333001053367881220235421809751254540594752243
    52584907711670556013604839586446706324415722155397
    53697817977846174064955149290862569321978468622482
    83972241375657056057490261407972968652414535100474
    82166370484403199890008895243450658541227588666881
    16427171479924442928230863465674813919123162824586
    17866458359124566529476545682848912883142607690042
    24219022671055626321111109370544217506941658960408
    07198403850962455444362981230987879927244284909188
    84580156166097919133875499200524063689912560717606
    05886116467109405077541002256983155200055935729725
    71636269561882670428252483600823257530420752963450
    "
    , r"\s", "")

    v = 0
    for i in 5:length(s)
        v = max( v, reduce((x, c)->x*(c-'0'), 1, s[i-4:i]) )
    end

    println(v)

9
---

�ҵ����� :math:`a^2 + b^2 = c^2` �� :math:`a + b + c = 1000` �� :math:`a, b, c`

.. code:: julia

    for a in [1:999]
        for b in [a:999]
            if a+b > 1000
                continue
            end
            for c in [b:999]
                s = a + b + c
                if s > 1000
                    break
                end
                if a^2 + b^2 == c^2 && a + b + c == 1000
                    println("$a * $b * $c = $(a*b*c)")
                    exit(0)
                end
            end
        end
    end

10
---

�� 2000000 ���µ������ĺ�

.. code:: julia

    println(sum(primes(2000000-1)))

11
---

��һ����������ĳһ�����������ĸ��������˻�

.. code:: julia

    m = [
    08 02 22 97 38 15 00 40 00 75 04 05 07 78 52 12 50 77 91 08
    49 49 99 40 17 81 18 57 60 87 17 40 98 43 69 48 04 56 62 00
    81 49 31 73 55 79 14 29 93 71 40 67 53 88 30 03 49 13 36 65
    52 70 95 23 04 60 11 42 69 24 68 56 01 32 56 71 37 02 36 91
    22 31 16 71 51 67 63 89 41 92 36 54 22 40 40 28 66 33 13 80
    24 47 32 60 99 03 45 02 44 75 33 53 78 36 84 20 35 17 12 50
    32 98 81 28 64 23 67 10 26 38 40 67 59 54 70 66 18 38 64 70
    67 26 20 68 02 62 12 20 95 63 94 39 63 08 40 91 66 49 94 21
    24 55 58 05 66 73 99 26 97 17 78 78 96 83 14 88 34 89 63 72
    21 36 23 09 75 00 76 44 20 45 35 14 00 61 33 97 34 31 33 95
    78 17 53 28 22 75 31 67 15 94 03 80 04 62 16 14 09 53 56 92
    16 39 05 42 96 35 31 47 55 58 88 24 00 17 54 24 36 29 85 57
    86 56 00 48 35 71 89 07 05 44 44 37 44 60 21 58 51 54 17 58
    19 80 81 68 05 94 47 69 28 73 92 13 86 52 17 77 04 89 55 40
    04 52 08 83 97 35 99 16 07 97 57 32 16 26 26 79 33 27 98 66
    88 36 68 87 57 62 20 72 03 46 33 67 46 55 12 32 63 93 53 69
    04 42 16 73 38 25 39 11 24 94 72 18 08 46 29 32 40 62 76 36
    20 69 36 41 72 30 23 88 34 62 99 69 82 67 59 85 74 04 36 16
    20 73 35 29 78 31 90 01 74 31 49 71 48 86 81 16 23 57 05 54
    01 70 54 71 83 51 54 69 16 92 33 48 61 43 52 01 89 19 67 48
    ]
    d = 20 # dimension

    v = 0
    for r in [4:d]
        for c in [4:d]
            v = max(v,
                prod(m[r , c-3:c]),
                prod(m[r-3:r , c]),
                m[r , c] * m[r-1 , c-1] * m[r-2 , c-2] * m[r-3 , c-3],
                m[r , c-3] * m[r-1 , c-2] * m[r-2 , c-1] * m[r-3 , c]
            )
        end
    end
    println(v)

12
---

������������ // ������������Ϸ�ʽ����

��������һ�� ``reduce((a, f)->a * (f[2]+1), 1, factor(t))``

``factor(x)`` ���� ``x`` ����������������б�

.. code:: julia

    t = 0
    for i in 1:100000
        t = t+i
        if reduce((a, f)->a * (f[2]+1), 1, factor(t))>500
            println(t)
            break
        end
    end

13
---

��һ�������ĺ�

.. code:: julia

    nums = map(BigInt,[
    "37107287533902102798797998220837590246510135740250"
    ...
    "53503534226472524250874054075591789781264330331690"
    ])
    s = string(sum(nums))
    println(s[1:10])

14
---

��ʹ�� 3n+1 ����������

���������� DP ���� ���� ������Ȼֱ����ʱ��Ҳ�ܽ��� ���� �ǾͲ�����

.. code:: julia

    function chainlen(n)
        function f(x)
            if x%2 == 0
                return x/2
            else
                return 3x + 1
            end
        end

        l = 0
        while true
            l = l+1
            if n==1
                break
            end
            n = f(n)
        end
        return l
    end

    n, l = 1, 1
    for i in 3:1000000-1
        cl = chainlen(i)
        if cl>l
            n, l = i, cl
        end
    end

    println(n)

15
---

���� 20x20 �ĸ����ϴ�һ�����ߵ��Խǲ��߻�ͷ·��·������

��һ�� n �п�ʼ���� n �� n �е�����ͺ���ȷ��

��Ҫ������� 20x20 �ĸ����� 21x21 ���� - -|||

.. code:: julia

    row = [1 for i in 1:21]
    nextrow = [1 for i in 1:21]

    for i in 1:20
        for j in 2:21
            nextrow[j] = nextrow[j-1] + row[j]
        end
        row, nextrow = nextrow, row
        # println(row)
    end

    println( row[21] )

16
---

�� :math:`2^1000` ��ÿλ���ֵĺ�

.. code:: julia

    println(reduce((a,c)->a+(c-'0'), 0, string(BigInt(2)^1000)))

17
---

����Ӣ��д�� 1 .. 1000 ÿһ�����֣�һ���ж��ٸ���ĸ

.. code:: julia

    dic = [
    1=>"one",
    2=>"two",
    3=>"three",
    4=>"four",
    5=>"five",
    6=>"six",
    7=>"seven",
    8=>"eight",
    9=>"nine",
    10=>"ten",
    11=>"eleven",
    12=>"twelve",
    13=>"thirteen",
    14=>"fourteen",
    15=>"fifteen",
    16=>"sixteen",
    17=>"seventeen",
    18=>"eighteen",
    19=>"nineteen",
    20=>"twenty",
    30=>"thirty",
    40=>"forty",
    50=>"fifty",
    60=>"sixty",
    70=>"seventy",
    80=>"eighty",
    90=>"ninety",
    100=>"hundred",
    1000=>"thousand",
    ]

    +(s1::String, s2::String) = "$s1$s2"

    function toeng(n)
        assert(n>0 && n<=1000)
        if n<=20
            return dic[n]
        end
        if n == 1000
            return "one thousand"
        end

        a = int(floor(n/100))
        b = int(floor((n-a*100)/10))
        c = int(floor((n-a*100-b*10)))

        en = ""
        if a > 0
            en = dic[a] + " " + dic[100]
            if b > 0 || c > 0
                en = en + " and "
            end
        end
        
        if b == 1 || b == 0 && c > 0
            en = en + dic[b*10+c]
        elseif b > 1
            en = en + dic[b*10]
            if c > 0
                en = en + "-" + dic[c]
            end
        elseif c>0
            en = en + dic[c]
        end
        return en
    end

    # println(toeng(342))
    n = 0
    for i in 1:1000
        n = reduce( (n, c)->if c>='a' && c<='z' n+1 else n end, n, toeng(i) )
    end
    println(n)

18
---

������������ζ����ߵ��ף�·����ÿһλ����������ܵõ������ֵ

�ӵײ����ϵ��ƾͺ���

.. code:: julia

    m = [
    75 00 00 00 00 00 00 00 00 00 00 00 00 00 00
    95 64 00 00 00 00 00 00 00 00 00 00 00 00 00
    17 47 82 00 00 00 00 00 00 00 00 00 00 00 00
    18 35 87 10 00 00 00 00 00 00 00 00 00 00 00
    20 04 82 47 65 00 00 00 00 00 00 00 00 00 00
    19 01 23 75 03 34 00 00 00 00 00 00 00 00 00
    88 02 77 73 07 63 67 00 00 00 00 00 00 00 00
    99 65 04 28 06 16 70 92 00 00 00 00 00 00 00
    41 41 26 56 83 40 80 70 33 00 00 00 00 00 00
    41 48 72 33 47 32 37 16 94 29 00 00 00 00 00
    53 71 44 65 25 43 91 52 97 51 14 00 00 00 00
    70 11 33 28 77 73 17 78 39 68 17 57 00 00 00
    91 71 52 38 17 14 91 43 58 50 27 29 48 00 00
    63 66 04 68 89 53 67 30 73 16 69 87 40 31 00 
    04 62 98 27 23 09 70 98 73 93 38 53 60 04 23
    ]

    for i in 14:-1:1
        for j in 1:i
            m[i,j] += max(m[i+1, j], m[i+1, j+1])
        end
    end

    println(m[1, 1])

19
---

�� 1901��1��1�� �� 2000��12��30�� ֮���м��������������³���

�����أ�Pkg.add("Datetime") // ����������׺���

.. code:: julia

    using Datetime
    println(length(filter(d->dayofweek(d)==0, date(1901,1,1):months(1):date(2000,12,31))))

20
---

�� 200! ��ÿλ����֮��

.. code:: julia

    println(sum(map(c->c-'0', collect(string(factorial(BigInt(100)))))))

21
---

�� 1000 �������� ``a`` �������������������� ``b`` �� ``b`` �������������������� ``a`` �� ``a``\ ��\ ``b`` ֮��

.. code:: julia

    function factors(x)
        f = [1]
        for (p,n) in factor(x)
            f = reduce( vcat, f,
                [f * p^i for i in 1:n] )
        end
        return f
    end

    d(n) = sum(factors(n)) - n

    s = 0
    for i in 1:9999
        v = d(i)
        if 0<v<=9999 && i!=v && i==d(v)
            s += i # v will be calculated later
        end
    end

    println(s)

22
---

��һ�������б�����(ÿ�����ֵ�(��ĸ��֮��)��(�����б��е��ֵ���)�Ļ�)�ĺ�

.. code:: julia

    names=[ "MARY", ... ,"ALONSO"]
    sort!(names)

    av(str) = sum(map(c->c-'A'+1, collect(str)))

    assert(names[938]=="COLIN")

    s = BigInt(0)
    for i in 1:length(names)
        s += i * av(names[i])
    end
    println(s)

23
---

������(����������(����֮�ʹ��ڱ�������)֮�ͱ�ʾ������)�ĺ�

.. code:: julia

    function factors(x)
        f = [1]
        for (p,n) in factor(x)
            f = reduce( vcat, f,
                [f * p^i for i in 1:n] )
        end
        return f
    end

    d(n) = sum(factors(n)) - n

    isabundant = [false for i in 1:28123]
    for i in 1:28123
        if d(i)>i
            isabundant[i] = true
        end
    end

    s = 1
    for i=2:28123
        b = false
        for j=1:int(ceil(i/2))
            if isabundant[j] && isabundant[i-j]
                b = true
                break
            end
        end
        if !b
            s += i
        end
    end
    println(s)

24
---

�� 0 .. 9 ������������ֵ���ĵ� 1000000 λ��ʲô

.. code:: julia

    ps = [p for p in permutations([0:9])]
    println(ps[1000000])

25
---

��쳲��������д���һλ��ʼ���� 1000 λ����

.. code:: julia

    a = BigInt(1)
    b = BigInt(1)
    c = BigInt(0)
    i = 3

    T = BigInt(10)^999
    while true
        c = a+b
        if c>=T
            break
        end
        a = b
        b = c
        i += 1
    end

    println(i)

26
---

���� [2..1000) ������ʹ 1/d ��ѭ������� d

.. code:: julia

    function recurringCycleLen(n) # length of recurrying cycle of 1/n
        R = Int[] # all occured remainders
        r = 1
        c = 0;
        len = 0;
        while r>0 && !in(r,R)
            c = int(floor(r/n))
            if n<r
                push!(R, r)
                r -= c * n
            end
            r *= 10
        end
        if r==0
            return 0
        end
        return length(R)-findfirst(R,r)+1
    end

    maxn = 0
    maxl = 0
    for i in 1:1000
        l = recurringCycleLen(i)
        if l>maxl
            maxn = i
            maxl = l
        end
    end
    println(maxn)

27
---

��ʹ�� :math:`\forall i \in [0,N] \ i^2 + a*i + b Ϊ����` �е� N ȡֵ���� :math:`a, b` �ĳ˻���
���� :math:`|a| < 1000` �� :math:`|b| < 1000`

.. code:: julia

    maxlen = 0
    maxa = 0
    maxb = 0

    for a = -1000:1000
        for b = -1000:1000
            len = 0
            n = 0
            while isprime(n^2 + a*n + b)
                len+=1
                n+=1
            end
            if len>maxlen
                maxlen = len
                maxa = a
                maxb = b
            end
        end
    end

    println("a = $maxa, b = $maxb, maxlen = $maxlen, a*b=$(maxa*maxb)")

28
---

�����������Խ����ϵ�ֵ�ĺ�

.. code:: julia

    c = 1 # current
    s = 1 # sum
    step = 2
    for i in 1:500
        for j in 1:4
            c += step
            s += c
        end
        step += 2
    end

    println(s)

29
---

����� :math:`2 \leq a \leq 100` �� :math:`2 \leq b \leq 100`,
:math:`a^b` һ���ж��ٸ����ظ���ֵ

�κ�һ�����ǵ��˶�Ӧ����� :math:`99 \times 99` Ȼ���ȥ�ظ��� ���� Ȼ����ʵֱ����Ҳͦ��ģ������� ����

.. code:: julia

    li = ["4"=>1]
    for i = 2:100
        for j = 2:100
            li[string(BigInt(i)^j)] = 1
        end
    end
    println(length(li))

30
---

�����п���������ÿλ���ֵ���η���ӱ�ʾ������

��Ҫ˼��������ֻ�� ���� �����Ƕ��٣�

�����ǰ�һ������ 0 �� n λ���ֱ�ʾΪ :math:`\sum_{i=1}^{n}d_i \times 10^{n-i}`,
���� :math:`d_i` ��ʾ��� i λ�����֣���ô���ѿ�����
ÿλ���ֵ���η���ӵ�ֵ���� :math:`1 \leq \sum_{i=1}^{n}{d_i}^5 \leq 9^5 \times n`, 
����������ֵ������ :math:`10^{n-1} \leq \sum_{i=1}^{n}d_i \times 10^{n-i} \leq 10^n-1`

���ǣ��� n>6 ��ʱ�� :math:`9^5 \times n < 10^{n-1}`, �����￪ʼ���󲻿����н���

.. code:: julia

    # when n>6, 9^5*n < 10^(n-1)
    #  so set the upper limit to 9^5*6 is safe

    ps = map(x->x^5, [0:9])
    s = 0
    for i in 2:9^5*6
        if sum(map(c->ps[c-'0'+1], collect(string(i)))) == i
            # println(i)
            s += i
        end
    end
    println(s)

31
---

��ʹ����ֵ 1p, 2p, 5p, 10p, 20p, 50p, ��1, ��2 ��ֵ��Ӳ�ң�һ���ж����ַ�ʽ��� ��2, 
���� ��1 = 100p

����� DP ���� ����������֪��ʹ����ֵ x ��Ӳ�ң����� a �� N[a] �ֱ�ʾ����
��Ȼ���� x ��ֵӲ��֮���� a>=x������ a �ı�ʾ�������� N[a] + N[a-x]��������Ȼ�� N[a]��
���ǿ�����ô���Ƴ��� ����

.. code:: julia

    cs = [1,2,5,10,20,50,100,200]
    ws = [0 for i in 1:200]

    for c in cs
        ws[c] += 1 # just c
        for v in c+1:200
            ws[v] += ws[v-c]
        end
    end

    println(ws[200])


32
---

�ҳ����� :math:`a \times b = c` �� :math:`a, b, c` ÿһλ������ɵ��б����ð��� 1 .. 9 ÿ�����ָ�һ��

.. code:: julia

    ps = Int[]
    one2nine = collect("123456789")

    function hasrep(n)
        s=string(n)
        for i in 2:length(s)
            if s[i-1]==s[i]
                return true
            end
        end
        return false
    end

    for i=2:2000
        if hasrep(i)
            continue
        end
        for j=i:2000
            p = i*j
            #if hasrep(j)
            #    continue
            #end
            s = string(i,j,p)
            if length(s)==9 && sort(collect(s))==one2nine
                push!(ps,p)
                println("$i x $j = $p");
            end
        end
    end

    sort!(ps)
    s = 0
    for i=2:length(ps)
        if ps[i-1]!=ps[i]
            s += ps[i-1]
        end
    end
    if ps[end]!=ps[end-1]
        s += ps[end]
    end
    println(s)

33
---

�ҳ����ӷ�ĸ������λ�����ܹ��ӷ��ӷ�ĸ�ϸ�ɾ��ͬһ��������ֵ����ķ���

:math:`11/22 = 1/2` ���� :math:`10/20 = 1/2` ������Ȼ�����ĳ���

.. code:: julia

    fs = Rational{Int64}[]

    for i in 12:98
        for j in i+1:99 
            # i = a*10 + b
            # j = c*10 + d
            a = int(floor(i/10))
            b = i%10
            c = int(floor(j/10))
            d = j%10
            if a==b || c==d
                continue
            end

            if (i//j == b//c && a==d ||
                i//j == a//d && b==c)
                push!(fs, i//j)
            end
        end
    end

    println(prod(fs))

34
---

�ҳ�����(ÿһλ���ֵĽ׳˵ĺ͵�������)�����ֵĺ�

�� 30_ �����Ƶ��ǣ�ֻҪ�ҵ�ֵ��ͺ�����

.. code:: julia

    # factorial(9) = 362880
    # for number has n digits, 1 <= sum of its factorial digits <= 362880n
    # for number has n digits, 10^(n-1) <= its value < 10^n

    fac = [(i=>factorial(i)) for i in 0:9]

    function digifacsum(n)
        s = 0
        while n>=1
            s += fac[n%10]
            n = int(floor(n/10))
        end
        return s
    end

    s = 0
    for i in 3:fac[9]*8
        if digifacsum(i)==i
            println(i)
            s += i
        end
    end
    println(s)

35
---

:math:`10^6` �����м�����������ѭ����λ��������

.. code:: julia

    function tonum(carr)
        v = 0
        for d in carr
            v *= 10
            v += d-'0'
        end
        return v
    end

    function circular(prm)
        res = Int[]
        col = collect(string(prm))
        for i in 2:length(col)
            push!(res, tonum(vcat(col[i:end], col[1:i-1])))
        end
        return res
    end

    cnt = 0
    for p in primes(1000000)
        iscircular = true
        for x in circular(p)
            if !isprime(x)
                iscircular = false
                break
            end
        end
        if iscircular
            # println(p)
            cnt += 1
        end
    end
    println(cnt)


36
---

�� :math:`10^6` ������ʮ������������¶��ǻ�����������֮��

.. code:: julia

    function ispalindrome(s::String)
        if length(s)<=2
            return s[1]==s[end]
        end
        return s[1]==s[end] && ispalindrome(s[2:end-1])
    end

    println(sum(filter(i->ispalindrome(string(i)) && ispalindrome(base(2,i)),
        [1:1000000])))


37
---

�������ÿ��ɾ��һλ������Ȼ������������֮�ͣ���֪һ���� 11 ������������

.. code:: julia

    ps = primes(1000000) # just guess

    function istruncatable(n)
        if n<10
            return false
        end
        x = n
        while x>=1
            if !isprime(x) return false end
            x = int(floor(x/10))
        end
        s = string(n)
        for i=2:length(s)
            if !isprime(int(s[i:end])) return false end
        end
        return true
    end

    cnt = 0
    s = 0
    for p in ps
        if istruncatable(p)
            println(p)
            s += p
            ++cnt
            if cnt==11
                break
            end
        end
    end
    println(s)


38
---

.. code:: julia

    ispandigital(s::String) = sort(collect(s)) == collect("123456789")
    +(s1::String,s2::String) = string(s1,s2)

    function guesspandigital(x)
        s = string(x)
        i = 2
        while length(s)<9
            s += string(x*i)
            i += 1
        end
        return s
    end

    ispandigitalmultiple(x) = ispandigital(guesspandigital(x))

    largest = 0
    for p in 2:10000 # 10000 -> 1000020000
        s = guesspandigital(p)
        if ispandigital(s) && largest<int(s)
            largest = int(s)
        end
        p += 1
    end

    println(largest)


39
---

�ʶ��� :math:`p \leq 1000`, :math:`p` ȡֵ���ٵ�ʱ�򷽳�

.. math::

    \begin{cases}
        a^2 + b^2 = c^2 \\
        a < b < c \\
        a+b+c = p 
    \end{cases}

�����Ľ�

.. code:: julia

    function numsolution(p)
        cnt = 0
        for a in 1:300
            for b in a+1:(p-a)/2
                c = sqrt(a*a+b*b)
                if isinteger(c) && a+b+c == p
                    cnt += 1
                end
            end
        end
        return cnt
    end

    x = 0
    n = 0
    for i in 1:1000
        ns = numsolution(i)
        if ns>n
            n = ns
            x = i
        end
    end
    println(x)


40
---

����������̫С�������ҵļ���������Ҿ�ֱ���������

��������ͼ�϶�����ϣ����ô���׵� - -

.. code:: julia

    +(s1::String,s2::String) = string(s1,s2)

    s = sum(map(string,[1:1000000]))
    println(prod(map(i->s[10^i]-'0', [0:6])))


41
---

�����İ��� :math:`[1, n]` ÿ�����ֵ� n λ����

��Ȼ n ���ᳬ�� 9��ֱ�ӴӺ���ǰ�Ұ��� :math:`[1, n]` ÿ�����ֵ����ж�һ��

.. code:: julia

    ps = Int[]
    tonum(li) = sum(map(i->li[i]*10^(length(li)-i), [1:length(li)]))

    for d in 9:-1:2
        found = false
        for p in permutations([d:-1:1])
            if isprime(tonum(p))
                push!(ps,tonum(p))
                found = true
                break
            end
        end
        if found
            break
        end
    end

    println(sort(ps)[end])


42
---

�ж�һ�����ǲ��� :math:`n(n+1)/2` �������⣬���������̾ͺ��� ����

.. code:: julia

    words = [...]
    istrianglenum(n)  = isinteger((sqrt(1+8n)-1)/2)
    istriangleword(w) = istrianglenum(sum(map(c->c-'A'+1, collect(w))))

    println(length(filter(istriangleword, words)))


43
---

��һ���Ѷ���ȫ����������� `this property`

... Ȼ��������ͱ�ʾ���ǡ��������ʡ���������˼���� :math:`d_2d_3d_4` ���Ա� 2 ������ :math:`d_3d_4d_5` ���Ա� 3 ���� ...

���� ����

.. code:: julia

    d   = [2,3,5,7,11,13,17]
    idx = [2:8]

    tonum(li) = sum(map(i->li[i]*10^(length(li)-i), [1:length(li)]))

    s = BigInt(0)
    for p in permutations([0:9])
        if p[1] == 0
            continue
        end
        m = true
        for i in idx
            if tonum(p[i:i+2])%d[i-1] != 0 
                m = false
                break
            end
        end
        if m
            println(tonum(p))
            s += tonum(p)
        end
    end
    println(s)


44
---

ͬ 42_, �ж�һ�������ǲ��� `pentagonal`, �ѷ��� :math:`P_n=n(3n-1)/2` ������ͺ���

.. code:: julia

    ub = 5000 #upper bound, guess
    pd = map(n->int(n*(3n-1)/2), [1:ub])
    ispentagon(n) = isinteger((1 + sqrt(1 + 24n))/6)

    # println(ispentagon(145))

    D = 2^62
    for i in [1:ub-1]
        for j in [i+1:ub]
            if  ispentagon(pd[i]+pd[j]) &&
                ispentagon(pd[j]-pd[i])
                # println("$i $j")
                D = minimum([D, pd[j]-pd[i]])
            end
        end
    end
    println(D)


45
---

ͬ��

.. code:: julia

    istriangle(n) = isinteger((sqrt(1+8n) - 1)/2)
    ispentagon(n) = isinteger((1 + sqrt(1 + 24n))/6)
    ishexagonal(n) = isinteger((1 + sqrt(1 + 8n))/4)

    P(n) = int(n*(3n-1)/2)
    n = 165+1

    while true
        p = P(n)
        if istriangle(p) && ishexagonal(p)
            println(p)
            break
        end
        n += 1
    end


46
---

����С�Ĳ��ܱ�ʾΪ :math:`prime + 2 \times x^2` �ĺ���

.. code:: julia

    ps = primes(1000000)

    function candivide(x)
        for p in ps
            if p>=x
                return false
            end
            if isinteger(sqrt((x-p)/2))
                return true
            end
        end
        return false
    end

    for i in 33:2:1000000
        if !isprime(i) && !candivide(i)
            println(i)
            break
        end
    end


47
---

����С�������ĸ��������ĸ���ͬ��������������

.. code:: julia

    numfactors = map(x->length(factor(x)), [1:1000000])
    for i in 4:length(numfactors)
        if numfactors[i] == numfactors[i-1] == numfactors[i-2] == numfactors[i-3] == 4
            println(i-3)
            break
        end
    end

48
---

�� :math:`1^1 + 2^2 + 3^3 + ... + 1000^1000` �����ʮλ����

���ӷ��ͳ˷�����ʱ�����Խ�ֹ�����ʮλ���� ���� ��Ҫע���������ʮ�����µ� 10 λ���� 64 λ������ʾ,
�˷�����������

.. code:: julia

    LIMIT = 10^10
    HALF  = 10^5

    type Truncated
        val::Int64
    end

    truncated(x::Int64) = Truncated(x%LIMIT)
    +(a::Truncated,b::Truncated) = truncated((a.val + b.val)%LIMIT)
    ==(a::Truncated,b::Truncated) = a.val == b.val
    function *(a::Truncated,b::Truncated) 
        a1 = int(floor(a.val/HALF))
        a2 = a.val%HALF
        b1 = int(floor(b.val/HALF))
        b2 = b.val%HALF
        low = a2 * b2 + a1 * b2 * HALF + a2 * b1 * HALF

        truncated(low % LIMIT)
    end
    ^(a::Truncated,b::Int) = reduce(*, Truncated(1), [a for i in 1:b])

    assert(sum(map(x->truncated(x)^x, [1:10]))==truncated(10405071317))

    println(sum(map(x->truncated(x)^x, [1:1000])))


49
---

��������λ���������ǳɵȲ����У��Ұ��������ֽ�������˳��ͬ

.. code:: julia

    ps = filter(x->x>1000, primes(9999))

    function ispermuation(x,y,z)
        return sort(collect(string(x))) == sort(collect(string(y))) == sort(collect(string(z)))
    end

    for i in 1:length(ps)-2
        for j in i+1:length(ps)-1
            if in(ps[j]*2-ps[i], ps) &&
                ispermuation(ps[i], ps[j], ps[j]*2-ps[i])
                println("$(ps[i]), $(ps[j]), $(ps[j]*2-ps[i])")
            end
        end
    end


50
---

�� 1000000 �����ܹ��������������������еĺͱ�ʾ������

.. code:: julia

    ps = primes(10000) # guess
    sm = [0, [p for p in ps]]
    for i in 2:length(sm)
        sm[i] += sm[i-1]
    end

    maxlen   = 1
    maxprime = 2
    for front in 1:length(sm)-1
        for back in front+1:length(sm)
            if sm[back]-sm[front]<1000000 && isprime(sm[back]-sm[front])
                len = back-front
                if len>maxlen
                    maxlen = len
                    maxprime = sm[back]-sm[front]
                    #println("$maxprime = sum(primes($front .. $(back-1))))")
                end
            end
        end
    end
    println("$maxprime -> $maxlen")


.. _Julia: http://julialang.org/
.. _`Project Euler`: http://projecteuler.net