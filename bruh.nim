import std/sequtils

var x = @["aaa","bbb","ccc","ddd","abc"]

proc sort(list: var seq[string]) =
    for i in 0..list.high:
        if list[i] > list[list.high]:
            swap(list[i], list[list.high])

echo x
sort(x)
echo x

# i ← 1
# while i < length(A)
#     j ← i
#     while j > 0 and A[j-1] > A[j]
#         swap A[j] and A[j-1]
#         j ← j - 1
#     end while
#     i ← i + 1
# end while