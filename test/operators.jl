c3 = complement(g3)
c4 = complement(g4)

@test nv(c3) == 5
@test ne(c3) == 6
@test nv(c4) == 5
@test ne(c4) == 16

g = reverse(g4)
@test re1 in edges(g)
reverse!(g)
@test g == g4

g = blkdiag(g3, g3)
@test nv(g) == 10
@test ne(g) == 8

h = PathGraph(2)
@test intersect(g3, h) == h

h = PathGraph(4)
z = difference(g3, h)
@test nv(z) == 5
@test ne(z) == 1
z = difference(h, g3)
@test nv(z) == 4
@test ne(z) == 0

z = symmetric_difference(h,g3)
@test z == symmetric_difference(g3,h)
@test nv(z) == 5
@test ne(z) == 1

h = Graph(6)
add_edge!(h, 5, 6)
e = Edge(5, 6)
z = union(g3, h)
@test has_edge(z, e)
@test z == PathGraph(6)

h = DiGraph(6)
add_edge!(h, 5, 6)
e = Edge(5, 6)
z = union(g4, h)
@test has_edge(z, e)
@test z == PathDiGraph(6)

g10 = CompleteGraph(2)
h10 = CompleteGraph(2)
z = blkdiag(g10, h10)
@test nv(z) == nv(g10) + nv(h10)
@test ne(z) == ne(g10) + ne(h10)
@test has_edge(z, 1, 2)
@test has_edge(z, 3, 4)
@test !has_edge(z, 1, 3)
@test !has_edge(z, 1, 4)
@test !has_edge(z, 2, 3)
@test !has_edge(z, 2, 4)

g10 = Graph(2)
h10 = Graph(2)
z = join(g10, h10)
@test nv(z) == nv(g10) + nv(h10)
@test ne(z) == 4
@test !has_edge(z, 1, 2)
@test !has_edge(z, 3, 4)
@test has_edge(z, 1, 3)
@test has_edge(z, 1, 4)
@test has_edge(z, 2, 3)
@test has_edge(z, 2, 4)

p = PathGraph(10)
x = p*ones(10)
@test  x[1]==1.0 && all(x[2:end-1].==2.0) && x[end]==1.0

@test size(p) == (10,10)
@test size(p, 1) == size(p, 2) == 10
@test size(p, 3) == 1

@test g5 * ones(nv(g5)) == [2.0, 1.0, 1.0, 0.0]
@test sum(g5, 1) ==  [0, 1, 2, 1]
@test sum(g5, 2) ==  [2, 1, 1, 0]
@test sum(g5) == 4
@test sum(p,1) == sum(p,2)
@test_throws ErrorException sum(p,3)

@test sparse(p) == adjacency_matrix(p)
@test eltype(p) == Float64
@test length(p) == 100
@test ndims(p) == 2
@test issymmetric(p)
@test !issymmetric(g5)

g22 = CompleteGraph(2)
h = cartesian_product(g22, g22)
@test nv(h) == 4
@test ne(h)== 4

g22 = CompleteGraph(2)
h = tensor_product(g22, g22)
@test nv(h) == 4
@test ne(h) == 1

nx = 20; ny = 21
G = PathGraph(ny); H = PathGraph(nx)
c = cartesian_product(G, H)
g = crosspath(ny, PathGraph(nx));
@test g == c

function crosspath_slow(len, h)
    g = h
    m = nv(h)
    for i in 1:len-1
        k = nv(g)
        g = blkdiag(g,h)
        for v in 1:m
            add_edge!(g, v+(k-m), v+k)
        end
    end
    return g
end
@test crosspath_slow(2, g22) == crosspath(2,g22)
