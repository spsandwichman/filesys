var x = @["d","b","A","a","c"]

proc sort(list: var seq[string]) =
    for i in 0..list.high:
        var j = i
        while j > 0 and list[j-1] > list[j]:
            swap(list[j], list[j-1])
            j -= 1

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