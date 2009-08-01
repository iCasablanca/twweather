CocoaCryptoHashingTest: test.o CocoaCryptoHashing.o
	cc test.o CocoaCryptoHashing.o -framework Foundation -lcrypto -o CocoaCryptoHashingTest

test.o: test.m
	cc -std=c99 -c test.m

CocoaCryptoHashing.o: CocoaCryptoHashing.m CocoaCryptoHashing.h
	cc -c CocoaCryptoHashing.m

clean:
	rm -f CocoaCryptoHashing.o
	rm -f test.o
