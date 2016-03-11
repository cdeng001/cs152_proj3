CXX=g++
CXXFLAGS=-lfl -g
BISONFLAGS=-v -d --file-prefix=y
OBJS=bison.o lex.o

all: $(OBJS)
	$(CXX) $(OBJS) -o parser $(CXXFLAGS)
lex.o: lex.yy.c
	$(CXX) -c lex.yy.c -o lex.o
lex.yy.c: mini_l.lex
	flex mini_l.lex
bison.o: y.tab.c
	$(CXX) -c y.tab.c -o bison.o
y.tab.c: mini_l.y
	bison $(BISONFLAGS) mini_l.y
clean:
	rm -f parser y.tab.* lex.yy.* *.out* *.o *.mil *.stat
